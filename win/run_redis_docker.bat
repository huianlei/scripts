@echo off 
title run redis docker

set container_name=docker-test-redis

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
