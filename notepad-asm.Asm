.586
.model flat,stdcall
option casemap:none

   include windows.inc
   include user32.inc
   include kernel32.inc
   
   includelib user32.lib
   includelib kernel32.lib


WinMain proto :DWORD,:DWORD,:DWORD,:DWORD


.data
   ClassName db "MainWinClass",0
   AppName  db "Notepad ASM",0
   EditClass db "Edit",0
.data?
   hInstance HINSTANCE ?
   CommandLine LPSTR ?
   hEdit HWND ?

.const
   IDI_NOTEPAD equ 1000
   ;MainMenu.mnu
   IDR_MENU			equ 10000
   IDM_FILE			equ 10001
   IDM_OPEN			equ 10002
   IDM_Save			equ 10003
   IDM_BAR			equ 10004
   IDM_EXIT			equ 10005
   IDM_EDIT			equ 10006
   IDM_UNDO			equ 10007
   IDM_REDO			equ 10008
   IDM_CUT			equ 10009
   IDM_COPY			equ 10010
   IDM_PASTE			equ 10011
   IDM_HELP			equ 10012
   IDM_ABOUT			equ 10013
   IDM_BAR2			equ 10014
.code


; ---------------------------------------------------------------------------


start:
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	
	invoke GetCommandLine
	mov    CommandLine,eax
	
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	
	mov   wc.cbSize,SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,NULL
	push  hInstance
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_BTNFACE+1
	mov   wc.lpszMenuName,IDR_MENU
	mov   wc.lpszClassName,OFFSET ClassName
	
	invoke LoadIcon,NULL,IDI_NOTEPAD
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	
	invoke RegisterClassEx, addr wc
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	
	.WHILE TRUE
		invoke GetMessage, ADDR msg,NULL,0,0
		.BREAK .IF (!eax)
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
	.ENDW
	
	mov     eax,msg.wParam
	ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	LOCAL winRect:RECT
	LOCAL EditWidth:DWORD
	LOCAL EditHeight:DWORD
	
	.IF uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL
	.ELSEIF uMsg==WM_CREATE
		invoke LoadIcon,hInstance,IDI_NOTEPAD
		invoke SendMessage,hWnd, WM_SETICON, ICON_BIG, eax
		
		; Create text field
		invoke CreateWindowEx,WS_EX_CLIENTEDGE, offset EditClass, NULL, WS_MAXIMIZE or \
		WS_HSCROLL or WS_VSCROLL or WS_CHILDWINDOW or ES_AUTOHSCROLL or ES_AUTOVSCROLL or \
		ES_MULTILINE or WS_VISIBLE, 0, 0, 300, 300, hWnd, NULL, hInstance, NULL
		
		mov hEdit, eax
		
	.ELSEIF uMsg==WM_SIZE
		; Update text field size
		invoke GetWindowRect,hWnd, addr winRect
		mov eax, winRect.right
		sub eax, winRect.left
		sub eax, 6
		mov EditWidth, eax
		
		mov eax, winRect.bottom
		sub eax, winRect.top
		sub eax, 32
		mov EditHeight, eax
		
		invoke MoveWindow,hEdit, 0, 0, EditWidth, EditHeight, TRUE
		
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
	.ENDIF
	
	xor eax,eax
	ret
WndProc endp


end start
