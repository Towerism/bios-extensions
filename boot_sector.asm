;;  A boot sector which enters 32-bit protected mode
[org 0x7c00]                    ; expected immediate address for boot_sector

  mov bp, 0x9000                ; initialize stack
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print_string

  jmp switch_to_pm

  jmp $

%include "bios-ext/print/print_string.asm"
%include "global_descriptor_table.asm"
%include "pm/print_string_pm.asm"
%include "pm/switch_to_pm.asm"

[bits 32]
; Entry point for protected mode
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm

  jmp $

MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0

  times 510-($-$$) db 0           ; pad bootsector with 0's
  dw 0xaa55                       ; set last two bytes of boot_sector to the magic number
