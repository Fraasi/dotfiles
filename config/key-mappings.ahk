﻿#Requires AutoHotkey v2.0
#SingleInstance Force

; #Warn  ; Enable warnings to assist with detecting common errors.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; modifier keys, Ctrl (^), Alt (!), Shift (+) and Win (#), eg. Ctrl+Shift+" === ^+"
; ControlSend Keys , Control, WinTitle, WinText, ExcludeTitle, ExcludeText]

; prevent fn + f10 = win + p
#p::return

; AltGr + - = emdash
;^-::Send "—"

;----mpv global keybindings----

; altGR+m adjust mpv volume = shift+m
!^m::ControlSend '+{m}', , 'ahk_class mpv'

; altGR+p Play/Pause
!^p::ControlSend '{Space}', , 'ahk_class mpv'

; alt+o = shift+o in mpv
!^o::ControlSend '+{o}', , 'ahk_class mpv'

; delete-file-next, Shift+DEL
+Del::ControlSend '+{Del}', , 'ahk_class mpv'

; altGr+f focus mpv.exe & put in fullscreen, if focused move focus back to previous window
;!^f::ControlSend '{f}', , 'ahk_class mpv'
!^f::{
	activeWin := WinGetProcessName("A")
	static active_id := WinGetID("A") ; needed in else, activeWin not workin there
	if not (activeWin = 'mpv.exe') {
		active_id := WinGetID("A")
		if WinExist("ahk_class mpv") {
			WinActivate 'ahk_class mpv'
      ControlSend '{f}', , 'ahk_class mpv'
		}
	} else {
    ControlSend '{f}', , 'ahk_class mpv'
		WinActivate 'ahk_id ' active_id
	}
}

; altGr+- focus or start mpv.exe, if focused move focus back to previous window
!^-::{
	activeWin := WinGetProcessName("A")
	static active_id := WinGetID("A") ; needed in else, activeWin not workin there
	if not (activeWin = 'mpv.exe') {
		active_id := WinGetID("A")
		if WinExist("ahk_class mpv") {
			WinActivate 'ahk_class mpv'
		} else {
			Run 'mpv.exe'
		}
	} else {
		WinActivate 'ahk_id ' active_id
	}
}

; altGr+, focus or start terminal, if focused move focus back to previous window
!^,::{
	activeWin := WinGetProcessName("A")
	static active_id := WinGetID("A") ; needed in else, activeWin not workin there
	if not (activeWin = 'WindowsTerminal.exe') {
		active_id := WinGetID("A")
		if WinExist("ahk_exe WindowsTerminal.exe") {
			WinActivate 'ahk_exe WindowsTerminal.exe'
		} else {
			Run 'WindowsTerminal.exe'
		}
	} else {
		WinActivate 'ahk_id ' active_id
	}
}


; altGr+. focus or start vivaldi, if focused move focus back to previous window
!^.::{
	activeWin := WinGetProcessName("A")
	static active_id := WinGetID("A") ; needed in else, activeWin not workin there
	if not (activeWin = 'vivaldi.exe') {
		active_id := WinGetID("A")
		if WinExist("ahk_exe vivaldi.exe") {
			WinActivate 'ahk_exe vivaldi.exe'
		} else {
			Run 'vivaldi.exe'
		}
	} else {
		WinActivate 'ahk_id ' active_id
	}
}
