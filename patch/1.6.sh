#!/bin/bash

# shellcheck disable=SC1091
source utility.sh

  export_settings() {
    export -p | grep "ZBR" > backup/settings.env
  }

  confirm() {
    local message=$1
    local question=$2
    local isEnabled=$3

    if [[ "$isEnabled" == "1" ]]; then
      isEnabled="y"
    fi
    if [[ "$isEnabled" == "0" ]]; then
      isEnabled="n"
    fi

    while true; do
      if [[ ! -z $message ]]; then
        echo "$message"
      fi

      read -p "$question y/n [$isEnabled]:" response
      if [[ -z $response ]]; then
        if [[ "$isEnabled" == "y" ]]; then
          return 1
        fi
        if [[ "$isEnabled" == "n" ]]; then
          return 0
        fi
      fi

      if [[ "$response" == "y" || "$response" == "Y" ]]; then
        return 1
      fi

      if [[ "$response" == "n" ||  "$response" == "N" ]]; then
        return 0
      fi

      echo "Please answer y (yes) or n (no)."
      echo
    done
  }

TARGET_VERSION=1.6

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
  docker cp patch/sql/reporting-1.22-db-migration.sql postgres:/tmp
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as postgres container not available."
    exit 1
  fi
  docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/reporting-1.22-db-migration.sql
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to apply reporting-1.22-db-migration.sql"
    exit 1
  fi
fi

# #424: apply selenoid changes
cp selenoid/.env selenoid/.env_1.5
cp selenoid/.env.original selenoid/.env
if [[ ! $ZBR_MINIO_ENABLED -eq 1 ]]; then
  # use case with AWS S3
  replace selenoid/.env "S3_REGION=us-east-1" "S3_REGION=${ZBR_STORAGE_REGION}"
  replace selenoid/.env "S3_ENDPOINT=http://minio:9000" "S3_ENDPOINT=${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}"
  replace selenoid/.env "S3_BUCKET=zebrunner" "S3_BUCKET=${ZBR_STORAGE_BUCKET}"
  replace selenoid/.env "S3_ACCESS_KEY_ID=zebrunner" "S3_ACCESS_KEY_ID=${ZBR_STORAGE_ACCESS_KEY}"
  replace selenoid/.env "S3_SECRET=J33dNyeTDj" "S3_SECRET=${ZBR_STORAGE_SECRET_KEY}"

  if [[ ! -z $ZBR_STORAGE_TENANT ]]; then
    replace selenoid/.env "/artifacts" "${ZBR_STORAGE_TENANT}/artifacts"
  fi
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
