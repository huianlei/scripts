#!/usr/bin/env bash

function fetch_remote(){
	curl -s -L -o ${file_name} ${url}
	if [ $# -ne 0 ]; then
	  echo "pull from ${url} failed"
	  exit 1
	fi
	
	unzip -o -q ${file_name}
	echo "pull $url success"  
}
file_name="scripts.zip"
url="http://10.0.107.63/download/${file_name}"
fetch_remote

file_name="sql.zip"
url="http://10.0.107.63/download/${file_name}"
fetch_remote

file_name="gameserver.zip"
url="http://10.0.107.63/download/${file_name}"
fetch_remote

file_name="pkg.zip"
url="http://10.0.107.63/download/${file_name}"
fetch_remote

file_name="configs.zip"
url="http://10.0.107.63/download/${file_name}"
fetch_remote


TO_DIR=${SERVER_DEPLOY_DIR-/tmp/deploy/antia/gameserver}

cur_dir=`pwd`
cd $TO_DIR
ln -s $cur_dir/pkg pkg
ln -s $cur_dir/configs configs
cd -

mv --force gameserver $TO_DIR
curl -s -L -o Makefile http://10.0.107.63/download/Makefile
