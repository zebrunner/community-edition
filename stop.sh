#!/bin/bash

flag=true
for arg in "$@"
do
  case $arg in
    "--help" | "-h")
      echo "
      Flags:\n
      --keep-containers, -k    keep containers\n
      For more help visit telegram chanal https://t.me/qps_infra"
      ;;

    "--keep-containers" | "-k")
      echo "Containers were kept"
      flag=false
      ;;
  *)
    echo "There's no such parameter" + $arg
    ;;
esac
done

docker-compose stop
echo "qps-infra was stopped"

if $flag; then
  docker-compose rm -fv
  echo "Containers were deleted"
fi