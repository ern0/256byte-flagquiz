; Flag Quiz - created by ern0/Abaddon, 2025.03.11
; A 256-byte game for MS-DOS written in clean code assembly
; https://github.com/ern0/256byte-flagquiz

;----------------------------------------------------------------------------
COUNT   equ 17                  ; number of flags

BS      equ 8                   ; some ASCII codes
LF      equ 10
ESC     equ 27

	org 100H                ; .COM program

        mov si,data             ; reset data pointer
        mov di,result           ; reset result pointer

        call clear_screen

next_flag:
        call load_flag_data
        call display_flag
        call read_answer
        call evaluate_answer

        cmp si,data + (3 * COUNT)
        jne next_flag           ; next round or fall exit
;----------------------------------------------------------------------------
exit:
	int 20H
;----------------------------------------------------------------------------
clear_screen:

        mov ax,13H              ; set video mode and clear screen
        int 10H
        ret
;----------------------------------------------------------------------------
load_flag_data:

        lodsw                   ; AL: color, AH: shifted tld-2 and 1-bit color
        mov bx,ax               ; copy 9-bit color to BX
        shr ah,1                ; shift back tld-2
        lodsb                   ; load tld-1, so AX now contains full tld

        mov [print_tld],ax      ; copy tld to print area

        ret                     ; BX contains the 9-bit flag data
;----------------------------------------------------------------------------
display_flag:                   ; display 3x 3-bit strips from BX

        mov cx,3                ; number of colors in a flag
next_tricolor:
        call display_strip      ; display one strip, BL will be masked to 3-bit
        shr bx,3                ; shift next 3-bit
        loop next_tricolor      ; repeat strip

        ret
;----------------------------------------------------------------------------
display_strip:                  ; display 3-bit strip from BX LSBs

        pusha                   ; preserve BX and CX

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
read_answer:                    ; read and print answer, backspace handling

        mov dx,print_question   ; display question
        mov ah,9
        int 21H
.k1:
        mov dl,print_space-100H ; half ptr
                                ; message for backspace
        call read_key           ; read first char
        jz .k1                  ; again, if backspace
        mov cl,al               ; store first char
.k2:
        mov dl,print_backspace-100H ; half ptr
                                ; message for backspace
        call read_key           ; read second char
        jz .k1                  ; again, if backspace
        mov ch,al               ; store second char, now DX contains both

        ret                     ; read keys are in CX
;----------------------------------------------------------------------------
read_key:                       ; read key to AL

        mov ah,01H              ; read character
        int 21H

        cmp al,ESC              ; check for escape key
        je  exit

        cmp al,BS               ; check for backspace key
        jne .ret                ; ZF is 0

        mov ah,9                ; print the correction
        int 21H
        xor ah,ah               ; set ZF to 1
.ret:
        ret                     ; key: AL, ZF=1: backspace
;----------------------------------------------------------------------------
evaluate_answer:                ; check answer, print progress bar and number

        mov bx,num_pass+1       ; pre-load pass ptr+1

        mov al,'x'              ; fail indicator
        cmp cx,[print_tld]      ; compare DX with correct answer
        jne .fail

        call inc2               ; increment pass value
        mov al,251              ; pass indicator (pipe)
.fail:
        stosb                   ; copy indicator to the actual result position

        mov bl,num_total-100H+1 ; half ptr+1
        call inc2               ; increment number of total

        mov dl,print_answer-100H ; half ptr
                                ; display the result
        mov ah,9
        int 21H

        ret
;----------------------------------------------------------------------------
inc2: ; increment 2-digit ASCII number, BX: pointer+1

        inc byte [bx]           ; increment low

        cmp byte [bx],':'       ; check for overflow
        jne .below10

        mov byte [bx],'0'       ; reset low
        inc byte [bx - 1]       ; increment high

.below10:
        ret
;----------------------------------------------------------------------------
print_backspace:                ; backspace itself does not clear the char
        db ' ',BS,'$'
print_question:
        db "Guess TLD:"
print_space:                    ; interleaved space for backspace handling
        db " $"
print_answer:
        db "? "
print_tld:
        db "tw!",LF,"["
result:
        %rep COUNT
            db 249              ; empty slot indicator (little dot)
        %endrep
        db "] "
num_pass:
        db "00/"
num_total:
        db "00 /"
        db (COUNT / 10) + 30H
        db (COUNT % 10) + 30H
        db LF,LF,'$'
;----------------------------------------------------------------------------
data:
        %include "flagdata.inc"
;----------------------------------------------------------------------------
answer_buffer   equ $
