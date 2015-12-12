;;  A simple boot sector program too test bios extensions
  [org 0x7c00]                  ; expected immediate address for boot_sector

  mov dx, 0x1fb7
  call print_hex                ; print 0x1fb7
  mov dx, 0x0000
  call print_hex                ; print 0x0000

jmp $                           ; infinite loop

%include "print_hex.asm"

times 510-($-$$) db 0           ; pad with 0's
dw 0xaa55                       ; set last two bytes of boot_sector to the magic number
