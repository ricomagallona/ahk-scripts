/*
use snake_case to name functions and variables!
*/
#warn
#SingleInstance Force
#include PauseSuspendScript.ahk
sendmode "event"
setkeydelay 100

;Next developments
;make presets or settings ahk object notated


Global Variables
lastActiveWindow:=""
my_pid:=""
my_title:=""
save_folder:="D:\SYNC\PROJECTS PERSONAL\The Complete 2023 Web Development Bootcamp\Web Dev Projects\backend"
script_save_folder:=A_ScriptDir . "\"
quick_actions_settings_saveFolder:=""
	;initialized by quick_actions_settings_file.txt
	;used for winrar_expand_all
quick_actions_settings_file_path:= script_save_folder . "quick_actions_settings_file.txt"
debugger_log:=""
Try{
	quick_actions_settings_file := FileOpen("quick_actions_settings_file.txt", "rw")
	quick_actions_settings_file.pos := 0
	quick_actions_settings_saveFolder:=RegExReplace(quick_actions_settings_file.ReadLine(),"<.+>")
	;msgbox quick_actions_settings_saveFolder
}


#hotif winactive("ahk_exe notepad++.exe")

#hotif

#hotif winactive("ahk_exe notion.exe")
;#hotif (!getkeystate("Shift")&&!getkeystate("ctrl"))
^Numpad1::send "^+1"
^Numpad2::send "^+2"
^Numpad3::send "^+3"
^Numpad4::send "^+4"
^Numpad5::send "^+5"
^Numpad6::send "^+6"
^Numpad7::send "^+7"
^Numpad8::send "^+8"
^Numpad9::send "^+9"
#hotif

#hotif winactive("ahk_exe Code.exe")
f4::vs_expand_selection(1)
f2::copy()
f3::paste()

f5::send "^/" ;comment highlighted lines
f7::vs_open_in_browser()
f8::vs_reindent()
#hotif

/*#hotif winactive("ahk_exe chrome.exe")
f1::multi_press_key(preF2Func)
preF2Func(press_count){
	if press_count==1{
		send "{f2}"
		}
	if press_count>=2{
		send "{f2}"
		select_all
		copy
		}
#hotif
*/

f6::multi_press_key(preF6Func)
preF6Func(press_count){
Global my_title
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
			}  
	} 
}





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Quick actions----------------------------------

;1. make a function with you macro at the bottom
;2. Add to myChoiceMap and bind macro

myChoiceMap := Map()
myChoiceMap["Alert"] := testFn.bind()
myChoiceMap["Winrar: Expand All Open"] := winrar_expand_all.bind(quick_actions_settings_saveFolder)
myChoiceMap["Edit Script"] := editScript.bind()
myChoiceMap["Open Quick Actions Settings"] := Npp.bind(quick_actions_settings_file_path)
myChoiceMap["Localhost: 3000"] := chrome_link.bind("Localhost:3000")
myChoiceMap["VS Close Editors"] := vs_command.bind("close all editors")
myChoiceMap["PM Get Localhost:3000"] := pm_sendRequest.bind(1)
myChoiceMap["Chrome Copy Element, Paste in VS"]:= CDT_copy_paste_in_vs.bind()
myChoiceMap["Test"] := Npp.bind("D:\SYNC\Scripts\ahk Quick Macros\adhoc test.ahk")
myChoiceMap["Debug"] := debug.bind("",1)
myChoiceMap["Clear Debug"] := debugClear.bind()
myChoiceMap["Icue"] := icue.bind()
myChoiceMap["Notion"]:=notion.bind()
myChoiceMap["Close All"]:=closeAll.bind()
myChoiceMap["Bookmarks"]:=chrome_bookmarks_manager.bind()
myChoiceMap["Open Link"]:= chrome_link.bind()
myChoiceMap["Notion Combine Lines"]:=notion_combine_lines.bind()
myChoiceMap["Notion Break Lines"]:=notion_break_lines.bind()
myChoiceMap["Telegram"]:=chrome_link.bind("https://web.telegram.org/k/")
myChoiceMap["Gmail"]:=chrome_link.bind("https://mail.google.com/mail/u/0/#inbox")
myChoiceMap["Chat GPT"]:=chrome_link.bind("https://chat.openai.com/")
myChoiceMap["PS - Rotate"]:=ps_rotate_img.bind()
myChoiceMap["Window Spy"]:=ahk_window_spy.bind()


ahk_window_spy()
;myChoiceMap["quick test"]:=testFn.bind()
;QA Quick Actions options

#hotif winactive("ahk_id" . quickActionsGui.hwnd)
;tab::quickActionsFilter()
#hotif


