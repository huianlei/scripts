#!/usr/bin/env bash

sh http_sync.sh \
&& sh ./scripts/create-db.sh ${MYSQL_USER} ${MYSQL_PASSWORD} \
&& sleep 5 \
&& sh stop_game.sh \
&& sh start_game.sh

echo "starting gameserver ..."
sleep 10
echo "$(ps aux | grep gameserver| grep -v grep)"
#sh jenkins/start_agent.sh
