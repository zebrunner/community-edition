#!/bin/sh

docker-compose stop
docker-compose rm -f

docker rm -fv $(docker ps -a -q)
docker rmi -f $(docker images -q)

# remove sonarqube data
docker volume rm sonarqube_data-volume sonarqube_extensions-volume sonarqube_logs-volume

#remove jenkins data
docker volume rm jenkins_data-volume

# remove reporting-service data
docker volume rm reporting-service_assets-data reporting-service_esdata-volume reporting-service_pgdata-volume

rm -rf ./selenoid/video/*


