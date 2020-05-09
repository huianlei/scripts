#!/usr/bin/env bash

sh http_sync.sh \
&& sh ./scripts/create-db.sh ${MYSQL_USER} ${MYSQL_PASSWORD} \
&& sh start_game.sh

sleep 3

sh jenkins/start_agent.sh
