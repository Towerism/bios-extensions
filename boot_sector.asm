;;  A simple boot sector program to test bios extensions
[org 0x7c00]                    ; expected immediate address for boot_sector

  mov [BOOT_DRIVE], dl          ; Store boot drive reported by BIOS in BOOT_DRIVE

  mov bp, 0x8000                ; Set up stack
  mov sp, bp

  mov bx, 0x9000                ; Load 5 sectors to 0x0000:0x9000 from the boot disk
  mov dh, 5
  mov dl, [BOOT_DRIVE]
  call disk_load

  mov dx, [0x9000]              ; Print out the first word of the loaded sector (should be 0xdada)
  call print_hex
  mov dx, [0x9000 + 512]        ; Print out the first word of the next sector (should be 0xface)
  call print_hex

  jmp $                         ; infinite loop

%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

BOOT_DRIVE: db 0

  times 510-($-$$) db 0           ; pad bootsector with 0's
  dw 0xaa55                       ; set last two bytes of boot_sector to the magic number

;; BIOS only loads the first sector (the boot sector consisting of 512 bytes) at startup
;; If the disk_load function works properly, this next sector should be loaded by it
  times 256 dw 0xdada           ; this is
  times 256 dw 0xface           ; the second sector
  times 2048 dw 0x0000          ; this is the next 4 sectors (since we will request 5 total)
