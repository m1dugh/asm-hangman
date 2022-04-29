extern malloc, free

global str_fmt, int_fmt, float_fmt, chr_fmt
global len, blind_copy, mutate_str



section .data
	str_fmt db "%s", 10, 0
	int_fmt db "%d", 10, 0
	float_fmt db "%f", 10, 0
	chr_fmt db "%c", 10, 0



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
	mov [rbp-8], rdi
	; [rbp-8]: the string
	mov rdi, rax
	add rdi, 1
	call malloc
	mov [rbp-16], rax
	; rbp-16: the blind copy
	mov rdi, [rbp-8]
.loop:
	mov cl, [rdi]
	test cl, cl
	jz .exit
	mov BYTE [rax], '_'
	add rax, 1
	add rdi, 1
	jmp .loop

.exit:
	mov BYTE [rax], 0
	mov rax, [rbp-16]
	mov rsp, rbp
	pop rbp
	ret

mutate_str:
	; rax is the string to be mutated
	; rdi is the index to change
	; sil is the letter to replace with
	push rbp
	mov rbp, rsp
	
	mov rdx, rax
.loop:
	; if index found replace
	test rdi, rdi
	jz .replace

	; cx is the current char
	mov cx, [rdx]

	sub rdi, 1
	add rdx, 1
	test cx, cx
	jnz .loop
	jmp .exit

.replace:
	mov BYTE [rdx], sil
	
.exit:
	mov rsp, rbp
	pop rbp
	ret	
