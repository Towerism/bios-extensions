;; print_string function. argument: bx (string to print)
;; bx must point to a null terminated string
print_string:
  pusha
  mov ah, 0xe

print_string_loop:
  mov al, [bx]
  cmp al, 0x0
  je print_string_done
  int 0x10
  add bx, 0x1
  jmp print_string_loop

print_string_done:
  popa
  ret
