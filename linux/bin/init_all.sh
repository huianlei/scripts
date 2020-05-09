#!/usr/bin/env bash
echo "$(dirname "${0}")" 
cd $(dirname "${0}") && echo "$(pwd)"
sh http_sync.sh
echo "install crond"
crond -s
ps -aux
echo "---------------------"
crontab -l
echo "---------------------"
env > .env
echo "init all success"

