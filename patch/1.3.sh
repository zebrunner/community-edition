#!/bin/bash

  export_settings() {
    export -p | grep "ZBR" > backup/settings.env
  }

  replace() {
    #TODO: https://github.com/zebrunner/zebrunner/issues/328 organize debug logging for setup/replace
    file=$1
    #echo "file: $file"
    content=$(<$file) # read the file's content into
    #echo "content: $content"

    old=$2
    #echo "old: $old"

    new=$3
    #echo "new: $new"
    content=${content//"$old"/$new}

    #echo "content: $content"

    printf '%s' "$content" >$file    # write new content to disk
  }


TARGET_VERSION=1.3

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

  # regenerage variables.env to register new ZEBRUNNER_VERSION var
  cp jenkins/variables.env.original jenkins/variables.env
  sed -i "s#http://localhost:8080/jenkins#$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins#g" jenkins/variables.env
  sed -i "s#INFRA_HOST=localhost:8080#INFRA_HOST=${ZBR_INFRA_HOST}#g" jenkins/variables.env

  if [[ ! -z $ZBR_SONAR_URL ]]; then
    sed -i "s#SONAR_URL=#SONAR_URL=${ZBR_SONAR_URL}#g" jenkins/variables.env
  fi
fi

if [[ ! -f reporting/.disabled ]] ; then
  # https://github.com/zebrunner/reporting/issues/2266 regenerating reporting-service/variables.env
  cp reporting/configuration/reporting-service/variables.env.original reporting/configuration/reporting-service/variables.env
  sed -i "s#http://localhost:8081#$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT#g" reporting/configuration/reporting-service/variables.env

  sed -i "s#GITHUB_HOST=github.com#GITHUB_HOST=${ZBR_GITHUB_HOST}#g" reporting/configuration/reporting-service/variables.env
  sed -i "s#GITHUB_CLIENT_ID=#GITHUB_CLIENT_ID=${ZBR_GITHUB_CLIENT_ID}#g" reporting/configuration/reporting-service/variables.env
  sed -i "s#GITHUB_CLIENT_SECRET=#GITHUB_CLIENT_SECRET=${ZBR_GITHUB_CLIENT_SECRET}#g" reporting/configuration/reporting-service/variables.env

  sed -i "s#DATABASE_PASSWORD=db-changeit#DATABASE_PASSWORD=${ZBR_POSTGRES_PASSWORD}#g" reporting/configuration/reporting-service/variables.env
  sed -i "s#REDIS_PASSWORD=MdXVvJgDdz9Hnau7#REDIS_PASSWORD=${ZBR_REDIS_PASSWORD}#g" reporting/configuration/reporting-service/variables.env

  # apply new integration settings
  if [[ $ZBR_JENKINS_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
    # update reporting-jenkins integration vars
    sed -i "s#JENKINS_ENABLED=false#JENKINS_ENABLED=true#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#JENKINS_URL=#JENKINS_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins#g" reporting/configuration/reporting-service/variables.env
  fi
  if [[ $ZBR_MCLOUD_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
    # update reporting-mcloud integration vars
    sed -i "s#MCLOUD_ENABLED=false#MCLOUD_ENABLED=true#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#MCLOUD_URL=#MCLOUD_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/mcloud/wd/hub#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#MCLOUD_USER=#MCLOUD_USER=demo#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#MCLOUD_PASSWORD=#MCLOUD_PASSWORD=demo#g" reporting/configuration/reporting-service/variables.env
  fi

  if [[ $ZBR_SELENOID_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
    # update reporting-jenkins integration vars
    sed -i "s#SELENIUM_ENABLED=false#SELENIUM_ENABLED=true#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#SELENIUM_URL=#SELENIUM_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/selenoid/wd/hub#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#SELENIUM_USER=#SELENIUM_USER=demo#g" reporting/configuration/reporting-service/variables.env
    sed -i "s#SELENIUM_PASSWORD=#SELENIUM_PASSWORD=demo#g" reporting/configuration/reporting-service/variables.env
  fi

  # https://github.com/zebrunner/reporting/issues/2267 regenerating s3.env using new variable
  cp reporting/configuration/_common/s3.env.original reporting/configuration/_common/s3.env
  if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
    # use case with AWS S3
    sed -i "s#S3_REGION=us-east-1#S3_REGION=${ZBR_STORAGE_REGION}#g" reporting/configuration/_common/s3.env
    sed -i "s#ZEBRUNNER_AWSS3_ENDPOINT=http://minio:9000#ZEBRUNNER_AWSS3_ENDPOINT=${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}#g" reporting/configuration/_common/s3.env
    sed -i "s#S3_BUCKET=zebrunner#S3_BUCKET=${ZBR_STORAGE_BUCKET}#g" reporting/configuration/_common/s3.env
    sed -i "s#S3_ACCESS_KEY_ID=zebrunner#S3_ACCESS_KEY_ID=${ZBR_STORAGE_ACCESS_KEY}#g" reporting/configuration/_common/s3.env
    replace reporting/configuration/_common/s3.env "S3_SECRET=J33dNyeTDj" "S3_SECRET=${ZBR_STORAGE_SECRET_KEY}"
  fi

fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
