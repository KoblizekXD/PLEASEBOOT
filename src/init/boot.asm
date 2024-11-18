[bits 32]
%define ARCH        0
%define MAGIC       0xE85250D6

extern _end
extern _edata
extern stack_top
extern stack_bottom

; #define MULTIBOOT_HEADER_TAG_ADDRESS  2
; #define MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS  3

section .multiboot
header:
	align 8
	dd MAGIC
	dd ARCH
	dd multiboot_header_end - header
	dd -(MAGIC + ARCH + (multiboot_header_end - header))
addr_tag_start:
	dw 0x02
	dw 1
	dd addr_tag_end - addr_tag_start
	dd header
	dd _start
	dd _edata
	dd _end
addr_tag_end:
entry_addr_tag_start:
	dw 0x03
	dw 1
	dd entry_addr_tag_end - entry_addr_tag_start
	dd _multiboot_entry
entry_addr_tag_end:
	dw 0x0
	dd 8
multiboot_header_end:

section .text
	global _start
	global _multiboot_entry

_start:
	jmp _multiboot_entry
_multiboot_entry:
	mov esp, stack_top
	push 0
	popf
	push ebx
	push eax
_loop:
	hlt
	jmp _loop
