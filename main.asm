extern printf

extern len, blind_copy
extern str_fmt, int_fmt
extern randint

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

	mov rdi, msg
	call blind_copy

	mov rsi, rax
	mov rax, 0
	mov rdi, str_fmt
	call printf

	mov rdi, 5
	mov rsi, 3
	call randint

	mov rsi, rax
	mov rdi, int_fmt
	mov rax, 0
	call printf

	; exit(0);
	mov rax, 60
	mov rdi, 0
	syscall 
