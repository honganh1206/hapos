
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif


#define VGA_WIDTH   80
#define VGA_HEIGHT  25
/*Address of VGA text mode buffer */
#define VGA_MEMORY  0xB8000 

/* Hardware text mode color constants. */
enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

/*Pack foreground/background color into 8-bit attribute */
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg)
{
		/*Isolate higher 4 bits for foreground and lower 4 bits for background */
		return fg | bg << 4;
}

/*Take a character plus the 8-bit color attribute
 * then pack them into a 16-bit value the VGA text buffer expects
 * char in low byte, color attribute in high byte */
static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
		return (uint16_t) uc | (uint16_t) color << 8;
}

/*Calculate string's length */
size_t strlen(const char* str)
{
		size_t len = 0;
		while (str[len]) {
			len++;	
		}
		return len;
}

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer = (uint16_t*) VGA_MEMORY;

void terminal_initialize(void)
{
		terminal_row = 0;
		terminal_column = 0;
		terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);

		for (size_t y = 0; y < VGA_HEIGHT; y++) {
				for (size_t x = 0; x < VGA_WIDTH; x++) {
						const size_t index = y * VGA_WIDTH + x;
						// Configure the buffer with foreground/background color?
						terminal_buffer[index] = vga_entry(' ', terminal_color);
				}
		}
}

void terminal_setcolor(uint8_t color)
{
		terminal_color = color;
}

/*Calculate index of entry and set the char and color */
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y)
{
		const size_t index = y * VGA_WIDTH + x;
		terminal_buffer[index] = vga_entry(c, color);
}

void terminal_putchar(char c)
{
		terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
		if (++terminal_column == VGA_WIDTH) {
				/*Reaching width capacity */
				terminal_column = 0;
				if (++terminal_row == VGA_HEIGHT)
				/*Reaching height capacity */
						terminal_row = 0;
		}
}

void terminal_write(const char* data, size_t size)
{
		for (size_t i = 0; i < size; i++)
				terminal_putchar(data[i]);
}

void terminal_writestring(const char* data)
{
		terminal_write(data, strlen(data));
}

/*
 * This kernel uses the VGA text mode buffer as the output device.
 * */
void kernel_main(void)
{
		terminal_initialize();
		terminal_writestring("Hello kernel world!\n");
}
