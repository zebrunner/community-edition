#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=1.9

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# apply jenkins changes
if [[ ! -f jenkins/.disabled ]] ; then
  # remove ./jobs/Management_Jobs/jobs/RegisterQTestCredentials
  docker run --rm --volumes-from jenkins-master "ubuntu" bash -c "rm -rf /var/jenkins_home/jobs/Management_Jobs/jobs/RegisterQTestCredentials /var/jenkins_home/jobs/Management_Jobs/jobs/RegisterTestRailCredentials /var/jenkins_home/jobs/Management_Jobs/jobs/SmartJobsRerun"
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi
fi

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  cp selenoid/.env selenoid/.env_1.8
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
fi


# apply reporting changes
if [[ ! -f reporting/.disabled ]] ; then
  docker stop reporting-service
  sleep 3
  docker cp patch/sql/reporting-1.26-db-migration.sql postgres:/tmp
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as postgres container not available."
    exit 1
  fi
  docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/reporting-1.26-db-migration.sql
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to apply reporting-1.26-db-migration.sql"
    exit 1
  fi
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
