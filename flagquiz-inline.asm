COUNT   equ 17
BS      equ 8
LF      equ 10
ESC     equ 27
	org 100H
        mov si,data
        mov di,result
	; begin clear_screen
        mov ax,13H
        int 10H
	; end clear_screen
next_flag:
	; begin load_flag_data
        lodsw
        mov bx,ax
        shr ah,1
        lodsb
        mov [print_tld],ax
	; end load_flag_data
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
        mov dl,print_space-100H
        call read_key
        jz .k1
        mov cl,al
.k2:
        mov dl,print_backspace-100H
        call read_key
        jz .k1
        mov ch,al
	; end read_key
	; begin evaluate_answer
        mov bx,num_pass+1
        mov al,'x'
        cmp cx,[print_tld]
        jne .fail
        call inc2
        mov al,251
.fail:
        stosb
        mov bl,num_total-100H+1
        call inc2
        mov dl,print_answer-100H
        mov ah,9
        int 21H
	; end inc2
        cmp si,data + (3 * COUNT)
        jne next_flag
exit:
	int 20H
read_key:
        mov ah,01H
        int 21H
        cmp al,ESC
        je  exit
        cmp al,BS
        jne .ret
        mov ah,9
        int 21H
        xor ah,ah
.ret:
        ret
inc2:
        inc byte [bx]
        cmp byte [bx],':'
        jne .below10
        mov byte [bx],'0'
        inc byte [bx - 1]
.below10:
        ret
print_backspace:
        db ' ',BS,'$'
print_question:
        db "Guess TLD:"
print_space:
        db " $"
print_answer:
        db "? "
print_tld:
        db "tw!",LF,"["
result:
        %rep COUNT
            db 249
        %endrep
        db "] "
num_pass:
        db "00/"
num_total:
        db "00 /"
        db (COUNT / LF) + 30H
        db (COUNT % LF) + 30H
        db LF,LF,'$'
data:
        %include "flagdata.inc"
answer_buffer   equ $
