; Flag Quiz - created by ern0/Abaddon, 2025.03.09
; A 256-byte game for MS-DOS written in clean code assembly
; https://github.com/ern0/256byte-flagquiz

;----------------------------------------------------------------------------
COUNT   equ 17

	org 100H

        mov si,data             ; reset data pointer
        xor bp,bp               ; reset data item counter

        call clear_screen
next_flag:
        call load_data
        call display_flag
        call read_answer

        inc bp                  ; go with next flag, if any
        cmp bp,COUNT
        jne next_flag

        jmp exit
;----------------------------------------------------------------------------
clear_screen:

        mov ax,13H              ; set video mode and clear screen
        int 10H

        ret
;----------------------------------------------------------------------------
load_data:

        lodsw                   ; AL: color, AH: shifted tld-2 and 1-bit color
        mov bx,ax               ; copy 9-bit color to BX
        shr ah,1                ; shift back tld-2
        lodsb                   ; load tld-1, so AX now contains full tld

        mov di,print_tld        ; set DI to print area
        stosw                   ; copy to tld to print area

        ret
;----------------------------------------------------------------------------
display_flag:

        mov cx,3                ; number of colors in a flag

next_tricolor:
        call display_strip      ; display one strip, BL will be masked to 3-bit
        shr bx,3                ; shift next 3-bit
        loop next_tricolor      ; repeat strip

        ret
;----------------------------------------------------------------------------
display_strip:

        pusha                   ; save registers

        mov ch,4                ; number of strip segments: 4
        and bl,7                ; adjust color: keep only low 3 bits
        or bl,8                 ; adjust color: select light colors
.half:
        mov cl,10               ; width of the strip: 10
.char:
        xor bh,bh               ; page: 0 (whatever it means)
        mov ax,0edbH            ; character and function ID
        int 10H
        dec cl                  ; strip loop
        jne .char

        xor bl,bl               ; set color to black after first strip segment
        dec ch                  ; segment loop
        jne .half

        popa                    ; restore registers
        ret
;----------------------------------------------------------------------------
read_answer:

        mov dx,print_question   ; display question
        mov ah,9
        int 21H
.k1:
        call read_key           ; read first char
        mov dx,print_space
        cmp al,8
        je .print
        mov dl,al               ; store first char
.k2:
        call read_key           ; read second char
        cmp al,8                ; check for backspace
        jne .s2                 ; if not, skip to .s2
.bs:
        mov dx,print_backspace  ; clear character (space + BS)
.print:
        mov ah,9
        int 21H
        jmp .k1                 ; read first char again
.s2:
        mov dh,al               ; store second char, now DX contains both

        mov al,'x'              ; fail indicator
        cmp dx,word [print_tld] ; compare DX with correct answer
        jne .fail

        mov ax,[num]            ; load 2-digit result counter
        inc ah                  ; increment low digit
        cmp ah,':'              ; check overflow: '9' -> ':'
        jne .below10
        mov ah,'0'              ; reset low digit
        inc al                  ; increment high digit
.below10:
        mov [num],ax
        mov al,251              ; pass indicator (pipe)

.fail:
        mov DS:[BP + result],al ; copy indicator to the actual result position

        mov dx,print_answer     ; display the result
        mov ah,9
        int 21H

        ret
;----------------------------------------------------------------------------
read_key:
        mov ah,01H              ; read character
        int 21H
        cmp al,27               ; exit on ESC
        je  exit
        ret
;----------------------------------------------------------------------------
exit:
	int 20H
;----------------------------------------------------------------------------
print_backspace:
        db ' ',8,'$'
print_question:
        db "Guess TLD:"
print_space:
        db " $"
print_answer:
        db "? "
print_tld:
        db "cc!",10,"["
result:
        %rep COUNT
            db 249              ; empty slot indicator (little dot)
        %endrep
        db "] "
num:
        db "00/17",10,10,'$'
;----------------------------------------------------------------------------
data:
        %include "flagdata.inc"
;----------------------------------------------------------------------------
answer_buffer   equ $
