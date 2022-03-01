extern printf

extern len, blind_copy

section .data
	msg db "Hello, World",0
	str_format db "%s",10,0


section .text
	global main

main:
	; printf(str_format, message);
	mov rax, 0
	mov rdi, str_format
	mov rsi, msg
	call printf

	; exit(0);
	mov rax, 60
	mov rdi, 0
	syscall 