quickActionsFilter(){
	str:= myInputText.text
	newComboChoices:=[]
	myListBox.delete()
	if StrLen(str)>0{
		strArr := strSplit(str," ")
		
		for key in myChoiceMap{
			strFound:=0
			
			for strPart in strArr{
				try{
				if RegExMatch(key, "i)" . strPart)
					strFound += 1
				}}
				
			if strFound = strArr.length
				newComboChoices.push(key)
			}
			
		}
			
		else{
		
			for key in myChoiceMap{
				newComboChoices.push(key)
				}
			
			}
	
	myListBox.add(newComboChoices)
	try{
		myListBox.choose(newComboChoices[1])
		}
		
	}
 


ComboChoices:=[]
for choice in myChoiceMap{
	ComboChoices.push(choice)
	}

quickActionsGui := Gui()
myInputText:= quickActionsGui.AddEdit("vMyEdit w300", "")
myListBox:=quickActionsGui.AddListBox("Choose1 r10 Sort vChosen W300",ComboChoices)
myListBox.OnEvent("DoubleClick", ProcessUserInput)
myInputText.OnEvent("Change", myListBoxChange)
quickActionsGui.OnEvent("Escape", EscapeCall)
quickActionsGui.OnEvent("Close", EscapeCall)
quickActionsGui.Title:="Quick Actions"

testFn(){
	;msgbox "Dir" . A_ScriptDir
	run "D:\SYNC\Scripts\ahk Quick Macros"
	}
	
myListBoxChange(*){
	quickActionsFilter()
	;msgbox "changed",, "t0.1"
	}
EscapeCall(*){
	return
	}
ProcessUserInput(*){
	Saved := quickActionsGui.Submit() 
		 try{
		 myChoiceMap[Saved.chosen]()
		 }
		}
QuickActions(){
	global lastActiveWindow
	try{
		lastActiveWindow := winGetTitle("a")
	}
	quickActionsGui.show
	myInputText.focus
	}

F1::quickactions

#hotif winactive("ahk_id" . quickActionsGui.hwnd)

Enter::	ProcessUserInput()
F1::ProcessUserInput()
NumpadEnter:: ProcessUserInput()
esc:: winClose "ahk_id" quickActionsGui.hwnd
~down::myListBox.focus
	
#hotif
;;Chrome developer Tools;;;;;;;;
CDT_copy_paste_in_vs(){
	send "{f2}"
	select_all
	copy
	winactivate "ahk_exe code.exe"
	select_all
	paste
}




;;chrome functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

chrome_link(url :=""){
	if (url == "")
		copy
		else
		a_clipboard := url
	if winexist("ahk_exe chrome.exe"){
		winactivate
		}
		else{
		run '"C:\Program Files (x86)\Google\Chrome\Application\chrome_proxy.exe"  --profile-directory=Default'
		winwaitactive "ahk_exe chrome.exe"
		}
		send "^t"
		send "^l"
			paste
			send "{enter}"
			
			
}

chrome_bookmarks_manager(){
	if winexist("ahk_exe chrome.exe"){
		winactivate
		}
		else{
		run '"C:\Program Files (x86)\Google\Chrome\Application\chrome_proxy.exe"  --profile-directory=Default'
		winwaitactive "ahk_exe chrome.exe"
		}
		send "^+o"
		
}


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
		;msgbox "debug"
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
			msgbox "missing parameters."
			. "`r`nplease bind other parameter such that the only"
			. "`r`nparameter needed is number of presses"
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
	;play sound
	SoundPlay "*-1"
	}
	

previousWin(){
	send "!{tab}"
	}
;multiFn(fns*){
;	For fn in fns*
;		Call(fn)
;		}
;;post man motivated Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Post Man
;pm(fn){
;	if winexist("ahk_exe postman.exe")
;		winactivate
;	else
;		run "postman.exe"
;	fn.call()
;		}
pm_sendRequest(returnToPreviousWindow:=0){
	try {
		winactivate "ahk_exe postman.exe"
		;controlsend  "^{enter},,ahk_exe postman.exe"
		send "^{enter}"
		if returnToPreviousWindow
			previousWin
		}
	catch{
	msgbox "postman not open"
	}
	}


;;vscode motivated Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;designed code to be executed while vs code window is active
vs(fn){
	if winexist("ahk_exe code.exe")
		winactivate
	else
		run "code.exe"
	fn.call()
		}
vs_expand_selection(x){
	send "+!{right " . x . "}"
	}
vs_reindent(){
	send "^+p"
	paste("reindent")
	send "{enter}"
	}
