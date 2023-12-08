/*
instrusctions
open photoshop first before running script

*/

#warn
#SingleInstance Force
#include DebugScript.ahk
#include PauseSuspendScript.ahk
sendmode "event"
setkeydelay 100
SetControlDelay 100

main()

main(){
global
MyGui:=Gui()
MyGui.Title:= "Book Specs"
myCombo:=MyGui.AddComboBox("vBSPreset",BSpresetsFn())

MyGui.AddText("xs ys+30 w20","Units:")
gui_unit1:=MyGui.AddRadio("checked vUnit w100", "Inches")
gui_unit2:=MyGui.AddRadio(, "Millimeters")
gui_unit3:=MyGui.AddRadio(, "Pixels")
MyBtnSave:= MyGui.AddButton("Default w80", "SavePreset")
MyGui.AddText("ys+30", "Book Width:")
MyGui.AddText(, "Book Height:")
MyGui.AddText(, "Spine:")
MyGui.AddText(, "Top Margin:")
MyGui.AddText(, "Bot Margin:")
MyGui.AddText(, "Inside Margin:")
MyGui.AddText(, "Outside Margin:")
MyGui.AddText(, "Bleed:")
gui_bw:=MyGui.AddEdit( "ys+30 r1 vBW w100")
gui_bh:=MyGui.AddEdit( "r1 vBH wp")
gui_sp:=MyGui.AddEdit( "r1 vSP wp")
gui_tm:=MyGui.AddEdit( "r1 vTM wp")
gui_bm:=MyGui.AddEdit( "r1 vBM wp")
gui_im:=MyGui.AddEdit( "r1 vIM wp")
gui_om:=MyGui.AddEdit( "r1 vOM wp")
gui_bl:=MyGui.AddEdit( "r1 vBl wp")
MyBtn:= MyGui.AddButton("Default w80", "OK")
MyBtn.onEvent("Click",ProcessUserInput)
MyBtnSave.onEvent("Click",SavePreset)
MyGui.OnEvent("Close", MyGui_Close)
MyCombo.OnEvent("Change", MyGui_Change)
myGui.show
}


BSpresetsFn(){
	BSpresets:=[]
	i:=0
	Loop read, "Book specs presets.txt"
	{
		i++
		if ((i>10)&&(Mod(i,10)==1))
			BSpresets.push(A_LoopReadLine)
			}
	return BSpresets
}	


SavePreset(*){
	FileObj := FileOpen("Book specs presets.txt","a")
	
	FileObj.writeline(InputBox("Enter New Preset Name", "Save New Preset",, "New Preset").value)
	if gui_unit1.value==1
		FileObj.writeline("in")
	if gui_unit2.value==1
		FileObj.writeline("mm")
	if gui_unit3.value==1
		FileObj.writeline("px")
	FileObj.writeline(gui_bw.text)
	FileObj.writeline(gui_bh.text)
	FileObj.writeline(gui_sp.text)
	FileObj.writeline(gui_tm.text)
	FileObj.writeline(gui_bm.text)
	FileObj.writeline(gui_im.text)
	FileObj.writeline(gui_om.text)
	FileObj.writeline(gui_bl.text)
	FileObj.close
	MyGui.Destroy()
	main()
}



MyGui_Change(*){
	getflag:=0
	getcount:=0
	bookspecArray:=[]
	Loop read, "Book specs presets.txt"{
		if A_LoopReadLine==MyCombo.Text{
			getflag:=1
			}
		if getflag==1{
			getcount++
			bookspecArray.push(A_LoopReadLine)
			}
		if getcount>=10
			break
			
	}
	Changepreset(bookspecArray)
}
Changepreset(x){
if x[2]=="in"
	gui_unit1.value:=1
if x[2]=="mm"
	gui_unit2.value:=1
if x[2]=="px"
	gui_unit3.value:=1
	
gui_bw.text:=x[3]
gui_bh.text:=x[4]
gui_sp.text:=x[5]
gui_tm.text:=x[6]
gui_bm.text:=x[7]
gui_im.text:=x[8]
gui_om.text:=x[9]
gui_bl.text:=x[10]
}

MyGui_Close(*){
	exitapp
	}
	
ProcessUserInput(*){
	Saved:=myGui.submit()
	
	winactivate "ahk_exe Photoshop.exe"
	send "^n"
	WinWait "New"
	winactivate
	
	send "{tab 3}"
	send "{up 6}"
	if (Saved.unit==1){
		Saved.unit:="in"
		send "{down 1}"
		}
	if (Saved.unit==2){
		Saved.unit:="mm"
		send "{down 3}"
		}
	if (Saved.unit==3){
		Saved.unit:="px"
		
		}
	send "+{tab}"
	
	send ((2*Saved.bl)+(2*Saved.bw)+Saved.sp)
	send "{tab 2}"
	send ((2*Saved.bl)+Saved.bh)
	send "{enter}"
	;winwaitclose "New"
	;Msgbox "debug"
	PlaceGuides(Saved)
	;for k, v in Saved.OwnProps()
	;	s .= k "=" v "`n"
	;MsgBox s
	exitapp
}

PlaceGuides(s){
	GuidePlacementX :=[
		"0" . s.unit,
		s.BL . s.unit,
		s.BL+s.OM . s.unit,
		s.bl+s.bw-s.im . s.unit,
		s.bl+s.bw . s.unit,
		s.bl+s.bw+s.sp . s.unit,
		s.bl+s.bw+s.sp+s.im . s.unit,
		s.bl+s.bw+s.sp+s.bw-s.om . s.unit,
		s.bl+s.bw+s.sp+s.bw . s.unit,
		2*s.bl+2*s.bw+s.sp . s.unit]
		
	GuidePlacementY :=[
		"0" . s.unit,
		s.bl . s.unit,
		s.bl+s.tm . s.unit,
		s.bl+s.bh-s.bm . s.unit,
		s.bl+s.bh . s.unit,
		2*s.bl+2*s.bh . s.unit
		]
	/*
	debugstring:=""
	loop GuidePlacementX.length
		debugstring.=GuidePlacementX[a_index] . "`r`n"
	loop GuidePlacementY.length
		debugstring.=GuidePlacementy[a_index] . "`r`n"
	msgbox debugstring
	*/
Loop GuidePlacementX.Length
    PlaceGuide("v",GuidePlacementX[A_Index])
	
Loop GuidePlacementY.Length
    PlaceGuide("h",GuidePlacementY[A_Index])
	
	}

PlaceGuide(orientation,x){
	send "!ve"
	winwait "New Guide"
	if (orientation == "v"){
		send "+{tab}v"
		}else{
		send "+{tab}h"
		}
	send "{tab}"
	send x
	send "{enter}"
	;controlclick "Button3"
	}
	
