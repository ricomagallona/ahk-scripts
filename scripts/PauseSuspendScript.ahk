#SuspendExempt  ; Exempt the following hotkey from Suspend.
Pause::
	{
		Suspend -1
		if A_IsSuspended
		{
			ToolTip "Script Suspended"
		}else{
			ToolTip "Script Active"
		}
		SetTimer () => ToolTip(), -5000
	}
#SuspendExempt False 
+Pause::ExitApp ;Exit Script
!Pause::Pause
