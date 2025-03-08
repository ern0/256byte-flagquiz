; Flag Quiz - created by ern0/Abaddon, 2025
; A 256-byte game for MS-DOS written in clean code asm
; https://github.com/ern0/256byte-flagquiz

;-----------------------------------------------------
	org 100H

        lea si,[data]           ; reset data pointer
        mov bp,18               ; number of data items

next_flag:
        mov ax,0dH              ; set video mode and clear screen
        int 10H

        lodsw                   ; AL: 8-bit color, AH: shifted tld-2 and 1-bit color
        mov bx,ax               ; copy 9-bit color to BX
        shr ah,1                ; shift back tld-2
        lodsb                   ; load tld-1, so AX now contains full tld
        lea di,[print_tld]      ; set DI to print area
        stosw                   ; copy to tld to print area

        mov cx,3                ; number of colors in a flag
next_tricolor:
        call strip              ; print one strip, BL will be masked to 3-bit
        shr bx,3                ; shift next 3-bit
        loop next_tricolor      ; repeat strip

        lea dx,[print_start]
        mov ah,9
        int 21H

        xor ax,ax
        int 16H
        cmp al,27
        je  exit
        dec bp
        jne next_flag

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
strip:
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
