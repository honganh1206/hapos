OBJECTS = loader.o kmain.o
CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
	-nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c
LDFLAGS = -T link.ld -melf_i386
AS = nasm
ASFLAGS = -f elf
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

all: kernel.elf

kernel.elf:$(OBJECTS)
	# Combine object files to executable program
	ld $(LDFLAGS) $(OBJECTS) -o kernel.elf

hapos.iso: kernel.elf
	cp kernel.elf iso/boot/kernel.elf
	genisoimage -R \
		-b boot/grub/stage2_eltorito \
		-no-emul-boot \
		-boot-load-size 4 \
		-A hapos \
		-input-charset utf8 \
		-quiet \
		-boot-info-table \
		-o hapos.iso \
		iso

run: hapos.iso
	$(QEMU) $(QEMU_FLAGS)

# Compile
%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

# Assemble
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf *.o kernel.elf hapos.iso
