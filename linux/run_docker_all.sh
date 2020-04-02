#!/usr/bin/env bash

DOCKER_ANTIA_BASE=$HOME/docker-antia
if [ ! -d ${DOCKER_ANTIA_BASE} ]; then
	mkdir -p ${DOCKER_ANTIA_BASE}
fi
echo "DOCKER_ANTIA_BASE=${DOCKER_ANTIA_BASE}"
SERVER_DEPLOY_DIR="${DOCKER_ANTIA_BASE}/gameserver"
if [ ! -d ${SERVER_DEPLOY_DIR} ]; then
    echo "${SERVER_DEPLOY_DIR} not exist, create it"
    mkdir -p ${SERVER_DEPLOY_DIR}
fi

function run_docker(){
	found_str=`docker ps | grep ${docker_name}`
	sudo --help > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		cmd="sudo ${cmd}"
	fi
	
	if [ "${found_str}" == "" ]; then
		echo "${docker_name} not found"
		echo "run ${docker_name}"
		echo ${cmd}
		eval "${cmd}"
	else 
		echo "${docker_name} already exist"
	fi
	sleep 3
}

# run redis
docker_name="docker-redis"
cmd="docker run --name ${docker_name} -itd -p 6379:6379 --restart=always \
		-v $DOCKER_ANTIA_BASE/docker.sock:/var/run/docker.sock \
		10.0.107.63:5000/redis:4.0"

run_docker

# run mysql
MYSQL_DATA_DIR=${DOCKER_ANTIA_BASE}/mysql_data

#-v ${MYSQL_DATA_DIR}:/var/lib/mysql \

docker_name="docker-mysql"
cmd="docker run --name ${docker_name} --restart=always -itd -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123147 \
-v $DOCKER_ANTIA_BASE/docker.sock:/var/run/docker.sock \
10.0.107.63:5000/mysql:5.6"

run_docker

# run gameserver
echo "SERVER_DEPLOY_DIR=$SERVER_DEPLOY_DIR"
mysql_host=`docker inspect -f {{.NetworkSettings.IPAddress}} docker-mysql`
redis_host=`docker inspect -f {{.NetworkSettings.IPAddress}} docker-redis`
echo "mysql_host=${mysql_host}"
echo "redis_host=${redis_host}"

docker_name="docker-gameserver"
cmd="docker run --name ${docker_name} --restart=always -itd \
-p 10022:22 \
-p 9001:9001 \
-e MYSQL_USER="root" \
-e MYSQL_HOST="$mysql_host" \
-e MYSQL_PASSWORD="123147" \
-e REDIS_URL="$redis_host:6379" \
-e SERVER_DEPLOY_DIR="${SERVER_DEPLOY_DIR}" \
-v $SERVER_DEPLOY_DIR:/tmp/deploy/antia/gameserver/ \
10.0.107.63:5000/gameserver:1.0"

run_docker

# show docker containers
docker ps
