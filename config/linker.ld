ENTRY(_start)

SECTIONS
{
	. = 2M;

	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}
	
	.data :
	{
		*(.data)
		_edata = .;
	}

	.bss :
	{
		*(.bss)
		stack_bottom = .;
		. += 16384;
		stack_top = .;
		_end = .;
	}
}
