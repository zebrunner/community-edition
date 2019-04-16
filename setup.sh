#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${BASEDIR}

HOST_NAME=$1

if [ $# -lt 1 ]; then
    printf 'Usage: %s HOST_NAME\n' "$(basename "$0")" >&2
    exit -1
fi

sed 's/demo.qaprosoft.com/'$1'/g' variables.env.original > variables.env
sed 's/demo.qaprosoft.com/'$1'/g' ./nginx/conf.d/default.conf.original > ./nginx/conf.d/default.conf


if [[ ! -d esdata ]]; then
    mkdir esdata
fi

if [[ ! -d jenkins ]]; then
    mkdir jenkins
fi

