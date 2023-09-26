@echo off

goto main

:start
VBoxManage startvm %1 --type headless
exit /b 0

:start_secure
set keyword=%1
setlocal enabledelayedexpansion
set example=
for /f "tokens=1 delims= " %%n in ('VBoxManage list vms') do (
	if "!example!" == "" (
		set example=%%~n
	)
	
	if "%%~n" == "%keyword%" (
		set running=
		for /f "tokens=1 delims= " %%r in ('VBoxManage list runningvms') do (
			if "%%~r" == "%keyword%" (
				set running=!running!
				echo. >&2
				echo 虚拟机^(%keyword%^)正在运行中
				exit /b 8
			)
		)
		call :start %keyword%
		exit /b 0
	)
)
echo. >&2
echo 虚拟机(!keyword!)不存在或已启动，例：%example%
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
setlocal enabledelayedexpansion
if "%1" == "" (
    :: 序号
	set /a n=1
	:: 打印可用虚拟机
	for /f "tokens=1 delims= " %%n in ('VBoxManage list vms') do (
		set has=no
		:: 排除运行中的
		for /f "tokens=1 delims= " %%r in ('VBoxManage list runningvms') do (
			if "%%~n" == "%%~r" (
				set has=yes
			)
		)
		:: 打印虚拟机
		if "!has!" == "no" (
			set name=%%~n
			echo !n!.!name!
			set /a n+=1
		)
	)
	
	goto typing
	
	:: 运行输入的虚拟机
	:typing
	set /p input=输入虚拟机名称：
	if "!input!" == "" (
		goto typing
	)
	call :start_batch !input!
	exit /b 0
)

:: 带参数运行
call :start_batch %1
exit /b 0