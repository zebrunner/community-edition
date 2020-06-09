#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

#TODO: execute binary based on host architecture to support win as well

echo downloading latest chrome/firefox/opera browser images
${BASEDIR}/bin/download.sh selenoid start --vnc
${BASEDIR}/bin/download.sh selenoid update --vnc --config-dir "${BASEDIR}" $*

if [ ! "docker ps -q -f status=running -f name=selenoid" ]; then
    docker rm -f selenoid
fi