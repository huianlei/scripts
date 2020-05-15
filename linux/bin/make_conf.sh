#!/usr/bin/env bash

cd $(dirname "${0}") && echo "$(pwd)"
source $HOME/.bash_profile

tmp_log=/tmp/makeconf.log
make conf > ${tmp_log} 2>&1

err_found=$(grep "ModuleNotFoundError" ${tmp_log})
echo ${err_found}
if [ ! "${err_found}x" == "x" ]; then
   cd tools/xml2pb && pipenv install develop && cd -
   make conf
fi