vs_command(str){
	send "^+p"
	paste(str)
	send "{enter}"	
}
vs_open_in_browser(){
	
	vs_command("save all files")
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
cut(){
	send "^x"
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
	
remove_spaces(str,add_break:=0){
	temp_clipboard:=str
	str:=StrReplace(temp_clipboard, "`r`n"," ")
	if add_break
		str:= str . "`r`n"
	return str
	}
	
editScript(){
	SelectedFile := FileSelect(, script_save_folder "\", "Open File")
			Npp(SelectedFile)
	}
	
Npp(file_path){
		runthis := "C:\Program Files (x86)\Notepad++\notepad++.exe `"" . file_path . "`"" 
		try
			Run runthis
		catch
			MsgBox "File does not exist.`r`n"
		}
closeAll(){
result := msgbox("Are you sure you want to close everything and shutdown?",,"YesNo")
if (result = "Yes"){
	IDList := WinGetList()
	for item in IDList
		winclose "ahk_id" item
	}
}


	
notion(){
	if !winExist("ahk_exe Notion.exe")
		run "C:\Users\User\AppData\Local\Programs\Notion\Notion.exe"
	else
		winactivate "ahk_exe Notion.exe"
	}
;;Made for Notion Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
notion_combine_lines(){
	cut
	a_clipboard := regexreplace(a_clipboard,"(`r`n)+","`r`n")
	paste
}

notion_break_lines(){
	send "^a"
	cut
	a_clipboard := regexreplace(a_clipboard,"`r`n","`r`n`r`n")
	paste
}

;;Made for Indd Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
indd_page_down(){
	send "!{pgdn}"
	}
indd_page_up(){
	send "!{pgup}"
	}
indd_Full_page_view(){
	send "^!0"
	}
indd_Triple_Click_Delete(){
	click 3
	send "{del}"
	}
indd_tighten_tracking(){
	click 4
	send "!{left}"
	}
indd_loosen_tracking(){
	click 4
	send "!{right}"
	}

Icue(){	
;settitlematchmode 2
;DetectHiddenWindows True
if !(winExist("iCUE")){
	Run "C:\Program Files\Corsair\Corsair iCUE5 Software\iCUE.exe"
	WinWaitActive ("iCUE")
	;icuePID := WinGetPID "iCUE"
	WinClose
	}}
	
;;Made for Indd Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
ps_rotate_img(){
	send "!ig9"
}

;#include Indesign-findchange.ahk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^F11::
	{
	sendtext "Msgbox `"`""
	}


F11::
{
	try
		Run "C:\Program Files (x86)\Notepad++\notepad++.exe `"" . A_ScriptFullPath . "`""
	catch
		MsgBox "File does not exist."
	return
}

F12::{
	try{
	winactivate "ahk_exe notepad++.exe"
	Send "^s"
	runThis:= winGetTitle("a")
	if  InStr(runThis, ".ahk" , 0){
		runThis:= strReplace(runThis," - Notepad++")
		quickFlash(regexreplace(runThis,".*\\") . " Script Will Be Launched")
		run runThis
		}else{
			msgbox "file not valid"
			}
	}
	}
quickFlashGui:=Gui()
quickFlashGui.SetFont("s20 cRed")
quickFlashGui.Title := ""
quickFlashText:=quickFlashGui.addtext("Center w800","") 
quickFlashGui.Opt("alwaysontop disabled -SysMenu")	
quickFlash(str,delay:=500){
	quickFlashText.text:= str,  A_screenwidth/2, A_screenheight/2
	quickFlashGui.show() 
	SetTimer () => quickFlashGui.hide(), 0-delay
	sleep delay	
	}

^F12::{
	Result := MsgBox("Would you like to Exit iCue and all AHK scripts?",, "YesNo")
	if Result == "Yes" {
		ProcessClose "icue.exe"
		exitapp
		}
	}  
#z::
	{
	copy
	run "C:\Program Files\AutoHotkey\v2\AutoHotkey.chm"
	winwait "AutoHotkey v2 Help"
	send "!s"
	paste
	send "{enter}"
	}
	
ahk_window_spy(){
	run "C:\Program Files\AutoHotkey\WindowSpy.ahk"
	}
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
debuggerGui:= gui()
debuggerGuiText:=debuggerGui.Add("edit" , "w200 r75", "str")

debugStr:=""

debuggerWin(){ 
	global debugStr
	debuggerGuiText.text:=debugStr
	debuggerGui.show("x0 y0 NA")
	}
debugClear(){
global debugStr:=""
}

debug(str,showDebuggerWin:=0){
	global debugStr
	if !strlen(str)
		str := InputBox("input variable you want to track", "Debug").value
	try{
		debugStr .= str . " := " . %str% . "`r`n"
		}
	catch{
		debugStr .= str . ": error /object /not found`r`n"
		}
	
	if showDebuggerWin
		debuggerWin()
	}

debug("A_titleMatchMode")