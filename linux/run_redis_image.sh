#!/usr/bin/env bash

DOCKER_ANTIA_BASE=$HOME/docker-antia
if [ !-d ${DOCKER_ANTIA_BASE} ]; then
	mkdir -p ${DOCKER_ANTIA_BASE}
fi

# redis

docker run \
--name docker-redis \
-itd \
-p 6379:6379 \
--restart=always \
-v ${DOCKER_ANTIA_BASE}/docker.sock:/var/run/docker.sock \
10.0.107.63:5000/redis:4.0
