@echo off 
title Install Jenkins Slave Service
pushd "%~dp0"
set work_dir=%cd%
echo %work_dir%
cd bin
instsrv.exe JenkinsSlave %work_dir%\bin\srvany.exe