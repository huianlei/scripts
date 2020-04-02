@echo off 
title run dockers for WinHome Edition

:: check env

echo DOCKER_ANTIA=%DOCKER_ANTIA%
set MYSQL_DATA_HOME=%DOCKER_ANTIA%/mysql_data
set SERVER_DEPLOY_DIR=%DOCKER_ANTIA%/gameserver

:: redis
set container_name=docker-redis
echo prepre to run %container_name%
docker ps -a | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 6379:6379 --restart=always --network StaticNet --ip 172.18.0.2 ^
		10.0.107.63:5000/redis:4.0
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
docker ps -a | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123147 ^
		--restart=always --network StaticNet --ip 172.18.0.3 ^
		10.0.107.63:5000/mysql:5.6
	choice /t 3 /d y /n >nul
	docker ps
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	docker ps
	choice /t 3 /d y /n >nul
)

:: gameserver
set container_name=docker-gameserver
echo prepre to run %container_name%
echo SERVER_DEPLOY_DIR=%SERVER_DEPLOY_DIR%
docker ps -a | findstr %container_name% >nul 2>nul
if errorlevel 1 (
	echo %container_name% not found
	echo run docker %container_name% ...
	choice /t 1 /d y /n >nul
	docker run --name %container_name% -itd -p 9001:9001 ^
		--restart=always --network StaticNet --ip 172.18.0.4 ^
		-e MYSQL_USER="root" -e MYSQL_HOST="172.18.0.3" -e MYSQL_PASSWORD="123147" ^
		-e SERVER_DEPLOY_DIR="%SERVER_DEPLOY_DIR%" ^
		-v %SERVER_DEPLOY_DIR%:/tmp/deploy/antia/gameserver/ ^
		10.0.107.63:5000/mysql:5.6
	choice /t 3 /d y /n >nul
	docker ps
	choice /t 2 /d y /n >nul
) else (
	echo %container_name% container already exists
	docker ps
	choice /t 3 /d y /n >nul
)

:pause_exit
pause
goto :eof