#!/bin/bash

# shellcheck disable=SC1091
source utility.sh

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
  replace jenkins/variables.env "http://localhost:8080/jenkins" "$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins"
  replace jenkins/variables.env "INFRA_HOST=localhost:8080" "INFRA_HOST=${ZBR_INFRA_HOST}"

  if [[ ! -z $ZBR_SONAR_URL ]]; then
    replace jenkins/variables.env "SONAR_URL=" "SONAR_URL=${ZBR_SONAR_URL}"
  fi
fi

if [[ ! -f reporting/.disabled ]] ; then
  # https://github.com/zebrunner/reporting/issues/2266 regenerating reporting-service/variables.env
  cp reporting/configuration/reporting-service/variables.env.original reporting/configuration/reporting-service/variables.env
  replace reporting/configuration/reporting-service/variables.env "http://localhost:8081" "$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT"

  replace reporting/configuration/reporting-service/variables.env "GITHUB_HOST=github.com" "GITHUB_HOST=${ZBR_GITHUB_HOST}"
  replace reporting/configuration/reporting-service/variables.env "GITHUB_CLIENT_ID=" "GITHUB_CLIENT_ID=${ZBR_GITHUB_CLIENT_ID}"
  replace reporting/configuration/reporting-service/variables.env "GITHUB_CLIENT_SECRET=" "GITHUB_CLIENT_SECRET=${ZBR_GITHUB_CLIENT_SECRET}"

  replace reporting/configuration/reporting-service/variables.env "DATABASE_PASSWORD=db-changeit" "DATABASE_PASSWORD=${ZBR_POSTGRES_PASSWORD}"
  replace reporting/configuration/reporting-service/variables.env "REDIS_PASSWORD=MdXVvJgDdz9Hnau7" "REDIS_PASSWORD=${ZBR_REDIS_PASSWORD}"

  # apply new integration settings
  if [[ $ZBR_JENKINS_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
    # update reporting-jenkins integration vars
    replace reporting/configuration/reporting-service/variables.env "JENKINS_ENABLED=false" "JENKINS_ENABLED=true"
    replace reporting/configuration/reporting-service/variables.env "JENKINS_URL=" "JENKINS_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins"
  fi
  if [[ $ZBR_MCLOUD_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
    # update reporting-mcloud integration vars
    replace reporting/configuration/reporting-service/variables.env "MCLOUD_ENABLED=false" "MCLOUD_ENABLED=true"
    replace reporting/configuration/reporting-service/variables.env "MCLOUD_URL=" "MCLOUD_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/mcloud/wd/hub"
    replace reporting/configuration/reporting-service/variables.env "MCLOUD_USER=" "MCLOUD_USER=demo"
    replace reporting/configuration/reporting-service/variables.env "MCLOUD_PASSWORD=" "MCLOUD_PASSWORD=demo"
  fi

  if [[ $ZBR_SELENOID_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
    # update reporting-jenkins integration vars
    replace reporting/configuration/reporting-service/variables.env "SELENIUM_ENABLED=false" "SELENIUM_ENABLED=true"
    replace reporting/configuration/reporting-service/variables.env "SELENIUM_URL=" "SELENIUM_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/selenoid/wd/hub"
    replace reporting/configuration/reporting-service/variables.env "SELENIUM_USER=" "SELENIUM_USER=demo"
    replace reporting/configuration/reporting-service/variables.env "SELENIUM_PASSWORD=" "SELENIUM_PASSWORD=demo"
  fi

  # https://github.com/zebrunner/zebrunner/issues/366 remove db-migration-ttol container and volume
  docker rm -f db-migration-tool
  docker volume rm reporting_migration-tool-volume

fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
