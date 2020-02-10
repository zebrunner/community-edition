#!/bin/bash

docker-compose stop

if [ "$1" == "--keep-containers" ]; then
    echo "Containers were kept"
else
    echo "Containers were deleted"
    docker-compose rm -fv
fi