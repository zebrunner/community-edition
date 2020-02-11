#!/bin/bash

KEEP_CONTAINERS=true

for arg in "$@"
do
  case $arg in
    --help | -h)
      echo "
      Flags:\n
      --remove-containers | -rm    remove containers\n
      For more help visit telegram chanal https://t.me/qps_infra";
      shift
      ;;
    --remove-containers | -rm)
      KEEP_CONTAINERS=false;
      shift
      ;;
    *)
      echo "There's no such parameter" $arg
      ;;
esac
done

docker-compose stop
echo "qps-infra was stopped"

if ! $KEEP_CONTAINERS ; then
  docker-compose rm -fv
  echo "Containers were deleted"
fi