#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#notrayicon
#MaxHotkeysPerInterval 200

global reflex, times, timeout

~WheelUp::volumeTaskbar("Volume_Up")
~WheelDown::volumeTaskbar("Volume_Down")
<#WheelUp::volumeTaskbarWin("Volume_Up")
<#WheelDown::volumeTaskbarWin("Volume_Down")
~MButton::volumeMute()
<#MButton::volumeMuteWin()

volumeTaskbar(cmd)
{
	checkTimeout()
	incrementStats()
	
	if mouseIsOnTray()
	{  			
		incrementVolume(cmd)
	}
	else
	{
		timeout++
	}
	
	return
}

volumeTaskbarWin(cmd)
{
	incrementStats()
	
	incrementVolume(cmd)
	
	return
}

volumeMute()
{		
	if mouseIsOnTray()
	{  		
		SendInput, {Volume_Mute}
	}
}

volumeMuteWin()
{		
	SendInput, {Volume_Mute}
}

checkTimeout()
{	
	if (A_TimeSincePriorHotkey >= 500)
	{
		timeout := 0
	}
	
	if (timeout >= 10)
	{
		timeout := 0
		Sleep, 250
		return
	}
}

incrementStats()
{
	if (A_PriorHotkey = A_ThisHotkey)
	{	
		if (A_TimeSincePriorHotkey < 15)
		{
			reflex := true
		}
		else
		{
			reflex := false
		}
		times++
	}
	else
	{
		reflex := false
		times := 1
	}
}

incrementVolume(cmd)
{	
	timeout := 0
	
	if ((reflex = true) and (times >= 6))
	{
		if ((A_ThisHotkey = "~WheelUp") or (A_ThisHotkey = "<#WheelUp"))
		{	
			SendInput, {%cmd%}{%cmd%}
		}		
		if ((A_ThisHotkey = "~WheelDown") or (A_ThisHotkey = "<#WheelDown"))
		{
			SoundSet -100
			SendInput, {%cmd%}
			Sleep, 100
		}
	}
	else if (GetKeyState("LButton", "P"))
	{
		SendInput, {%cmd%}
	}
	else
	{
		SendInput, {%cmd%}{%cmd%}
	}

}

mouseIsOnTray()
{
	mouseGetPos,,, wnd
	WinGetClass, cls, ahk_id %wnd%

	if InStr(cls, "TrayWnd")
	{  			
		return 1
	}	  
	return 0
}