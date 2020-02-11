#!/bin/bash

KEEP_CONTAINERS=true

echo_help() {
  echo "
      Flags:
          --remove-containers | -rm    remove containers
      For more help visit telegram channel https://t.me/qps_infra"
}

for arg in "$@"
do
  case $arg in
    --help | -h)
      echo_help;
      shift
      ;;
    --remove-containers | -rm)
      KEEP_CONTAINERS=false;
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

if ! $KEEP_CONTAINERS ; then
  docker-compose rm -fv
  echo "Containers were deleted"
fi