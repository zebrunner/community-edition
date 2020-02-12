#!/bin/bash

KEEP_CONTAINERS=false

echo_help() {
  echo "
      Flags:
          --keep-containers | -k    keep containers
      For more help visit telegram channel https://t.me/qps_infra"
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

docker-compose stop
echo "qps-infra was stopped"

if [ ! $KEEP_CONTAINERS ]
then
  docker-compose rm -fv
  echo "Containers were deleted"
fi