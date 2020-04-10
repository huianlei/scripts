#!/usr/bin/env bash

cur_dir=$(pwd)

cd ../../linux/bin && ls -lt
zip -r init.zip *

mv init.zip $cur_dir && cd -

docker build -t gameserver . 
echo "build docker image success" && rm -rf init.zip
