#!/usr/bin/env bash

if [ "${MYSQL_DATA_DIR}x" = "x" ]; then
    MYSQL_DATA_DIR="/var/lib/mysql"
    echo "env MYSQL_DATA_DIR not set. set default=$MYSQL_DATA_DIR"
fi
if [ ! -d $MYSQL_DATA_DIR ]; then
    echo "$MYSQL_DATA_DIR not exist, create it"
    mkdir -p $MYSQL_DATA_DIR	
fi
echo "MYSQL_DATA_DIR=$MYSQL_DATA_DIR"

sudo docker run --name docker-mysql --restart=always -itd \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=123147 \
-v $MYSQL_DATA_DIR:/var/lib/mysql \
-v /var/run/docker.sock:/var/run/docker.sock \
mysql:5.6
