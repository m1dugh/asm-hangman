extern printf

extern len, blind_copy
extern str_fmt, int_fmt

section .data
	msg db "Hello, World",0


section .text
	global main

main:
	; printf(str_format, message);
	mov rax, 0
	mov rdi, str_fmt
	mov rsi, msg
	call printf

	mov rsi, msg
	call len

	mov rsi, rax
	mov rax, 0
	mov rdi, int_fmt
	call printf

	; exit(0);
	mov rax, 60
	mov rdi, 0
	syscall 
