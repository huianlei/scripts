@echo off 
title init
set base=%cd%

set work_dir=%base%\gameserver
echo create work_dir=%work_dir%
if exist %work_dir% (
	rd Build /S/Q
)
mkdir %work_dir%

cd /d %work_dir%

git clone https://github.com/huianlei/scripts.git

rem must run it as admin
:prepare_pipenv
python -V
python -m pip install --upgrade pip
pip --version
pip install pipenv

