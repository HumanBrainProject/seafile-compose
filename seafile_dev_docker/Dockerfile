FROM ubuntu:16.04

RUN apt update \
    && apt-get install -qq -y --no-install-recommends \
      vim \
      htop \
      net-tools \
      psmisc \
      git \
      wget \
      curl \
      build-essential \
      python-dev \
      python-pip \
      python-setuptools \
      python-wheel \
      libmysqlclient-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV SEAFILE_VERSION=6.3.3 SEAFILE_SERVER=seafile-server

RUN mkdir -p /opt/seafile/conf && \
    mkdir -p /opt/seafile/data && \
    mkdir -p /opt/seafile/pids && \
    mkdir -p /opt/seafile/ccnet && \
    mkdir -p /opt/seafile/sockets && \
    mkdir -p /opt/seafile/logs && \
    openssl genrsa -out /opt/seafile/ccnet/mykey.peer 4096 && \
    touch /opt/seafile/logs/seafile.log && \
    touch /opt/seafile/logs/ccnet.log && \
    touch /opt/seafile/logs/seahub.log

RUN mkdir -p /opt/seafile/ && \
    curl -sSL -o - https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz \
    | tar xzf - -C /opt/seafile/ && \
    ln -s /opt/seafile/seafile-server-${SEAFILE_VERSION} /opt/seafile/seafile-server-latest

ENV LD_LIBRARY_PATH=/opt/seafile/seafile-server-latest/seafile/lib:/opt/seafile/seafile-server-latest/seafile/lib64:$LD_LIBRARY_PATH
ENV SEAFILE_DATA_DIR=/opt/seafile/data CCNET_CONF_DIR=/opt/seafile/ccnet SEAFILE_CENTRAL_CONF_DIR=/opt/seafile/conf SEAFILE_CONF_DIR=/opt/seafile/seafile-data
ENV PYTHONPATH=/opt/seafile/seafile-server-${SEAFILE_VERSION}/seafile/lib64/python2.7/site-packages:/opt/seafile/seafile-server-6.3.3/seahub:/opt/seafile/seafile-server-6.3.3/seahub/thirdpart:$PYTHONPATH

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --disable-pip-version-check \
                -r /tmp/requirements.txt \
                -r /opt/seafile/seafile-server-${SEAFILE_VERSION}/seahub/requirements.txt

COPY config /opt/seafile/conf/
COPY ccnet /opt/seafile/ccnet/
COPY scripts /opt/seafile
