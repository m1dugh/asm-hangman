extern printf

extern len, blind_copy, mutate_str
extern str_fmt, int_fmt, chr_fmt
extern randint

section .data
	msg db "Hello, World",0
	temp db "hangman", 0
	buffsize dq 1024
	maxtries dd 10			; the max number of tries

section .bss
	secret resq 1	; the pointer to the word 
	blind resq 1 	; the pointer to the blind copy
	tries resd 1	; the number of tries
	wlen resd 1		; the length of the string
	found resd 1	; the number of letters found

	data resb 1024	; the data that will be read
	chr resb 1		; the current character


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

read_input:
	; reads an input from stdin
	; returns al: the read character
	mov rax, 0			; read(
	mov rdi, 0			; 	stdin,
	mov rsi, data		; 	data,
	mov rdx, buffsize 	;	buffsize
	syscall 			; )

	mov al, [data]
	ret
	
	

main:
	; startup
	; sets up the secret word
	mov QWORD [secret], temp


	; sets up the length
	mov rdi, [secret]
	call len
	mov DWORD [wlen], eax

	; sets up the blind copy
	mov rdi, [secret]
	call blind_copy
	mov QWORD [blind], rax

	mov DWORD [found], 0

.loop:
	; reads char
	; prints character
	call read_input
	mov [chr], al
	
	xor rax, rax
	mov rdi, chr_fmt
	mov sil, [chr]
	call printf


	; checks if exists
	; changes blind
	mov rax, [secret]
	mov rdi, [blind]
	mov sil, [chr]
	call dig_str
	test rax, rax
	jz .wrong
	mov rdx, [found]
	add rdx, rax
	mov QWORD [found], rdx
	jmp .post_wrong
.wrong:
	mov edx, [tries]
	add edx, 1
	mov DWORD [tries], edx

	; checks the tries
	mov eax, [maxtries]
	cmp edx, eax
	jg .lost
	
.post_wrong:

	; prints blind
	xor rax, rax
	mov rdi, str_fmt
	mov rsi, [blind]
	call printf


	mov eax, [wlen]
	mov edx, [found]
	cmp edx, eax
	jl .loop
	; won 
	; you won in %d tries
	jmp .exit
.lost:
	; you lost ...

.exit:	

	; exit(0);
	mov rax, 60
	mov rdi, 0
	syscall 
