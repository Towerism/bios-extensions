[bits 32]
[extern main]

  ;; By having a separate object code to link with the kernel main
  ;; we will be able to always ensure that we can reach the main
  ;; function from the bootsrapping code

  call main                     ; invoke main in the C kernel

  jmp $
