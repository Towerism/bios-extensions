.PHONY: all run clean
.DEFAULT: all

all : os-image

run: os-image
	qemu-system-x86_64 -drive format=raw,file=os-image

os-image: boot_sector.bin kernel.bin
	rm -f $@
	cat $^ > os-image
	dd if=/dev/zero bs=1 count=15360 >> os-image

boot_sector.bin: boot_sector.asm pm/switch_to_pm.asm pm/print_string_pm.asm pm/global_descriptor_table.asm bios-ext/disk/disk_load.asm bios-ext/print/print_string.asm
	nasm $< -f bin -o $@

kernel.bin: kernel_entry.o kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf64 -o $@

kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

clean:
	rm os-image *.bin *.o
