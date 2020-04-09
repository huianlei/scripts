@echo off 
title run redis docker
:: set terminal utf-8
chcp 65001

:: check env

echo USERPROFILE=%USERPROFILE%
set DOCKER_ANTIA_BASE=%USERPROFILE%\docker-antia
if not exist %DOCKER_ANTIA_BASE% md %DOCKER_ANTIA_BASE%
set MYSQL_DATA_HOME=%USERPROFILE%\docker-antia\mysql_data
set SERVER_DEPLOY_DIR=%USERPROFILE%\docker-antia\gameserver

call init.bat

:: static ip 
set DOCKER_REDIS_IP=172.18.0.2
set DOCKER_MYSQL_IP=172.18.0.3
set DOCKER_GAMESERVER_IP=172.18.0.4

:: redis
set container_name=docker-redis
echo prepre to run %container_name%
docker ps -a | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 6379:6379 --restart=always --network StaticNet --ip %DOCKER_REDIS_IP% ^
		10.0.107.63:5000/redis:4.0
	if errorlevel 1 (
		echo run docker %container_name% failed, please check err info to fix it
		goto :pause_exit
	)
	choice /t 3 /d y /n >nul
	docker ps | findstr %container_name%
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	choice /t 3 /d y /n >nul
)


:: mysql
set container_name=docker-mysql
echo prepre to run %container_name%
docker ps -a | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123147 ^
		-v %MYSQL_DATA_HOME%:/var/lib/mysql --restart=always  --network StaticNet --ip %DOCKER_MYSQL_IP% ^
		10.0.107.63:5000/mysql:5.6
	if errorlevel 1 (
		echo run docker %container_name% failed, please check err info to fix it
		goto :pause_exit
	)	
	choice /t 3 /d y /n >nul
	docker ps | findstr %container_name%
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	choice /t 3 /d y /n >nul
)

:: gameserver
set container_name=docker-gameserver
echo prepre to run %container_name%
echo SERVER_DEPLOY_DIR=%SERVER_DEPLOY_DIR%
set LinuxDEPLOY_DIR=/tmp/deploy/antia/gameserver

docker ps -a | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 9001:9001 -p 8001:8001 -p 10022:22 ^
		--restart=always --network StaticNet --ip %DOCKER_GAMESERVER_IP% ^
		-e MYSQL_USER="root" -e MYSQL_HOST="%DOCKER_MYSQL_IP%" -e MYSQL_PASSWORD="123147" ^
		-e SERVER_DEPLOY_DIR="%LinuxDEPLOY_DIR%" ^
		-e REDIS_URL="%DOCKER_REDIS_IP%:6379" ^
		-v %SERVER_DEPLOY_DIR%:%LinuxDEPLOY_DIR% ^
		-v %ANTIA_CONF_HOME%:/root/workspace/conf
		10.0.107.63:5000/gameserver:1.0
		if errorlevel 1 (
			echo run docker %container_name% failed, please check err info to fix it
			goto :pause_exit
		)		
	choice /t 3 /d y /n >nul
	docker ps | findstr %container_name%
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	choice /t 3 /d y /n >nul
)

echo ---------------------------------------all containers------------------------------------------
docker ps 
echo -----------------------------------------------------------------------------------------------
choice /t 5 /d y /n >nul
goto :eof

:pause_exit
pause
goto :eof