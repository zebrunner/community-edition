#!/bin/sh

docker-compose stop
docker-compose rm -f

docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

rm -rf ./jenkins/*
rm -rf ./pgdata/*



sudo rm -rf ./esdata/*
rm -rf ./selenoid/video/*


