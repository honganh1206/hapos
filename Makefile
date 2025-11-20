OBJECTS = boot.o kernel.o
OS_NAME = hapos
CC = i686-elf-gcc
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld -o ${OS_NAME}.bin -ffreestanding -O2 -nostdlib
## GNU Assembler
AS = i686-elf-as
ASFLAGS = -f elf
QEMU = qemu-system-i386
ISO  = ${OS_NAME}.iso

QEMU_FLAGS = -cdrom

link:$(OBJECTS)
	# Combine object files to executable program
	$(CC) $(LDFLAGS) $(OBJECTS) -lgcc

iso:
	mkdir -p isodir/boot/grub
	cp ${OS_NAME}.bin isodir/boot/${OS_NAME}.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o ${ISO} isodir

run: hapos.iso
	$(QEMU) $(QEMU_FLAGS) $(ISO)

# Refer to pattern rule: https://makefiletutorial.com/
# Compile
%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

# Assemble
%.o: %.s
	$(AS) $< -o $@

clean:
	rm -rf *.o ${ISO}
