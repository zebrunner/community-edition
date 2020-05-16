#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

#TODO: execute binary based on host architecture to support mac/win as well

echo downloading latest chrome/firefox/opera browser images
${BASEDIR}/bin/cm_linux_amd64 selenoid update --vnc --config-dir "${BASEDIR}" $*

docker rm -f selenoid
