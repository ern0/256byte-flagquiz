; generated from flagquiz.com, inlined some functions
COUNT   equ 17
	org 100H
        mov si,data
        xor bp,bp
	; begin clear_screen
        mov ax,13H
        int 10H
	; end clear_screen
next_flag:
	; begin load_data
        lodsw
        mov bx,ax
        shr ah,1
        lodsb
        mov di,print_tld
        stosw
	; end load_data
	; begin display_flag
        mov cx,3
next_tricolor:
	; begin display_strip
        pusha
        mov ch,4
        and bl,7
        or bl,8
.half:
        mov cl,10
.char:
        xor bh,bh
        mov ax,0edbH
        int 10H
        dec cl
        jne .char
        xor bl,bl
        dec ch
        jne .half
        popa
	; end display_strip
        shr bx,3
        loop next_tricolor
	; end display_strip
	; begin read_answer
        mov dx,print_question
        mov ah,9
        int 21H
.k1:
        call read_key
        mov dx,print_space
        cmp al,8
        je .print
        mov dl,al
.k2:
        call read_key
        cmp al,8
        jne .s2
.bs:
        mov dx,print_backspace
.print:
        mov ah,9
        int 21H
        jmp .k1
.s2:
        mov dh,al
        mov al,'x'
        cmp dx,word [print_tld]
        jne .fail
        mov ax,[num]
        inc ah
        cmp ah,':'
        jne .below10
        mov ah,'0'
        inc al
.below10:
        mov [num],ax
        mov al,251
.fail:
        mov DS:[BP + result],al
        mov dx,print_answer
        mov ah,9
        int 21H
	; end read_key
        inc bp
        cmp bp,COUNT
        jne next_flag
        jmp exit
read_key:
        mov ah,01H
        int 21H
        cmp al,27
        je  exit
        ret
exit:
	int 20H
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
            db 249
        %endrep
        db "] "
num:
        db "00/17",10,10,'$'
data:
        %include "flagdata.inc"
answer_buffer   equ $
