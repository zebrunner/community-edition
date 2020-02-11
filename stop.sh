#!/bin/bash

flag=true
for arg in "$@"
do
  case $arg in
    "--help" | "-h")
      echo "For help visit telegram chanal https://t.me/qps_infra"
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

if $flag; then
  docker-compose rm -fv
  echo "Containers were deleted"
fi

docker-compose stop
echo "qps-infra was stoped"