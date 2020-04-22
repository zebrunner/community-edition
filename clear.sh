#!/bin/sh

docker-compose stop
docker-compose rm -f

docker rm -fv $(docker ps -a -q)
docker rmi -f $(docker images -q)

# remove sonarqube data
docker volume rm sonarqube_sonarqube-data-volume sonarqube_sonarqube-extensions-volume sonarqube_sonarqube-logs-volume

#remove jenkins data
# TODO: think twice about .m2 removal. It might be useful to keep it even after clearing...
docker volume rm jenkins-volume m2-volume

rm -rf ./pgdata/*

sudo rm -rf ./esdata/*
rm -rf ./selenoid/video/*


