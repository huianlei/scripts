@echo off
pushd "%~dp0" 
title install docker env
:: set terminal utf-8
chcp 65001

echo USERPROFILE=%USERPROFILE%
set cur_dir=%cd%
echo %cur_dir%
echo check and enable Microsoft-Hyper-V
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
echo check and enable Microsoft-Hyper-V success.
choice /t 1 /d y /n >nul

DockerDesktopInstaller.exe
echo [========================= install success =======================]

if exist C:\Program Files\Docker\Docker (
	echo [========================= Starting Docker =======================]
	@start cmd /c "C:\Program Files\Docker\Docker\Docker Desktop.exe"
	@exit
)
set DockerDaemonConfDir=%USERPROFILE%\.docker
if not exist %DockerDaemonConfDir% (
	md %DockerDaemonConfDir%
)
echo "copy daemon.json to %DockerDaemonConfDir%"
copy "daemon.json" "%DockerDaemonConfDir%\daemon.json" /Y
choice /t 5 /d y /n >nul

