#!/usr/bin/env bash

APP_NAME="gameserver"
process=`ps -ef|grep ${APP_NAME} | grep -v grep`
if [ "${process}x" == "x" ]; then
  echo "$APP_NAME not running"
else
  pid=`echo $process | awk -F ' ' {'print $2'}`
  echo "$APP_NAME running pid:$pid"
  kill -9 $pid
  echo "$APP_NAME stoped"
fi 
