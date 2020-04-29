#!/bin/sh

docker-compose -f jenkins/docker-compose.yml down -v
docker-compose -f reporting-service/docker-compose.yml down -v
docker-compose -f sonarqube/docker-compose.yml down -v
docker-compose docker-compose.yml down -v

docker rm -fv $(docker ps -a -q)
#TODO: make images removal only for infra images somehow!
docker rmi -f $(docker images -q)

rm -rf ./selenoid/video/*


