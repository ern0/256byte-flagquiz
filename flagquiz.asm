; Flag Quiz, a 256-byte game for MS-DOS ; 2025, ern0

;-------------------------------------
	org 100H

        mov ax,0dH
        int 10H

        mov bl,4
        call line
        mov bl,7
        call line
        mov bl,2
        call line

        xor ax,ax
        int 16H

	mov ax,4c00H
	int 21H
;-------------------------------------
line:
        pusha

        mov ch,4
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
