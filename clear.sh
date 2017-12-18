#!/bin/sh

docker-compose stop
docker-compose rm -f

docker rmi -f $(docker images -q)

rm -rf ./jenkins/*
rm -rf ./pgdata/*




