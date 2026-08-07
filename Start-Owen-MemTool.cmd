@echo off
setlocal
set "ROOT=%~dp0"
start "Owen MemTool" powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -STA -File "%ROOT%src\Owen-MemTool.ps1"
endlocal