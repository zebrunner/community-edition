#!/bin/bash

# shellcheck disable=SC1091
source utility.sh

TARGET_VERSION=1.8

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# apply reporting changes
if [[ ! -f reporting/.disabled ]] ; then
  docker stop reporting-service
  sleep 3
  docker cp patch/sql/reporting-1.24-db-migration.sql postgres:/tmp
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as postgres container not available."
    exit 1
  fi
  docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/reporting-1.24-db-migration.sql
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to apply reporting-1.24-db-migration.sql"
    exit 1
  fi
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
