/*
use snake_case to name functions and variables!
*/
#warn
#SingleInstance Force
#include DebugScript.ahk
#include PauseSuspendScript.ahk
sendmode "event"
setkeydelay 100

;Global Variables

my_pid:=""
my_title:=""

#hotif winactive("ahk_exe notion.exe")
;#hotif (!getkeystate("Shift")&&!getkeystate("ctrl"))
^Numpad1::send "^+1"
^Numpad2::send "^+2"
^Numpad3::send "^+3"
^Numpad4::send "^+4"
^Numpad5::send "^+5"
^Numpad6::send "^+6"
#hotif

#hotif winactive("ahk_exe Code.exe")
f1::vs_expand_selection(1)
f2::copy()
f3::paste()
f4::send "^{f4}"
f5::send "^/"
f7::vs_open_in_browser()
f8::vs_reindent()
f9::vs_bootstrap_lookup()
#hotif
#hotif winactive("ahk_exe chrome.exe")
F1::
{
	send "{f2}"
	select_all
	copy
	winactivate "ahk_exe code.exe"
	select_all
	paste
	
}
f2::multi_press_key(preF2Func)
preF2Func(press_count){
	if press_count==1{
		send "{f2}"
		}
	if press_count>=2{
		send "{f2}"
		select_all
		copy
		}
}

#hotif

f6::multi_press_key(preF6Func)
preF6Func(press_count){
	global my_title
	if press_count==1{
		winactivate "ahk_exe chrome.exe"
		chrome_find_tab(my_title)
		send "{f5}"
		return
		}
	if press_count>=2{
		Result := MsgBox("Would you like to save " . wingettitle("a") . "?",, "YesNo")
		if (Result = "Yes"){
			my_title:= wingettitle("a")
			msgbox "window " . my_title . " saved."
			}  
	}
}


f4::winrar_expand_all("D:\SYNC\PROJECTS PERSONAL\The Complete 2023 Web Development Bootcamp\Web Dev Projects")

;;chrome functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

chrome_find_tab(str){
	i:=0
	winactivate "ahk_exe chrome.exe"
	while 0==instr(wingettitle("a"),str){
		send "^{tab}"
		i++
		if i>19{
			return
			}
		}
	}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getAll(){
global my_pid:= wingetpid("a")
global my_title:= wingettitle("a")
msgbox my_pid . "`r`n" . my_title
}

winrar_expand_all(str){
	while winexist("ahk_exe WinRAR.exe"){
		winactivate
		myPid := WinGetPID("a")
		;Msgbox myPid
		click 99, 29
		sleep 200
		paste(str,,)
		sleep 200
		send "{enter}"
		if winexist("Confirm file replace")
			ControlClick "Button3", "Confirm file replace"
		sleep 200
		winclose "ahk_pid " . myPid
		sleep 200
	}
}

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
;;vscode motivated Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
vs_expand_selection(x){
	send "+!{right " . x . "}"
	}
vs_reindent(){
	send "^+p"
	paste("reindent")
	send "{enter}"
	}
vs_open_in_browser(){
	send "+!c"
	winactivate "ahk_exe chrome.exe"
	send "^t"
	paste()
	send "{enter}"
	}
vs_bootstrap_lookup(){
	copy()
	run "https://getbootstrap.com/"
	;sleep 800
	winwaitactive("Bootstrap")
	send "^k"
	paste()
	send "{enter}"
	}	

;;universal Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

select_all(){
	send "^a"
	}
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

paste(str:="",line_break:=0,remove_breaks:=0){
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
;;Made for Notion Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;;Made for Indd Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
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
tighten_tracking(){
	click 4
	send "!{left}"
	}
loosen_tracking(){
	click 4
	send "!{right}"
	}
	
;#include Indesign-findchange.ahk