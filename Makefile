.PHONY: all run clean
.DEFAULT: all

ASM_SOURCES = $(wildcard boot/*.asm)
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
BINARIES = $(shell find . -path "*.bin")
OBJECTS = $(shell find . -path "*.o")
OBJ = ${C_SOURCES:.c=.o}

all : os-image

run: os-image
	qemu-system-x86_64 -drive format=raw,file=os-image

os-image: boot/boot_sector.bin kernel/kernel.bin
	rm -f $@
	cat $^ > os-image
	dd if=/dev/zero bs=1 count=15360 >> os-image

boot/boot_sector.bin: ${ASM_SOURCES}
	nasm $< -f bin -o $@

kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf64 -o $@

%.o: %.c
	gcc -ffreestanding -c $< -o $@

clean:
	rm -f os-image ${OBJECTS} ${BINARIES}
