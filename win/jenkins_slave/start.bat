@echo off 
title Jenkins Slave
pushd "%~dp0"
echo %cd%
java -jar agent.jar ^
 -jnlpUrl http://10.0.107.63:8090/computer/Dev_HAL_Home/slave-agent.jnlp ^
 -secret 259551f1437e06c8acf1887d7e723c9f8b8d17d77e02e0a87f66f0c34462b77b ^
 -workDir "D:\jenkins_slave"