FROM ubuntu:20.04

USER root

ARG INSTALLER_URL=http://ev3rt-git.github.io/public/ev3rt-prepare-ubuntu.sh
ARG EV3RT_VERSION=1.1
ARG EV3RT_DIR=ev3rt-${EV3RT_VERSION}-release
ARG EV3RT_URL=http://www.toppers.jp/download.cgi/${EV3RT_DIR}.zip
ENV EV3RT_WORKSPACE_DIR=/root/${EV3RT_DIR}/hrp3/sdk/workspace

# INSTALLER_URLでコンパイラのバージョンが変更されたら変更する必要がある
ARG COMPILER_DIR=/opt/gcc-arm-none-eabi-6-2017-q1-update/bin

RUN apt-get update; apt-get -y upgrade
RUN apt-get -y install ruby xz-utils wget make; gem install shell
RUN cd ~; wget ${INSTALLER_URL}; \
  bash ev3rt-prepare-ubuntu.sh;
ENV PATH $PATH:${COMPILER_DIR}
RUN cd ~; wget ${EV3RT_URL}; \
  unzip ${EV3RT_DIR}.zip; \
  cd ${EV3RT_DIR}/; \
  tar xvf hrp3.tar.xz

COPY shiokara-z ${EV3RT_WORKSPACE_DIR}/shiokara-z
COPY on-start.sh /on-start.sh

WORKDIR ${EV3RT_WORKSPACE_DIR}

ENTRYPOINT [ "bash", "/on-start.sh" ]