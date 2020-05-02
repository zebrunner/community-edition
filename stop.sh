#!/bin/bash

KEEP_CONTAINERS=false

echo_help() {
  echo "
      Flags:
          --keep-containers | -k    keep containers
      For more help join telegram channel https://t.me/qps_infra"
      exit 0
  }

for arg in "$@"
do
  case $arg in
    --help | -h)
      echo_help;
      shift
      ;;
    --keep-containers | -k)
      KEEP_CONTAINERS=true;
      shift
      ;;
    *)
      echo "There's no such parameter" $arg
      echo_help
      ;;
esac
done

if $KEEP_CONTAINERS
then
  docker-compose -f jenkins/docker-compose.yml stop
  docker-compose -f reporting-service/docker-compose.yml stop
  docker-compose -f sonarqube/docker-compose.yml stop
#  docker-compose -f mcloud/docker-compose.yml stop
  docker-compose -f selenoid/docker-compose.yml stop
  docker-compose stop
  echo "Containers were stopped"
else 
  docker-compose -f jenkins/docker-compose.yml down
  docker-compose -f reporting-service/docker-compose.yml down
  docker-compose -f sonarqube/docker-compose.yml down
#  docker-compose -f mcloud/docker-compose.yml down
  docker-compose -f selenoid/docker-compose.yml down
  docker-compose down
  echo "Containers were stopped and deleted"
fi
