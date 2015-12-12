[org 0x7c00]

;; print_hex function. argument: dx (hexadecimal to print)
;; bx must point to a null terminated string
print_hex:
  pusha
  mov cx, 4                     ; set counter to 4

print_hex_loop:
  dec cx                        ; decrement counter
  mov ax, dx                    ; store hexadecimal in ax
  shr dx, 4                     ; divide hexadecimal by 4
  and ax, 0xf                   ; get last four bytes of ax
  cmp ax, 0xa                   ; compare ax to 10
  jl print_hex_set_letter       ; if it is a number, no need to add 7
  add ax, 0x7                   ; if it should be a letter, add 7 ('a'-'9')

print_hex_set_letter:
  mov bx, print_hex_HEX_OUT     ; load hex string address into bx
  add bx, 2                     ; add 2 (skip "0x")
  add bx, cx                    ; add counter (we start at least significant bit)
  add byte[bx], al              ; replace the character with the lower byte of ax
  cmp cx, 0
  jne print_hex_loop            ; keep looping as long as counter is not 0

print_hex_done:
  mov bx, print_hex_HEX_OUT
  call print_string             ; print out our new hex string

  mov cx, 4                     ; set counter to 4 again

print_hex_reset_HEX_OUT_loop:
  dec cx
  mov bx, print_hex_HEX_OUT
  add bx, 2
  add bx, cx
  mov byte[bx], '0'             ; this time we want to reset the character to '0'
  cmp cx, 0x0
  jne print_hex_reset_HEX_OUT_loop

  popa
  ret

print_hex_HEX_OUT:  db "0x0000", 0 ; null terminated
