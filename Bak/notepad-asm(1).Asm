.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc

includelib kernel32.lib
includelib user32.lib

.data
	szTitle db "Haha", 0
	szCaption db "Notepad", 0

.data?

.const

.code
start:
	invoke MessageBox, 0, addr szTitle, addr szCaption, MB_OK
	invoke ExitProcess, 0

end start