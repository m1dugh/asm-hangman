extern int_fmt
extern srand, rand, RAND_MAX
extern time

global randint


section .text

randint:
	push rbp
	mov rbp, rsp
	sub rsp, 24
	; args: range [rdi; rsi[
	; returns a random number between range
	mov [rbp-8], rdi
	mov [rbp-16], rsi
	mov rax, [rbp-16]
	sub rax, 1
	cmp rdi, rax
	jle .LC0
	;	if rdi >= rsi
	; 		rdi, rsi => rsi + 1, rdi + 1
	add QWORD [rbp-16], 1
	add QWORD [rbp-8], 1
	mov rax, [rbp-16]
	mov rbx, [rbp-8]
	mov [rbp-16], rbx
	mov [rbp-8], rax
.LC0:
	; random generator init
	mov edi, 0
	call time
	mov edi, eax
	call srand
	; generating random number
	mov rax, 0
	call rand
	xor rdx, rdx
	mov rbx, [rbp-16]; RAND_MAX
	mov rcx, [rbp-8]
	sub rbx, rcx
	div rbx
	
	add rdx, rcx
	mov rax, rdx
	mov rsp, rbp
	pop rbp
	ret
