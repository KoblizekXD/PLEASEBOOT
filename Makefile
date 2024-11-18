ASM := nasm
CC  := i686-elf-gcc

SRC     := src
INCLUDE := include
CONFIG  := config
BUILD   := build

BIN_OUT := $(BUILD)/kernel.bin
ISO_OUT := $(BUILD)/kernel.iso

CC_FLAGS  := -ffreestanding -nostdlib -O2 -I $(INCLUDE)
ASM_FLAGS := -f elf32
LD_FLAGS  := -T $(CONFIG)/linker.ld -nostdlib -ffreestanding -lgcc -o $(BIN_OUT)

C_SRC   := $(shell find $(SRC)/ -name '*.c')
ASM_SRC := $(shell find $(SRC)/ -name '*.asm')
C_OBJ   := $(C_SRC:%.c=$(BUILD)/%.o)
ASM_OBJ := $(ASM_SRC:%.asm=$(BUILD)/%.o)
OBJ_SRC := $(C_OBJ) $(ASM_OBJ)

$(ISO_OUT): $(BIN_OUT)
	@mkdir -p $(BUILD)/iso/boot/grub
	cp $(BIN_OUT) $(BUILD)/iso/boot/oskrnl.bin
	cp $(CONFIG)/grub.cfg $(BUILD)/iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO_OUT) $(BUILD)/iso/

all: $(BIN_OUT) $(ISO_OUT)
	qemu-system-x86_64 -cdrom $(ISO_OUT)

iso: $(ISO_OUT)
run: $(ISO_OUT)
	qemu-system-x86_64 -cdrom $(ISO_OUT)

$(BIN_OUT): $(OBJ_SRC)
	@mkdir -p $(dir $(BIN_OUT))
	$(CC) $(LD_FLAGS) $(OBJ_SRC)

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CC_FLAGS) -c $< -o $@

$(BUILD)/%.o: %.asm
	@mkdir -p $(dir $@)
	$(ASM) $(ASM_FLAGS) $< -o $@

clean:
	rm -rf $(BUILD)
	mkdir -p $(BUILD)

.PHONY: all clean iso
