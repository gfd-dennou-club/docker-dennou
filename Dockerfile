FROM debian:bookworm-slim
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential git debian-keyring
ARG DENNOU_SOURCE=/etc/apt/sources.list.d/gfd-dennou.sources
RUN echo "Types: deb" > ${DENNOU_SOURCE}
RUN echo "URIs: https://dennou-k.gfd-dennou.org/library/cc-env/Linux/debian-dennou" >> ${DENNOU_SOURCE}
RUN echo "Suites: bookworm" >> ${DENNOU_SOURCE}
RUN echo "Components: main" >> ${DENNOU_SOURCE}
RUN echo "Signed-by: /usr/share/keyrings/debian-maintainers.gpg" >> ${DENNOU_SOURCE}
RUN apt-get update && apt-get install -y spml dcl-f77 gphys

#### CLEAN UP ####
WORKDIR /
RUN apt-get clean

#### ADD DEFAULT USER ####
ARG USER=dennou
ENV USER=${USER}
RUN adduser --disabled-password ${USER}

ENV USER_HOME=/home/${USER}
RUN chown -R ${USER}:${USER} ${USER_HOME}

#### CREATE WORKING DIRECTORY FOR USER ####
ARG WORKDIR=/project
ENV WORKDIR=${WORKDIR}
RUN mkdir ${WORKDIR}
RUN chown -R ${USER}:${USER} ${WORKDIR}

WORKDIR ${WORKDIR}
USER ${USER}
