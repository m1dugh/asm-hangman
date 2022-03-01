section .text
	global len, blind_copy

len:
	; rsi: null-terminated string
	; returns rax the string length
	mov rax, 0
	ret

blind_copy:
	; rsi: the null-terminated string
	; returns rax the blind_copy
	mov rax, 0
	ret
