;; A boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]                    ; expected immediate address for boot_sector
KERNEL_OFFSET equ 0x1000        ; memory offset to which we will load the kernel

  mov [BOOT_DRIVE], dl          ; store BIOS-reported boot drive

  mov bp, 0x9000                ; initialize stack
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  call load_kernel

  jmp switch_to_pm

  jmp $

%include "boot/bios-ext/print/print_string.asm"
%include "boot/bios-ext/disk/disk_load.asm"
%include "boot/pm/global_descriptor_table.asm"
%include "boot/pm/print_string_pm.asm"
%include "boot/pm/switch_to_pm.asm"

[bits 16]

load_kernel:
  pusha
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET         ; load kernel from disk
  mov dh, 15
  mov dl, [BOOT_DRIVE]
  call disk_load
  popa
  ret

[bits 32]
; Entry point for protected mode
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm
  call KERNEL_OFFSET            ; jump to the address of our loaded kernel code

  jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

  times 510-($-$$) db 0           ; pad bootsector with 0's
  dw 0xaa55                       ; set last two bytes of boot_sector to the magic number
