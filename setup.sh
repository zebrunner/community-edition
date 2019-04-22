#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${BASEDIR}

HOST_NAME=$1

if [ $# -lt 1 ]; then
    printf 'Usage: %s HOST_NAME\n' "$(basename "$0")" >&2
    exit -1
fi

echo generating variables.env...
sed 's/demo.qaprosoft.com/'$1'/g' variables.env.original > variables.env
echo generating ./nginx/conf.d/default.conf...
sed 's/demo.qaprosoft.com/'$1'/g' ./nginx/conf.d/default.conf.original > ./nginx/conf.d/default.conf
echo generating GGR quota file ./grid-router/quota/demo.xml
sed 's/demo.qaprosoft.com/'$1'/g' ./grid-router/quota/demo.xml.original > ./grid-router/quota/demo.xml


if [[ ! -d esdata ]]; then
    echo creating esdata folder for elastic search...
    echo WARNING! Increase vm.max_map_count=262144 appending it to /etc/sysctl.conf on Linux Ubuntu
    echo your current value is `sysctl vm.max_map_count`
    mkdir esdata
fi

if [[ ! -d jenkins ]]; then
    echo creating jenkins folder...
    mkdir jenkins
fi

echo Setup finished successfully using $HOST_NAME hostname.
