@echo off 
title run redis docker

:: check env

echo USERPROFILE=%USERPROFILE%
set MYSQL_DATA_HOME=%USERPROFILE%\docker-antia\mysql_data
set SERVER_DEPLOY_DIR=%USERPROFILE%\docker-antia\gameserver

:: redis
set container_name=docker-redis
echo prepre to run %container_name%
docker ps | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 6379:6379 --restart=always  10.0.107.63:5000/redis:4.0
	choice /t 3 /d y /n >nul
	docker ps
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	docker ps
	choice /t 3 /d y /n >nul
)


:: mysql
set container_name=docker-mysql
echo prepre to run %container_name%
docker ps | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123147 ^
		-v %MYSQL_DATA_HOME%:/var/lib/mysql --restart=always  10.0.107.63:5000/mysql:5.6
	choice /t 3 /d y /n >nul
	docker ps
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	docker ps
	choice /t 3 /d y /n >nul
)

:: gameserver

:pause_exit
pause
goto :eof