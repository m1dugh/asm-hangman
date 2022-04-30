
global get_word

extern randint


section .data
	filename	db "words.txt"	; the file to read
	buffsize 	dd 1024			; the size of the buffer

section .bss
	buffer 	resb 1024	; the buffer
	lcount 	resd 1		; the count of lines
	chr		resb 1		; the current read char




section .text

get_word:
	; gets a random word
	; rbp-8: the file handle
	; rbp-8: the number of bytes read
	push rbp
	mov rbp, rsp
	sub rsp, 12
	
	; open the file
	mov rax, 2			; open(
	mov rdi, filename	;	filename,
	mov rsi, 0			; 	O_RDONLY,
	xor rdx, rdx		; 	WRITE
	syscall				; )
	mov rdx, 0
	cmp rax, rdx
	jle .exit
	mov [rbp-8], rax

.loop1:
	; read the file and count the number of lines
	; stores the number of bytes read
	xor rax, rax		; read(
	mov rdi, [rbp-8]	; 	fd,
	mov rsi, buffer		; 	buffer,
	mov rdx, [buffsize]	;	buffsize
	syscall				; )
	mov [rbp-12], eax	; stores the number of bytes
	; iterate over array
	mov edi, eax
	mov rax, buffer
.loop1_1:
	test edi, edi
	jz .exit1_1
	mov cl, [rax]
	add rax, 1
	sub edi, 1
	; if (cl == "\n")
	; 	counter++;

	jmp .loop1_1
	
.exit1_1:
	mov eax, [rbp-12]
	mov edx, [buffsize]
	cmp eax, edx
	jge .loop1
	; generate randint between 0 and lcount-1

	; find the length of the word
	; store the word on the buffer

	; malloc the size of the word
	
	; fill the array with the word

	; close the file
	mov rax, 3			; close(
	mov rdi, [rbp-8]	;	fd
	syscall				; )

.exit:
	; return the pointer to the word
	mov rsp, rbp
	pop rbp
	ret
