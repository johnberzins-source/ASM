

section .data
    msg      db "Result: ", 0
    newline  db 10, 0

section .bss
    buffer   resb 32            ; Buffer for integer-to-string conversion

section .text
    global _start

_start:
    mov rdi, 10                 ; Calculate the 10th Fibonacci number
    call fib                    ; Result will be in RAX

    ; Convert result in RAX to string and print
    mov rdi, rax
    lea rsi, [buffer+31]        ; Start at end of buffer
    mov byte [rsi], 0           ; Null terminator
    mov rbx, 10                 ; Divisor for decimal conversion

.convert:
    xor rdx, rdx
    div rbx                     ; RAX / 10, remainder in RDX
    add dl, '0'                 ; Convert to ASCII
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert

    ; Print "Result: "
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, msg
    mov rdx, 8
    syscall

    ; Print the number
    mov rax, 1
    mov rdi, 1
    lea rsi, [rsi]              ; RSI already points to start of string
    mov rdx, 32
    syscall

    ; Exit program
    mov rax, 60                 ; sys_exit
    xor rdi, rdi
    syscall

; --- Recursive Fibonacci Function ---
fib:
    cmp rdi, 2                  ; Base case: if n < 2, return n
    jae .recurse
    mov rax, rdi
    ret

.recurse:
    push rdi                    ; Save current n on stack
    dec rdi                     ; Calculate n-1
    call fib
    push rax                    ; Save fib(n-1) result

    mov rdi, [rsp+8]            ; Restore original n from stack
    sub rdi, 2                  ; Calculate n-2
    call fib
    
    pop rbx                     ; RBX = fib(n-1)
    add rax, rbx                ; RAX = fib(n-2) + fib(n-1)
    add rsp, 8                  ; Clean up stack (n)
    ret
