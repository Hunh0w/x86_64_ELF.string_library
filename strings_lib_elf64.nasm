BITS 64

global _start

section .text

; -------------------------------------------------

_strcpy:
mov r8, rdi  ; str1
mov r9, rsi  ; buffer
mov r10, rdx ; number start
xor r11, r11
call _strcpy_loop
ret
_strcpy_loop:
mov byte r12b, [r8+r11]
cmp r12b, 0
je _strcpy_end
mov byte [r9+r10], r12b
inc r11
inc r10
jmp _strcpy_loop
_strcpy_end:
ret

; -------------------------------------------------

_strlen:
mov r8, rdi ; str
xor r11, r11
call _strlen_loop
ret
_strlen_loop:
mov byte r12b, [r8+r11]
cmp r12b, 0
je _strlen_end
inc r11
jmp _strlen_loop
_strlen_end:
ret

; -------------------------------------------------

_strcat:
push rdi ; str1
push rsi ; str2
push rdx ; buffer
call _strlen
pop rsi
pop rdi
mov rdx, r11
push rsi
call _strcpy
pop rsi
pop rdi
xor rdx, rdx
call _strcpy
ret

; -------------------------------------------------

_charcat:
; rdi   str1
; rsi   char1
; rdx   buffer
push rdx
push rsi
push rdi
call _strlen
mov byte [rdx+r11], sil
mov rsi, rdx
xor rdx, rdx
call _strcpy
pop rdi
pop rsi
pop rdx
ret

; -------------------------------------------------

_strreverse:
push rdi        ; str
push rsi        ; buffer
mov r8, rdi     
lea r9, buffer2 ; buffer tool
call _strlen
xor r12, r12
call _strreverse_loop
mov rdi, r9
xor rdx, rdx
call _strcpy
pop rsi
pop rdi
ret
_strreverse_loop:
mov byte r10b, [r8+r12]
cmp r11, 0
jle _strreverse_end
dec r11
mov byte [r9+r11], r10b
inc r12
jmp _strreverse_loop
_strreverse_end:
ret

; -------------------------------------------------

_int2str:
mov r8, rdi ; int
mov r9, rsi ; buffer
push rdi
push rsi
xor r10, r10
mov r11, 10
call _int2str_loop
mov rdi, rsi
call _strreverse
pop rsi
pop rdi
ret
_int2str_loop:
cmp r8, 0
jle _int2str_end
xor rdx, rdx
mov rax, r8
div r11
mov r12, rdx
add r12b, 0x30
mov byte [r9+r10], r12b
mov r8, rax
inc r10
jmp _int2str_loop
_int2str_end:
mov byte [r9+r10], 0
ret


; -------------------------------------------------

_start:
mov rdi, 4005
lea rsi, buffer
call _int2str

lea rdi, buffer
mov rsi, 0xA
lea rdx, buffer
call _charcat

call _printbuff
jmp _exit

_printbuff:
mov rax, 1
mov rdi, 1
mov rsi, buffer
mov rdx, r11
syscall
ret

_exit:
mov rax, 60
mov rdi, 0
syscall

section .data
str1 db "spider-",0
str2 db "man",0xA,0

section .bss
buffer resb 500
buffer2 resb 200 ; for _strreverse !