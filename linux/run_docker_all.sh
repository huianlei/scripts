#!/usr/bin/env bash
#-------------------------------------------------
#Note:
#1. must create static network like list first
#docker network create --subnet 172.18.0.1/16 StaticNet
#so container can use static ip when create it
#-------------------------------------------------
#must set base work dir
DOCKER_ANTIA_BASE=$HOME/docker-antia
echo "DOCKER_ANTIA_BASE=${DOCKER_ANTIA_BASE}"
if [ ! -d ${DOCKER_ANTIA_BASE} ]; then
	mkdir -p ${DOCKER_ANTIA_BASE}
fi
echo "DOCKER_ANTIA_BASE=${DOCKER_ANTIA_BASE}"
SERVER_MOUNT_DIR="${DOCKER_ANTIA_BASE}/gameserver"
SERVER_DEPLOY_DIR="/tmp/deploy/antia/gameserver"
if [ ! -d ${SERVER_MOUNT_DIR} ]; then
    echo "${SERVER_MOUNT_DIR} not exist, create it"
    mkdir -p ${SERVER_MOUNT_DIR}
fi

REDIS_MOUNT_DIR=${DOCKER_ANTIA_BASE}/redis_data
if [ ! -d ${REDIS_MOUNT_DIR} ]; then
    echo "${REDIS_MOUNT_DIR} not exist, create it"
    mkdir -p ${REDIS_MOUNT_DIR}
fi

function run_docker(){
	found_str=`docker ps -a | grep ${docker_name}`
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

function check_mysql(){
	status=`docker inspect -f {{.State.Status}} ${docker_name}`
	echo "checked ${docker_name} status:${status}"
	if [ "${status}" != "running" ]; then
		echo "${docker_name} status not running, stop and rm the container"
		docker stop ${docker_name}
		sleep 2
		docker rm ${docker_name}
		sleep 2
		# not bind mysql_data dir
		cmd="docker run --name ${docker_name} --restart=always -itd -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123147 \
		-v $DOCKER_ANTIA_BASE/docker.sock:/var/run/docker.sock \
		--network StaticNet --ip 172.18.0.3 \
		10.0.107.63:5000/mysql:5.6"
		run_docker
	fi
}

# run redis
docker_name="docker-redis"
cmd="docker run --name ${docker_name} -itd -p 6379:6379 --restart=always \
	-v $DOCKER_ANTIA_BASE/docker.sock:/var/run/docker.sock \
	-v ${REDIS_MOUNT_DIR}:/data \
	--network StaticNet --ip 172.18.0.2 \
	10.0.107.63:5000/redis:4.0"
run_docker

# run mysql
MYSQL_DATA_DIR=${DOCKER_ANTIA_BASE}/mysql_data

#-v ${MYSQL_DATA_DIR}:/var/lib/mysql \

docker_name="docker-mysql"
cmd="docker run --name ${docker_name} --restart=always -itd -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123147 \
	-v $DOCKER_ANTIA_BASE/docker.sock:/var/run/docker.sock \
	-v ${MYSQL_DATA_DIR}:/var/lib/mysql \
	--network StaticNet --ip 172.18.0.3 \
	10.0.107.63:5000/mysql:5.6"
run_docker
check_mysql

# run gameserver
echo "SERVER_DEPLOY_DIR=$SERVER_DEPLOY_DIR"
mysql_host=`docker inspect -f {{.NetworkSettings.Networks.StaticNet.IPAddress}} docker-mysql`
redis_host=`docker inspect -f {{.NetworkSettings.Networks.StaticNet.IPAddress}} docker-redis`
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
	-v $SERVER_MOUNT_DIR:${SERVER_DEPLOY_DIR} \
	--network StaticNet --ip 172.18.0.4 \
	gameserver"
run_docker

# show docker containers
docker ps

