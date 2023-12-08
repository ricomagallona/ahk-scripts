

myGui:=Gui()
myGui.SetFont("s20 cRed")
myGui.Title := ""
myGuiText:=myGui.addtext("Center w800","") 
myGui.Opt("alwaysontop disabled -SysMenu")


^F11::
	{
	sendtext "Msgbox `"`""
	}


F11::
{
	try
		Run "C:\Program Files (x86)\Notepad++\notepad++.exe `"" A_ScriptFullPath "`""
	catch
		MsgBox "File does not exist."
	return
}

F12::{
	winactivate "ahk_exe notepad++.exe"
	Send "^s"
	runThis:= winGetTitle("a")
	runThis:= strReplace(runThis," - Notepad++")
	;tooltip regexreplace(runThis,".*\\") . " Script Launched",  A_screenwidth/2, A_screenheight/2
	;SetTimer () => ToolTip(), -5000
	myGuiText.text:= regexreplace(runThis,".*\\") . " Script Will Be Launched",  A_screenwidth/2, A_screenheight/2
	myGui.show()
	SetTimer () => myGui.hide(), -500
	sleep 500
	run runThis
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
send "^c"
run "https://www.autohotkey.com/docs/v2/"
winwaitactive("Quick Reference")
send "!s"
send "^v" 
}