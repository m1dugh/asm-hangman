global str_fmt, int_fmt, float_fmt

section .data
	str_fmt db "%s", 10, 0
	int_fmt db "%d", 10, 0
	float_fmt db "%f", 10, 0



section .text
	global len, blind_copy

len:
	; rsi: null-terminated string
	; returns rax the string length
	mov rax, -1
	mov rbx, rsi
.loop:
	mov cx, [rbx]
	add rax, 1
	add rbx, 1
	test cx, cx
	jnz .loop
	ret

blind_copy:
	; rsi: the null-terminated string
	; returns rax the blind_copy
	mov rax, 0
	ret
