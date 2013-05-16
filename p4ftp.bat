@echo off

::::: p4ftp.bat :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: A little Windows Batch Script to upload a Perforce ChangeList from console to a FTP host 
:: 
:: first argument is the change list number, and is mandatory.
:: second argument is an optional "1" flag, indicating no confirmation is desired.
::
:: usage (from console): p4ftp.bat <cl> [1]
:: usage (from perforce visual client, p4v): Tools > Manage Custom Tools, click on New Tool, 
:: 		fill in data, and under Arguments write "%C 1" (case sensitive, must be an uppercase c,
::			followed by a white space and the flag one)
::
:: limitations:
:: 		works only for straight-forward mappings
::		directory structure must already exist on the server, this script doesn't create the folders
::
:: On Github: https://github.com/lautarodragan/p4ftp
:: On Build Failure: http://buildfailure.wordpress.com/2013/05/15/windows-batch-script-ftp-upload-a-perforce-changelist/
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Constants
set ftp_host=github.com.ar
set ftp_username=user
set ftp_password=pass
set ftp_root=public_html
set p4root=C:/Perforce Workspaces/project

REM Arguments

if "%1"=="" (
	echo Changelist number not specified.
	exit /B n
)

REM Setup

Setlocal EnableDelayedExpansion
cd /D %p4root%

REM Confirmation

if not "%2"=="1" (
	echo changelist %1 has the following files:
	for /f "tokens=2 delims=# " %%g in ('p4 describe %1 ^| find "... //"') do (
		Setlocal EnableDelayedExpansion
		set line=%%g
		echo ...!line:~9!
	)

	set /p confirmation=Confirm upload? Yes/No: 

	if not !confirmation!==yes (
		echo Cancelled.
		exit /B n
	)

	
	echo Uploading...
	
)

REM The Magic

echo user %ftp_username% %ftp_password% > ftp.dat
echo cd %ftp_root% >> ftp.dat 

for /f "tokens=2 delims=# " %%g in ('p4 describe %1 ^| find "... //"') do (
	Setlocal EnableDelayedExpansion
	set line=%%g
	set filepath=!line:~9!
	set filepath=!filepath:main/=!
	echo put "!filepath!" "!filepath!" >> ftp.dat
)

echo close >> ftp.dat
echo quit >> ftp.dat

ftp -n -s:ftp.dat %ftp_host%

del ftp.dat
