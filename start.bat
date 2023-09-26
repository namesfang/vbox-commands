@echo off

goto main


:start
VBoxManage startvm %1 --type headless
goto :eof


:start_secure
setlocal enabledelayedexpansion
set example=
for /f "tokens=1 delims= " %%n in ('VBoxManage list vms') do (
	if "!example!" == "" (
		set example=%%~n
	)
	if "%%~n" == "%1" (
		call :start %1
		exit /b 0
	)
)
echo. >&2
echo 虚拟机名称输入错误，例：%example%
endlocal
exit /b 8


:start_batch
if "%1"=="all" (
	for /f "tokens=1 delims= " %%n in ('VBoxManage list vms') do (
		call :start %%~n
	)
) else (
	call :start_secure %1
)
exit /b 0


:main
if "%1" == "" (
	setlocal enabledelayedexpansion
	set /a n=1
	for /f "tokens=1 delims= " %%n in ('VBoxManage list vms') do (
		set name=%%~n
		echo !n!.!name!		
		set /a n+=1
	)
	endlocal
	set /P keyword=输入名称启动虚拟机：	
	call :start_batch %keyword%
	exit /b 0
)

:: 带参数运行
call :start_batch %1
exit /b 0