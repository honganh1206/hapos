global outb ; make label visible

; outb - send a byte to an I/O port
; stack structure: [esp + 8] the data byte
;				   [esp + 4] the I/O port
;		           [esp    ] return address

outb:
	mov al, [esp + 8] ; move data to be sent to al register
	mov dx, [esp + 4] ; move address of port to dx register
	out dx, al ; send data via I/O port
	ret ; return from function call
