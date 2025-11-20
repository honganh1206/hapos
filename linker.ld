/*
* The bootloader will look at this image
* and start execution at the symbol below
* designated as the entry point from boot.o*/
ENTRY(_start)

SECTIONS
{
		/*
		* Usually it is recommemded to use 1MB as start offset
		* (for storing legacy components).
		* But since UEFI has made things more complicated,
		* it is recommended to use 2M as a safer place to load.*/
		. = 2M;

		/*
		* First we put the multiboot header early
		* or the bootloader won't recognize the file format*/
		.text BLOCK(4K) : ALIGN(4K)
		{
				*(.multiboot)
				*(.text)
		}

		.rodata BLOCK(4K) : ALIGN(4K)
		{
				*(.rodata)
		}

		/* Read-write data initialized */
		.data BLOCK(4K) : ALIGN(4K)
		{
				*(.data)
		}

		/* Read-write data uninitialized and stack */
		.bss BLOCK(4K) : ALIGN(4K)
		{
				*(COMMON)
				*(.bss)
		}
}
