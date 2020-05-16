#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

docker-compose -f jenkins/docker-compose.yml down -v
docker-compose -f reporting-service/docker-compose.yml down -v
docker-compose -f sonarqube/docker-compose.yml down -v
docker-compose -f mcloud/docker-compose.yml down -v
docker-compose -f selenoid/docker-compose.yml down -v
docker-compose down -v

docker rm -fv $(docker ps -a -q)
#TODO: make images removal only for infra images somehow!
docker rmi -f $(docker images -q)

rm -rf ./selenoid/video/*.mp4
mv selenoid/browsers.json selenoid/browsers.json.bak
mv ./nginx/conf.d/default.conf ./nginx/conf.d/default.conf.bak
mv .env .env.bak


