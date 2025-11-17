global loader ; Entry symbol for ELF

MAGIC_NUMBER equ 0x1BADB002 ; Magic number constant
FLAGS equ 0x0 ; multiboot flag
CHECKSUM equ -MAGIC_NUMBER ; calculate checksum (magic num + checksum + flags should equal 0 to veify integrity of Multiboot header?)

section .text:
align 4 ; Code must be 4-byte aligned
		dd MAGIC_NUMBER ; Write magic num to machine code
		dd FLAGS
		dd CHECKSUM
loader:
		mov eax, 0xCAFEBABE ; Loader label defined as entry point in linker script
.loop:
		jmp .loop ; loop forever
