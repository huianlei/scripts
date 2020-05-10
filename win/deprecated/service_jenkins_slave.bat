@echo off
pushd "%~dp0"  
title Install Jenkins Slave Service

echo %cd%
sc delete "JenkinsSlave"
sc create "JenkinsSlave" binPath= "%cd%\jenkins_slave.bat" type=share start=auto displayname="Jenkins Slave Services"
net start "JenkinsSlave"
pause