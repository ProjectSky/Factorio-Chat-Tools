DetectHiddenWindows, On
chartTitle = Factorio input tools
gameTitle = ahk_exe factorio.exe

IME_STARTCOMPOSITION := 0
IME_ENDCOMPOSITION := 0

WM_IME(wParam, lParam, msg, hwnd)
{
	global IME_STARTCOMPOSITION, IME_ENDCOMPOSITION
	if msg = 269
	{
		IME_STARTCOMPOSITION := 1
		IME_ENDCOMPOSITION := 0
	}
	else if msg = 270 
	{
		IME_ENDCOMPOSITION := 1
		IME_STARTCOMPOSITION := 0
	}
}

loop 
{
	WinWaitNotActive, %chartTitle%
	IfWinExist, %chartTitle%
	{
		IfWinNotActive, %gameTitle%
			Gui, Hide
		else 
			Gui, Show
	} 
}

#IfWinActive, Factorio input tools
ESC::
IfWinExist, %chartTitle%
{
	Gui, Destroy
	IME_STARTCOMPOSITION := 0
	IME_ENDCOMPOSITION := 0
	ControlSend, ,{ESC}, %gameTitle%
	Return
} else 
{
	ControlSend, ,{ESC}, %gameTitle%
	Return
}
Enter::
IfWinActive, %chartTitle%
{
	If(IME_STARTCOMPOSITION > 0 && IME_ENDCOMPOSITION < 1) 
	{
		IME_STARTCOMPOSITION := 0
		IME_ENDCOMPOSITION := 0
		SendInput, {Shift}
		SendInput, {Shift}
		return
	}

	Gui, submit
	if(ChartText != "") 
	{
		current_clipboard = %Clipboard%
		clipboard = ""
		clipboard = %ChartText%
		Sleep, 50
		;Send ^v
		SendMessage, 0x100, 17, 0, , %gameTitle%
		SendMessage, 0x100, 86, 0, , %gameTitle%
		SendMessage, 0x101, 86, 0, , %gameTitle%
		SendMessage, 0x101, 17, 0, , %gameTitle%
		ControlSend, ,{Enter}, %gameTitle%
		clipboard = ""
		clipboard = %current_clipboard%
	} 
	else 
	{
		Sleep, 50
		ControlSend, ,{Enter}, %gameTitle%
	}
	Gui, Destroy
	IME_STARTCOMPOSITION := 0
	IME_ENDCOMPOSITION := 0
	return
} else {
	ControlSend, ,{Enter}, %gameTitle%
	return
}

#IfWinActive, ahk_exe factorio.exe
`::
WinGetPos, X, Y, W, H, %gameTitle%
chartX := X + 40
chartY := Y + H - 30
IfWinNotExist, %chartTitle%
{
	current_clipboard = %Clipboard%
	clipboard := "Factorio chart"
	PostMessage, 0x100, 17, 0, , %gameTitle%
	clipboard := "Factorio chart1"
	if clipboard = Factorio chart1
	{
		ControlSend, ,~, %gameTitle%
	}
	clipboard = %current_clipboard%
	
	Gui, Add, Edit, x1 y1 w300 h20 vChartText
	Gui,-Caption +Owner
	Gui, Show, x%chartX% y%chartY% h21 w303, %chartTitle%
	OnMessage(0x10D, "WM_IME")
	OnMessage(0x10E, "WM_IME")
	Return
}