@echo off 
title init docker env
:: set terminal utf-8
chcp 65001

set cur_dir=%cd%
echo USERPROFILE=%USERPROFILE%
set DOCKER_ANTIA_BASE=%USERPROFILE%\docker-antia
if not exist %DOCKER_ANTIA_BASE% (
	echo %DOCKER_ANTIA_BASE% not exist, create it now.
	md %DOCKER_ANTIA_BASE%
)

cd /d %DOCKER_ANTIA_BASE%
echo working dir : %cd%

:: create docker network StaticNet
set NetName=StaticNet
echo checking docker network %NetName%
docker network ls | findstr %NetName%
if errorlevel 1 (
	echo %NetName% not found. create it now.
	docker network create --subnet 172.18.0.1/16 StaticNet
	docker network ls | findstr %NetName%
) else (
	echo %NetName% already exist.
)

echo init docker env success
choice /t 3 /d y /n >nul
goto :eof

rem must run it as admin
:prepare_pipenv
python -V
python -m pip install --upgrade pip
pip --version
pip install pipenv

goto :eof