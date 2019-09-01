.386
.model flat, stdcall
option casemap:none
include C:\masm32\include\windows.inc
include C:\masm32\include\masm32.inc
include C:\masm32\include\msvcrt.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\masm32.lib

; ������� ������
_DATA           SEGMENT

; ������ ����� ���� ���������
sogl		db 80h,81h,82h,83h,84h,85h,86h,87h,88h,89h,8Ah,8Bh,8Ch,8Dh
db 8Eh,8Fh,90h,91h,92h,93h,94h,95h,96h,97h,98h,99h,9Ah,9Bh 
db 9Ch,9Dh,9Eh,9Fh,0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h 
db 0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh,0E0h,0E1h,0E2h,0E3h 
db 0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh  

sogllen		equ $-sogl	
; ��������� ���-�� ���������� ��������
written		dd 0	
; ������� ������ �����
inputH          dword ?
; ������� ������ ������
outputH         dword ?

; ����� ��������� �������
con_title       db "��������� ����������",0
; ��������� ������
c0              dword ?	
; ������������� ����� � �������
str1            db "������� ����� ����� �������� �����",0 
; ����� ����� ������
keyboard_key    word 9 dup(?)	
; ������� "ENTER"
key_ent1        db 00h				

_DATA           ENDS

;������� ����
_TEXT           SEGMENT

start:

                ; ���������� ��� ������������ �������
                call FreeConsole
                ; ������� �������
                call AllocConsole
                ;�������� ������� �����
                push STD_INPUT_HANDLE
                call GetStdHandle
                mov inputH,eax
                ;�������� ������� ������
                push STD_OUTPUT_HANDLE
                call GetStdHandle
                mov outputH,eax

                ;������ ��������� ���� �������
                push offset con_title
                push offset con_title
                call CharToOem
                push offset con_title
                call SetConsoleTitle
                ;******************************
                ;������������� ������
                push offset str1
                push offset str1
                call CharToOem
                ;������� ������� ������ 
                ;print offset str1,13,10

                ; ��������� ������� ������
loo:
                ; ��������� ���� ������ � �������
                push offset c0
                push 1
                push offset keyboard_key
                push inputH
                call ReadConsoleInputA
                ; ��� �� ������� �� ����������?
				KEY_EV equ 1h
                cmp word ptr keyboard_key,KEY_EV
                jne loo
                ; ������ ��� ��������?
                cmp byte ptr keyboard_key+4,1
                jne loo
                ; ������� ������
                push 0
                push offset written
                push 1
                push offset byte ptr keyboard_key+14
                push outputH
                call WriteConsoleA
                ; ����, �����?
                ; ENTER
                cmp byte ptr keyboard_key+14,0Dh
                je ent
                ; ������� ESC
                cmp byte ptr keyboard_key+14,27
                je exit_program
                ; �������� ����������� �����
                mov al,byte ptr keyboard_key+14
                ; ���������� ����
                mov ecx,sogllen		
                ; ������ ������� �������
                lea ebx,sogl		
loo1:	
                ; ������� ������� �������� ����������?
                cmp [ebx],al		
                ; ���� ���, ��������� � ���������
                jnz nots					
                invoke Beep,600h,50h
                jmp loo
nots:	
                ; ��������� � ��������� ����� ���������
                inc ebx			
                loop loo1		
                jmp loo
                ; ��������� ENTER
ent:
                ; ������� ����������� ������� LF(������ �������) � CR(������� ������)
                ;print offset key_ent1,10,13
                jmp loo


                ; ������� �������
exit_program:
                call FreeConsole
                ; ��������� �������
                invoke ExitProcess, 0
_TEXT           ENDS
                end start