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
				echo �����^(%keyword%^)����������
				exit /b 8
			)
		)
		call :start %keyword%
		exit /b 0
	)
)
echo. >&2
echo �����(!keyword!)�����ڻ�������������%example%
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
    :: ���
	set /a n=1
	:: ��ӡ���������
	for /f "tokens=1 delims= " %%n in ('VBoxManage list vms') do (
		set has=no
		:: �ų������е�
		for /f "tokens=1 delims= " %%r in ('VBoxManage list runningvms') do (
			if "%%~n" == "%%~r" (
				set has=yes
			)
		)
		:: ��ӡ�����
		if "!has!" == "no" (
			set name=%%~n
			echo !n!.!name!
			set /a n+=1
		)
	)
	
	goto typing
	
	:: ��������������
	:typing
	set /p input=������������ƣ�
	if "!input!" == "" (
		goto typing
	)
	call :start_batch !input!
	exit /b 0
)

:: ����������
call :start_batch %1
exit /b 0