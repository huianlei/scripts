#!/usr/bin/env bash

function fetch_remote(){
	curl -s -o ${file_name} ${url}
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

TO_DIR=/tmp/deploy/antia/gameserver
rm -rf $TO_DIR/pkg
mv --force gameserver $TO_DIR
mv --force pkg $TO_DIR

cp -R configs $TO_DIR

