@echo off

goto main


:stop
echo Stoping "%1 "
VBoxManage controlvm %1 poweroff
goto :eof


:stop_secure
setlocal enabledelayedexpansion
set example=
for /f "tokens=1 delims= " %%n in ('VBoxManage list runningvms') do (
	if "!example!" == "" (
		set example=%%~n
	)
	if "%%~n" == "%1" (
		call :stop %1
		exit /b 0
	)
)
echo. >&2
echo ��������������������%example%
endlocal
exit /b 8

:stop_batch
if "%1"=="all" (
	for /f "tokens=1 delims= " %%n in ('VBoxManage list runningvms') do (
		call :stop %%~n
	)
) else (
	call :stop_secure %1
)
exit /b 0

:main
setlocal enabledelayedexpansion
set /a n=1
for /f "tokens=1 delims= " %%n in ('VBoxManage list runningvms') do (
	set name=%%~n
	
	:: �޲�ʱ��ӡ
	if "%1" == "" (
		echo !n!.!name!
	)
	
	set /a n+=1
)
if %n% == 1 (
	echo ���������е������
	exit /b 0
)
endlocal

:: �޲�
if "%1" == "" (
	set /P keyword=������������ƹرգ�
	call :stop_batch %keyword%
	exit /b 0
)

:: ����
call :stop_batch %1
exit /b 0


