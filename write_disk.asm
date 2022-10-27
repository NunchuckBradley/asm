[BITS 16]
[org 0x7c00]

start:
mov bx, waitInput
mov ah, 0x0e
printInputWait:
	mov al, [bx]
	cmp al, 0
	je readInput
	int 0x10
	inc bx
	jmp printInputWait

readInput:
mov bx, 0x8000

characters:
	mov ah, 0
	int 0x16
	cmp al, 13
	je writeDisk
	cmp al, 27
	je printDisk

	mov ah, 0x0e
	mov [bx], al
	int 0x10
	inc bx
	jmp characters

writeDisk:
mov ah, 0
mov [bx], ah
mov ah, 0x03
mov bx, 0x8000
jmp diskThing
printDisk:
mov ah, 0x02
mov bx, 0x7e00
jmp diskThing

diskThing:
mov al, 1 ; total sector count
mov ch, 0 ; cylinder/track, this is 0 based
mov cl, 2 ; sector, this is 1 based
mov dh, 0 ; head
mov dl, 0 ; drive, floppy
; dl should already be written
; mov bx, 0x7e00                  ; our origin in memory which to write to
int 0x13                        ; read boot interrupt

mov ah, 0x0e
printString:
        mov al, [bx]
        cmp al, 0
        je start
        int 0x10
        inc bx
        jmp printString

waitInput:
	dw 0x0d0a
        db "Text to write (enter=saves, esc=print): "
        dw 0x0d0a
        db 0

times 510-($-$$) db 0
dw 0xaa55

; Code after the boot sector
db "Text read from the sector"
dw 0x0d0a
db 0
