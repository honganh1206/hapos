/*
What we do here: Set up the processor for C to be used
*/


/* Declare constants for the multiboot header */
.set ALIGN, 1<<0 /* value = 0001, align loaded modules on page boundaries? */
.set MEMINFO, 1<<1 /* value = 0010, provide memory map to the kernel */
.set FLAGS, ALIGN | MEMINFO /* value = 0011, Multiboot's flag field meaning both alignment and memory information are requested */
.set MAGIC, 0x1BADB002 /* Magic number lets bootloader find the header */
.set CHECKSUM, -(MAGIC+FLAGS) /* Checksum to prove we are multiboot (result equal 0 means verified integrity) */

/*
Declare a multiboot header that marks the program as a kernel.
Magic values documented in multiboot standard.
The bootloader will search for this signature in the first 8 KiB of the kernel file, aligned at a 32-bit boundary.
The signature is in its own section,
so the header can be forced to be within the first 8 KiB of the kernel file*/
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/*
The multiboot standard does not define the value of the stack pointer register (esp), so it's up to the kernel to provide a stack.
This allocates room for a small stack (stack_bottom) by creating a symbol at the bottom of it (How?) then allocate 16384 bytes for it, and finally create a symbol at the top.
On x86 architecture, the stack grows downward.
The stacks is in its own section so it can be marked nobits(allocated memory by the OS but not include in file), 
which means the kernel file is smaller because it does not contain an unintialized stack?
The stack on x86 must be 16-byte aligned, according to the System V ABI (Application Binary Interface) standard.
For now the compiler will assume the stack is properly aligned, and failure to align the stack will lead to undefined behavior
*/
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/*
*/
.section .text
.global _start
.type _start, @function
_start:
		/*
		Right now the bootloader has loaded us into 32-bit protected mode on x86 machine (How?).
		Interrupts are disabled, and paging is disabled too. The kernel has full control over the CPU.
		However, the kernel now can only make use of hardware features + any code it provides as part of itself.
		*/

		/*
		Set the esp register to point to the top of the stack, as it grows downwards the x86 system.
		This is done by Assembly, since C cannot function without a stack.
		*/
		mov $stack_top, %esp

		/*
		From here we initialize crucial processor state before high-level kernel is entered.
		Crucial features are not initialized yet. The GDT (what?) should be loaded here. Paging should be enabled here.
		Some features in C++ like global constructors and exceptions will require runtime support.
		*/

		/*
		Now enter the high-level kernel (what is it btw?).
		ABI requires the stack is 16-byte aligned and we already have it, so we can call the kernel.
		*/
		call kernel_main

		/*
		If the system has nothing more to do, put the computer into an halt-forever loop*/
		cli /* Disable interrupts with cli*/
1: 		hlt /* Wait for next interrupt to come with hlt (halt instruction). Since they(?) are disabled, this will lock up the computer */
		jmp 1b /* Jump to hlt instruction if the system wakes up */

/*
Set the size of _start symbol to the current location '.' (what for?) minus its start for debugging/call tracing?
*/

.size _start, . - _start
