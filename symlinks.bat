@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
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

cd /D "%~dp0"

set folders[0]="IRE_AndroidUI"
set folders[1]="IRE_Scoreboard"
set folders[2]="rp_models"
set folders[3]="rp_nametags"
set folders[4]="WORP"
set folders[5]="WORP_Server"
set folders[6]="WORP_VehicleEngine"
set folders[7]="IRE_Shaders"

for /F "tokens=2 delims==" %%s in ('set folders[') do mklink /D "./%%s/Shared" "..\Shared"

pause