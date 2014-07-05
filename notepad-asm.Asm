.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc

includelib kernel32.lib

.data

.data?

.const

.code
start:
	invoke ExitProcess, 0

end start