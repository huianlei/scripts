#!/usr/bin/env bash

if [ "${SERVER_DEPLOY_DIR}x" = "x" ]; then
    SERVER_DEPLOY_DIR="/tmp/deploy/antia/gameserver/"
    echo "env SERVER_DEPLOY_DIR not set. set default=$SERVER_DEPLOY_DIR"
fi
if [ ! -d $SERVER_DEPLOY_DIR ]; then
    echo "$SERVER_DEPLOY_DIR not exist, create it"
    mkdir -p $SERVER_DEPLOY_DIR	
fi
echo "SERVER_DEPLOY_DIR=$SERVER_DEPLOY_DIR"
mysql_host=`docker inspect -f {{.NetworkSettings.IPAddress}} docker-mysql`
redis_host=`docker inspect -f {{.NetworkSettings.IPAddress}} docker-redis`

sudo docker run --name docker-gameserver --restart=always -itd \
-p 10022:22 \
-p 19001:9001 \
-e MYSQL_USER="root" \
-e MYSQL_HOST="$mysql_host" \
-e MYSQL_PASSWORD="123147" \
-e REDIS_URL="$redis_host:6379" \
-e SERVER_DEPLOY_DIR="/tmp/deploy/antia/gameserver" \
-v $SERVER_DEPLOY_DIR:/tmp/deploy/antia/gameserver/ \
-v /var/run/docker.sock:/var/run/docker.sock \
gameserver:1.0
