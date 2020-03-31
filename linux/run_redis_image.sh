#!/usr/bin/env bash

sudo docker run \
--name docker-redis \
-itd \
-p 6379:6379 \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
redis:4.0
