Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd /c startFrpc.bat", 0, False
Set WshShell = Nothing
