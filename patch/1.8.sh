#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=1.8

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
  # override all default jobs by new ones
  docker cp jenkins/resources/jobs jenkins-master:/var/jenkins_home/
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi

  # backup previous file
  cp jenkins/variables.env jenkins/variables.env_1.7
  # regenerage variables.env to register new ZEBRUNNER_VERSION var
  cp jenkins/variables.env.original jenkins/variables.env
  replace jenkins/variables.env "http://localhost:8080/jenkins" "$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins"
  replace jenkins/variables.env "INFRA_HOST=localhost:8080" "INFRA_HOST=${ZBR_INFRA_HOST}"

  if [[ ! -z $ZBR_SONAR_URL ]]; then
    replace jenkins/variables.env "SONAR_URL=" "SONAR_URL=${ZBR_SONAR_URL}"
  fi
fi

# apply reporting changes
if [[ ! -f reporting/.disabled ]] ; then
  cp reporting/configuration/zebrunner-proxy/nginx.conf reporting/configuration/zebrunner-proxy/nginx.conf_1.7
  # apply new nginx rules for screenshots: https://github.com/zebrunner/zebrunner/issues/458
  cp reporting/configuration/zebrunner-proxy/nginx.conf.original reporting/configuration/zebrunner-proxy/nginx.conf
  if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
    # use case with AWS S3
    replace reporting/configuration/zebrunner-proxy/nginx.conf "custom_secret_value" "${ZBR_STORAGE_AGENT_KEY}"
    replace reporting/configuration/zebrunner-proxy/nginx.conf "/zebrunner/" "/${ZBR_STORAGE_BUCKET}/"
    replace reporting/configuration/zebrunner-proxy/nginx.conf "http://minio:9000" "${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}"
  fi
fi

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
