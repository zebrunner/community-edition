#!/bin/bash

  export_settings() {
    export -p | grep "ZBR" > backup/settings.env
  }

TARGET_VERSION=1.4

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
  # remove ./resources/init.groovy.d/setup_aws_credentials.groovy
  docker run --rm --volumes-from jenkins-master "ubuntu" bash -c "rm /var/jenkins_home/init.groovy.d/setup_aws_credentials.groovy"
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi

  # regenerage variables.env to register new ZEBRUNNER_VERSION var
  cp jenkins/variables.env.original jenkins/variables.env
  sed -i "s#http://localhost:8080/jenkins#$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins#g" jenkins/variables.env
  sed -i "s#INFRA_HOST=localhost:8080#INFRA_HOST=${ZBR_INFRA_HOST}#g" jenkins/variables.env

  if [[ ! -z $ZBR_SONAR_URL ]]; then
    sed -i "s#SONAR_URL=#SONAR_URL=${ZBR_SONAR_URL}#g" jenkins/variables.env
  fi
fi

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  #.env.original -> .env to adjust s3 key pattern
  cp selenoid/.env.original selenoid/.env
  if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
    # use case with AWS S3
    sed -i "s#S3_REGION=us-east-1#S3_REGION=${ZBR_STORAGE_REGION}#g" selenoid/.env
    sed -i "s#S3_ENDPOINT=http://minio:9000#S3_ENDPOINT=${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}#g" selenoid/.env
    sed -i "s#S3_BUCKET=zebrunner#S3_BUCKET=${ZBR_STORAGE_BUCKET}#g" selenoid/.env
    sed -i "s#S3_ACCESS_KEY_ID=zebrunner#S3_ACCESS_KEY_ID=${ZBR_STORAGE_ACCESS_KEY}#g" selenoid/.env
    sed -i "s#S3_SECRET=J33dNyeTDj#S3_SECRET=${ZBR_STORAGE_SECRET_KEY}#g" selenoid/.env

    if [[ ! -z $ZBR_STORAGE_TENANT ]]; then
      sed -i "s#/artifacts#${ZBR_STORAGE_TENANT}/artifacts#g" selenoid/.env
    fi
  fi
fi

#TODO: finish upgrade steps for mcloud/reporting/selenoid if necessary

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
