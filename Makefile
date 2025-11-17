
QEMU = qemu-system-i386
ISO  = hapos.iso

QEMU_FLAGS = \
    -m 32 \
    -cdrom $(ISO) \
    -boot d \
    -display sdl \
    -rtc base=localtime \
    -smp 1 \
    -D qemu.log

run:
	$(QEMU) $(QEMU_FLAGS)
