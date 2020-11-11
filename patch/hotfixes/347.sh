#!/bin/bash


docker cp 347.sql postgres:/tmp
if [[ $? -ne 0 ]]; then
  echo "ERROR! Unable to proceed with #347 hotfix as postgres container not available"
  exit 1
fi
docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/347.sql
if [[ $? -ne 0 ]]; then
  echo "ERROR! Unable to apply 347.sql"
  exit 1
fi

