@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for admin permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Please Grant Admin Permissions.
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
taskkill /F /IM CxAudioSvc.exe
taskkill /F /IM CxUtilSvc.exe
taskkill /F /IM MicTray64.exe
net start CxAudioSvc
net start CxUtilSvc
powershell -c (New-Object Media.SoundPlayer "C:\Windows\media\Ring01.wav").Play(); Start-Sleep -s 5; Exit;
