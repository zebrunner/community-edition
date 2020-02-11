#!/bin/bash


keep_containers = true

for arg in "$@"
do
  case $arg in
    "--help" | "-h")
      echo "
      Flags:\n
      --remove, -rm    remove containers\n
      For more help visit telegram chanal https://t.me/qps_infra"
      ;;

    "--remove" | "-rm")
      $keep_containers = false
      ;;
    *)
      echo "There's no such parameter" + $arg
      ;;
esac
done

docker-compose stop
echo "qps-infra was stopped"

if [ !$keep_containers ]; then
  docker-compose rm -fv
  echo "Containers were deleted"
fi