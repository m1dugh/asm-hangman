extern malloc, free

global str_fmt, int_fmt, float_fmt
global len, blind_copy



section .data
	str_fmt db "%s", 10, 0
	int_fmt db "%d", 10, 0
	float_fmt db "%f", 10, 0



section .text

len:
	; rdi: null-terminated string
	; returns rax the string length
	mov rax, 0
	mov rbx, rdi
.loop:
	mov cx, [rbx]
	add rax, 1
	add rbx, 1
	test cx, cx
	jnz .loop
	sub rax, 1
	ret

blind_copy:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	; rdi: the null-terminated string
	; returns rax the blind_copy
	call len
	mov [rbp-8], rax
	; [rbp-8]=rdi:str.length
	mov rdi, rax
	call malloc
	mov [rbp-16], rax
	mov rdi, [rbp-8]
.loop:
	test rdi, rdi
	jz .exit
	mov BYTE [rax], '_'
	add rax, 1
	sub rdi, 1
	jnz .loop

.exit:
	mov rax, [rbp-16]
	mov rsp, rbp
	pop rbp
	ret
