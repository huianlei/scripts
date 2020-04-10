FROM centos:7

WORKDIR "/root/workspace"

ARG GO_VERSION="1.13"
ARG PYTHON_VERSION="3.7.7"

ENV GOPATH="/root/go" \
GOROOT="/usr/bin" \
SERVER_DEPLOY_DIR="/tmp/deploy/antia/gameserver"


EXPOSE 9001 8001


# yum install golang $GO_VERSION latest

RUN echo "============================================================" \
&& echo "yum install golang $GO_VERSION" \
&& rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO \
&& curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo \
&& yum install -y golang-$GO_VERSION \
&& go version && whereis go && echo $PATH \
&& mkdir -p $GOPATH \
&& echo "install golang-$GO_VERSION success"


# install python $PYTHON_VERSION
RUN echo "============================================================" \
&& echo "install python $PYTHON_VERSION" \
&& yum -y groupinstall "Development tools" \
&& yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel \
tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel \
&& curl -s -L -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
&& tar -xf Python-$PYTHON_VERSION.tgz \
&& cd Python-$PYTHON_VERSION \
&& ./configure --prefix=/usr/local/python3 \
&& make && make install \
&& cd - \
&& rm -rf Python-${PYTHON_VERSION}* \
&& whereis python3 \ 
&& ln -s /usr/local/python3/bin/python3 /usr/bin/python3 \
&& ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3 \
&& python3 -V \
&& pip3 install --upgrade pip \
&& pip3 install --upgrade pipenv \
&& find / -name "pipenv" \
&& ln -s /usr/local/python3/bin/pipenv /usr/bin/pipenv \
&& pipenv --version \
&& echo "python3 install success ."


# copy files to workdir
COPY init.zip .

#
RUN unzip init.zip \ 
&& chmod 744 *.sh \
&& rm -rf init.zip \
&& ls -lt


# ENTRYPOINT [ "sh", "http_sync.sh" ]
