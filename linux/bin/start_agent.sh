#!/bin/bash
BASE_DIR=/root/workspace
source ${BASE_DIR}/.env
cd ${BASE_DIR}/jenkins
pid=$(ps -ef|grep "agent.jar" | grep -v grep | awk -F ' ' '{print $2}')
echo "$JENKINS_JNLP_URL" > agent.log
echo "$(date),pid=${pid}" >> agent.log
if [ "${pid}x" == "x" ]; then
  java -jar agent.jar -jnlpUrl "$JENKINS_JNLP_URL" -secret @secret-file -workDir "${BASE_DIR}/jenkins" >> agent.log 2>&1 &
fi
