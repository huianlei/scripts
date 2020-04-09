#! /usr/bin/env bash

#if [ "${SERVER_DEPLOY_DIR}x" == "x" ]; then
    SERVER_DEPLOY_DIR="/tmp/deploy/antia/gameserver"
#fi

LOG_DIR="$SERVER_DEPLOY_DIR/logs"
cur_dir=`pwd`
cd $SERVER_DEPLOY_DIR


mkdir -p $LOG_DIR

nohup ./gameserver -_auto_conf_files_=./configs/gameserver/local.toml > $LOG_DIR/gameserver.log 2>&1 &

cd $cur_dir 
