#!/bin/sh

docker-compose -f jenkins/docker-compose.yml down -v
docker-compose -f reporting-service/docker-compose.yml down -v
docker-compose -f sonarqube/docker-compose.yml down -v
docker-compose -f mcloud/docker-compose.yml down -v
docker-compose -f hub/docker-compose.yml down -v
docker-compose docker-compose.yml down -v

docker rm -fv $(docker ps -a -q)
#TODO: make images removal only for infra images somehow!
docker rmi -f $(docker images -q)

rm -rf ./hub/selenoid/video/*.mp4


