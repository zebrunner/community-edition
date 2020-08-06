#!/bin/bash

# to cauto clean selenoid/appium video crontab is configured to remove mp4 older than 24hrs
#0 * * * * find $HOME/tools/stage-infra/selenoid/video -mindepth 1 -maxdepth 1 -mmin +1440 -name '*.mp4' | xargs rm -rf

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${BASEDIR}

if [ ! -f .env ] || [ ! -f ./nginx/conf.d/default.conf ] || [ ! -f ./selenoid/browsers.json ]; then
    printf 'WARNING! You forgot to setup infra host address preliminary! For example:\n ./setup.sh myhost.domain.com\n\n' "$(basename "$0")" >&2
    exit -1
fi

echo "
███████╗███████╗██████╗ ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗      ██████╗███████╗
╚══███╔╝██╔════╝██╔══██╗██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗    ██╔════╝██╔════╝
  ███╔╝ █████╗  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝    ██║     █████╗  
 ███╔╝  ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗    ██║     ██╔══╝  
███████╗███████╗██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║    ╚██████╗███████╗
╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝     ╚═════╝╚══════╝

"

# create infra network only if not exist
docker network inspect infra >/dev/null 2>&1 || docker network create infra

#-------------- START EVERYTHING ------------------------------
docker-compose -f selenoid/docker-compose.yml up -d
docker-compose -f mcloud/docker-compose.yml up -d
docker-compose -f jenkins/docker-compose.yml up -d
docker-compose -f reporting-service/docker-compose.yml up -d
docker-compose -f sonarqube/docker-compose.yml up -d
docker-compose up -d
