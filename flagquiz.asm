	org 100H

	lea dx,[msg]
	mov ah,9
	int 21H
	mov ax,4c00H
	int 21H

msg:
	db "flagquiz",10,13,'$'
