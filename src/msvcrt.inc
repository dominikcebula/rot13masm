; rot13masm
; Dominik Cebula
; dominikcebula@gmail.com
;
; Based on msvcrt.inc from MASM32
;

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

c_msvcrt typedef PROTO C :VARARG

externdef _imp__getchar:PTR c_msvcrt
getchar equ <_imp__getchar>

externdef _imp__puts:PTR c_msvcrt
puts equ <_imp__puts>

externdef _imp__strlen:PTR c_msvcrt
strlen equ <_imp__strlen>

externdef _imp__printf:PTR c_msvcrt
printf equ <_imp__printf>

externdef _imp__fopen:PTR c_msvcrt
fopen equ <_imp__fopen>

externdef _imp__fread:PTR c_msvcrt
fread equ <_imp__fread>

externdef _imp__fwrite:PTR c_msvcrt
fwrite equ <_imp__fwrite>

externdef _imp__fseek:PTR c_msvcrt
fseek equ <_imp__fseek>

externdef _imp__ftell:PTR c_msvcrt
ftell equ <_imp__ftell>

externdef _imp__fclose:PTR c_msvcrt
fclose equ <_imp__fclose>

externdef _imp__malloc:PTR c_msvcrt
malloc equ <_imp__malloc>

externdef _imp__free:PTR c_msvcrt
free equ <_imp__free>

externdef _imp__memset:PTR c_msvcrt
memset equ <_imp__memset>