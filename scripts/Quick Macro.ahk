/*
use snake_case to name functions and variables!
*/
#warn
#SingleInstance Force
#include DebugScript.ahk
#include PauseSuspendScript.ahk
sendmode "event"
setkeydelay 100
/*

;
/* indd Numpad---------------------------------------------------------
#hotif (!getkeystate("Shift")&&!getkeystate("ctrl"))
Numpad1::send "^{Numpad1}"
Numpad2::send "^{Numpad2}"
Numpad3::send "^{Numpad3}"
Numpad4::send "^{Numpad4}"
Numpad5::send "^{Numpad5}"
Numpad6::send "^{Numpad6}"
Numpad7::send "^{Numpad7}"
Numpad8::send "^{Numpad8}"
Numpad9::send "^{Numpad9}"
#hotif
/*--------------------------------------------------------------*/
#hotif winactive(".indd")
#hotif

;#hotif (!getkeystate("Shift")&&!getkeystate("ctrl"))
^Numpad1::send "^+1"
^Numpad2::send "^+2"
^Numpad3::send "^+3"
^Numpad4::send "^+4"
^Numpad5::send "^+5"
^Numpad6::send "^+6"
;#hotif

#hotif winactive("ahk_exe Code.exe")
Mbutton::{
	click
	send "+!c"
	winactivate "ahk_exe chrome.exe"
	send "^t"
	paste()
	send "{enter}"
}
f1::multi_press_key(vs_expand_selection)
f2::copy()
f3::paste()
f8::vs_reindent()	
	
f4:: send "^{f4}"
f5:: send "^/"
#hotif




multi_press_key(fn){
	;accepts a function fn that is dependent on the number of presses
	;function should only accept 1 
    static key_press_count := 0
    if key_press_count > 0
    {
        key_press_count += 1
        return
    }
    key_press_count := 1
    SetTimer After400, -400
    After400(){
		try{
		fn(key_press_count)
		}
		catch{
			msgbox "missing parameters.`r`n"
			. "please bind other parameter such that the only`r`n"
			. "parameter needed is number of presses"
		}
		key_press_count := 0
		return
		}
	}
/*
f2::multi_press_key(prefnF2)
	prefnF2(press_count){
	msgbox press_count . " times"
	}
*/



f4::{
	while winexist("ahk_exe WinRAR.exe"){
		winactivate
		myPid := WinGetPID("a")
		;Msgbox myPid
		click 99, 29
		sleep 200
		paste(,,"D:\SYNC\PROJECTS PERSONAL\The Complete 2023 Web Development Bootcamp\Web Dev Projects")
		sleep 200
		send "{enter}"
		if winexist("Confirm file replace")
			ControlClick "Button3", "Confirm file replace"
		sleep 200
		winclose "ahk_pid " . myPid
		sleep 200
	}
}

f6::{
	send "#t"	
	}
f7::{
	send "+!c"
	winactivate "ahk_exe chrome.exe"
	send "^t"
	paste()
}
f8::{
 if winexist("The Complete 2023 Web"){
  Msgbox "exists"
  }else{
  Msgbox "does not exist"
  }
}



#hotif winactive("ahk_exe Code.exe")

#hotif

#hotif winactive("ahk_exe notion.exe")
;tab::!tab
#hotif








;Rico Default Gsync Settings 
;forward button/xbutton2
f19::
	{
	}
;back button/xbutton2
f20::
	{
	}
;dpi change button	
f21::
	{
	}
	
	
;f1::
;style_sc("^{numpad3}")
;f2::repeat_key("a",10)
/*
Tab::page_down()
!tab::page_up()
^Tab::Full_page_view()
;*/


repeat_key(key,x){
	loop x
		send key
	}
quick(keys){
	send keys
	}
sound_play(){
	SoundPlay "*-1"
	}
;;vscode motivated Functions
vs_expand_selection(x){
	send "+!{right " . x . "}"
	}
vs_reindent(){
	send "^+p"
	send "reindent"
	send "{enter}"
	}

;;Notion Motivated Functions 
copy(){
	send "^c"
	}

remove_spaces(str,add_break:=0){
	temp_clipboard:=str
	str:=StrReplace(temp_clipboard, "`r`n"," ")
	if add_break
		str:= str . "`r`n"
	return str
	}

paste(line_break:=0,remove_breaks:=0,str:=""){
	if  StrLen(str) > 1
		A_clipboard:=str
	temp_clipboard:=A_clipboard
	if remove_breaks
		A_clipboard:=StrReplace(temp_clipboard, "`r`n"," ")
	send "^v"
	if line_break == 1
		send "{enter}"
	}
	
notion(){
	winactivate "ahk_exe Notion.exe"
	}


;;Indd Motivated Functions 
page_down(){
	send "!{pgdn}"
	}
page_up(){
	send "!{pgup}"
	}
Full_page_view(){
	send "^!0"
	}

Triple_Click_Delete(){
	click 3
	send "{del}"
	}

;#include Indesign-findchange.ahk

tighten_tracking(){
	click 4
	send "!{left}"
	}
loosen_tracking(){
	click 4
	send "!{right}"
	}
