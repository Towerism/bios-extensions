.DEFAULT: all

all : os-image

os-image: boot_sector.bin kernel.bin
	rm -f os-image
	cat boot_sector.bin kernel.bin > os-image
	dd if=/dev/zero bs=1 count=15360 >> os-image

boot_sector.bin: boot_sector.asm pm/switch_to_pm.asm pm/print_string_pm.asm pm/global_descriptor_table.asm bios-ext/disk/disk_load.asm bios-ext/print/print_string.asm
	nasm boot_sector.asm -f bin -o boot_sector.bin

kernel.bin: kernel_entry.o kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.nasm -f elf -o kernel_entry.o

kernel.o: kernel.c
	gcc -ffreestanding -c kernel.c -o kernel.o

clean:
	rm os-image *.bin *.o
