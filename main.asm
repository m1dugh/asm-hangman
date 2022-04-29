extern printf

extern len, blind_copy, mutate_str
extern str_fmt, int_fmt
extern randint

section .data
	msg db "Hello, World",0


section .text
	global main

dig_str:
	; uncovers valid letters
	; rax: the secret word
	; rdi: the blind_copy
	; sil: the letter to discover
	; returns rax: the number of letters uncovered
	push rbp
	mov rbp, rsp
	sub rsp, 16
	; rbp-8: the changed count 
	; rbp-16: the blind_copy
	mov QWORD [rbp-8], 0
	mov [rbp-16], rdi
.loop:
	mov cl, [rax]
	test cl, cl
	jz .exit
	cmp cl, sil
	jne .LC0
	mov BYTE [rdi], sil
	mov rdx, [rbp-8]
	add rdx, 1
	mov [rbp-8], rdx
.LC0:
	add rax, 1
	add rdi, 1
	jmp .loop
.exit:
	mov rdi, [rbp-16]
	mov rax, [rbp-8]
	mov rsp, rbp
	pop rbp
	ret
	

main:
	; printf(str_format, message);
	mov rax, 0
	mov rdi, str_fmt
	mov rsi, msg
	call printf

	mov rdi, msg
	call blind_copy
	push rax

	mov rdi, rax
	mov rax, msg
	mov sil, 'o'
	call dig_str

	pop rsi
	mov rax, 0
	mov rdi, str_fmt
	call printf

	mov rdi, 3
	mov rsi, 5
	call randint

	mov rsi, rax
	mov rdi, int_fmt
	mov rax, 0
	call printf

	; exit(0);
	mov rax, 60
	mov rdi, 0
	syscall 
