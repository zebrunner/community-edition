#!/bin/bash

# to cauto clean selenoid/appium video crontab is configured to remove mp4 older than 24hrs
#0 * * * * find $HOME/tools/stage-infra/selenoid/video -mindepth 1 -maxdepth 1 -mmin +1440 -name '*.mp4' | xargs rm -rf

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${BASEDIR}

if [ ! -f variables.env ] || [ ! -f ./nginx/conf.d/default.conf.original ]; then
    printf 'WARNING! You forgot to setup qps-infra host address preliminary! For example:\n ./setup.sh myhost.domain.com\n\n' "$(basename "$0")" >&2
    exit -1
fi

# pull required docker images
docker pull selenoid/vnc:chrome_78.0
docker pull selenoid/vnc:chrome_77.0
docker pull selenoid/vnc:firefox_71.0
docker pull selenoid/vnc:firefox_70.0
docker pull selenoid/vnc:opera_66.0
docker pull selenoid/vnc:opera_65.0

docker pull selenoid/video-recorder:latest-release

#-------------- START EVERYTHING ------------------------------
docker-compose up -d
