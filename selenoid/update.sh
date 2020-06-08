#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

#TODO: execute binary based on host architecture to support win as well

echo downloading latest chrome/firefox/opera browser images
${BASEDIR}/bin/bash selenoid update --vnc --config-dir "${BASEDIR}" $*

if [ docker inspect selenoid | grep "Running" ]; then
    docker rm -f selenoid
fi