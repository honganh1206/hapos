ENTRY(loader) /* Name of entry label*/

SECTIONS {
		. = 0x00100000; /* Loaded at 1MB*/

		.text ALIGN (0x1000) : /* Align at 4KB*/
		{
				*(.text) /* All text (code) section from all file? */
		}

		.rodata	ALIGN (0x1000) :
		{
				*(.rodata*) /* Read-only data section from all files */
		}

		.data ALIGN (0x1000) :
		{
				*(.data) /* Data section from all files (Initialized global vars, stored in kernel file on disk)*/
		}

		.bss ALIGN (0x1000) :
		{
				/* Uninitialized global vars, where we reserve stack memory
				* take space in RAM */
				*(COMMON)
				*(.bss)
		}
}
