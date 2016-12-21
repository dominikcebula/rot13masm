; rot13masm
; Dominik Cebula
; dominikcebula@gmail.com

; This file is part of rot13masm. rot13masm is free software: you can
; redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, version 2.
; 
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
; details.
; 
; You should have received a copy of the GNU General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 51
; Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
; 
; Copyright Dominik Cebula

.386
.model tiny, c
include msvcrt.inc

.data
err_rot13 db "Unsupported character at pos %d",0
err_read db "Error while opening input file", 0
err_write db "Error while creating output file",0
SEEK_SET equ 0
SEEK_END equ 2
readmode db "rb", 0
writemode db "wb", 0
hFile dword 0
hSize dword 0

.code
	rot13 proc buff:ptr, len:dword	; rot13 on memory block
		mov edi, buff	; save first byte of the memory blok to edi
		mov ecx, len	; size of the buffer to the ecx
		lp:
			.if byte ptr [edi]==32 || \
				byte ptr [edi]==13 || \
				byte ptr [edi]==10	; we do not analyze EOL and EOF characters
				inc edi
				loop lp
			.endif

			.if ecx==0		; extra condition for ending loop that makes rot13,
				mov eax, 0	; the point of this condition is not to analyze 
				ret			; current buffer byte if the last character of the stream is
			.endif			; not in A-Za-z

			.if !((byte ptr [edi]>='A' && byte ptr [edi]<='Z') || \	; check if character in A-Za-z
			      (byte ptr [edi]>='a' && byte ptr [edi]<='z'))				
				mov eax, edi	; we need to calculate index on which we have
				sub eax, buff	; unsupported character
				inc eax			; eliminate zero-based index
				ret
			.endif
			
			
			.if byte ptr [edi]>='A' && byte ptr[edi]<='Z'		; manage rot13 on A-Z
				add byte ptr [edi], 13		; move 13 characters forward
				.if byte ptr [edi]>'Z'		; if we jumped out of the alphabet
					sub byte ptr [edi], 26	; we need to wrap back
				.endif
			.elseif byte ptr [edi]>='a' && byte ptr[edi]<='z'	; manage rot13 on a-z
				add byte ptr [edi], 13		; move 13 characters forward
				.if byte ptr [edi]>'z'		; if we jumped out of the alphabet
					sub byte ptr [edi], 26	; we need to wrap back
				.endif
			.endif																	
																				
			inc edi		; move one byte forward in our memory block
			loop lp

		mov eax, 0	; everything is ok, procedure returns 0 as result
		ret
	rot13 endp

	srot13 proc	; rot13 on stdin/stdout
		invoke malloc, 255	; allocate memory block of 255 bytes
		mov esi, eax	; esi will keep beginning of the memory block
		invoke memset, esi, 0, 255	; zero the memory

		mov ecx, 0	; we will use ecx to count red characters
		rchar:
			push ecx	; use stack for save ecx value, getchar will modyfi ecx
			invoke getchar
			pop ecx		; get back ecx from the stack

			.if eax==13 || eax==10 || ecx>=254	; if EOL was red or the end of the buffer
				jmp rdone						; was reached we need to stop reading
			.else
				mov byte ptr [esi], al			; to the byte addresed by esi we are saving red character
				inc esi	; move one byte forward in the buffer
				inc ecx	; increase number of characters saved
				jmp rchar	; read next character
			.endif
		rdone:
			sub esi, ecx	; move esi to the beginning of red string
			invoke rot13, esi, ecx	; do rot13 on memory block
		
		.if eax==0		; if everything is ok
			invoke puts, esi
		.else
			invoke printf, offset err_rot13, eax	; unsupported character in the buffer
		.endif

		invoke free, esi	; free memory block
		ret
	srot13 endp

	frot13 proc from:ptr, to:ptr	; rot13 on the files
		push esi	; when argc==1 in main.cpp we have dynamically allocated char*,
					; if we will not save esi we will have problems with delete[]

		; first we need to read input from file
		invoke fopen, from, offset readmode	; open file in binary reading mode
		.if eax==0	; opening file failed
			invoke printf, offset err_read	; print out information
			mov eax, 1	; return error code
			pop esi	; get esi back from the stack
			ret
		.endif
		mov ds:hFile, eax		; save file handle
		
		invoke fseek, ds:hFile, 0, SEEK_END	; move to the end of the file
		invoke ftell, ds:hFile	; get file size
		mov ds:hSize, eax	; save file size
		invoke fseek, ds:hFile, 0, SEEK_SET	; move to the beggining of the file

		invoke malloc, ds:hSize	; wee need to allocate memory block for the file
		mov esi, eax	; esi will point at the beginning of the memory block
		invoke memset, esi, 0, ds:hSize	; zero memory
		invoke fread, esi, 1, ds:hSize, ds:hFile	; read the whole file into the buffer

		invoke fclose, ds:hFile	; we don't need to have input file opened anymore

		; rot13 on memory block
		mov ecx, ds:hSize	; save to ecx count of bytes
		invoke rot13, esi, ecx	; do rot13 on memory block
		.if eax>0	; if something goes wrong
			invoke printf, offset err_rot13, eax
			invoke free, esi	; free allocated memory block
			mov eax, 10	; return error code
			pop esi ; get esi back from the stack
			ret
		.endif
		
		; write memory block to the output file
		invoke fopen, to, offset writemode	; open file in binary read mode
		.if eax==0	; failed to open file
			invoke free, esi	; free allocated memory
			invoke printf, offset err_write
			mov eax, 2	; return error code
			pop esi ; get esi back from the stack
			ret
		.endif
		mov ds:hFile, eax	; save file handle
		invoke fwrite, esi, 1, ds:hSize, ds:hFile	; save memory block to the file
		invoke fclose, ds:hFile	; close file

		invoke free, esi ; free allocated memory
		mov eax, 0	; task was completed successfully
		pop esi ; get esi back from the stack
		ret
	frot13 endp
end
