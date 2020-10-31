#!/bin/bash

export_settings() {
  export -p | grep "ZBR" > backup/settings.env
}


TARGET_VERSION=1.2

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 1
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"

# apply jenkins changes
if [[ ! -f jenkins/.disabled ]] ; then
  # override all groovy scripts by new one
  docker cp jenkins/resources/init.groovy.d jenkins-master:/var/jenkins_home/
  if [[ $? -eq 1 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit -1
  fi

  # override alldefault jobs by new ones
  docker cp jenkins/resources/jobs jenkins-master:/var/jenkins_home/
  if [[ $? -eq 1 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit -1
  fi
fi


echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
