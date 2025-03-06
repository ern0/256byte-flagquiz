; Flag Quiz, a 256-byte game for MS-DOS - (C)2025 ern0
; Compiler: NASM

;-----------------------------------------------------
	org 100H

        lea si,[data]   ; reset data pointer
        mov cx,18       ; number of data items

next_flag:
        mov ax,0dH      ; set video mode and clear screen
        int 10H
; 158

        lea di,[print_tld]

        lodsb
        mov bh,al
        shr al,1
        stosb

        lodsb
        mov bl,al

        movsb

        call line
        shr bx,3
        call line
        shr bx,3
        call line

        lea dx,[print_start]
        mov ah,9
        int 21H

        xor ax,ax
        int 16H
        cmp al,27
        je  exit
        loop next_flag

exit:
	mov ax,4c00H
	int 21H
;-----------------------------------------------------
print_start:
        db "TLD: "
print_tld:
        db "cc"
        db 13,10,'$'
;-----------------------------------------------------
line:
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
        ret
;-----------------------------------------------------
data:
        %include "flagdata.inc"
