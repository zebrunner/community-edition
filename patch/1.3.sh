#!/bin/bash

  export_settings() {
    export -p | grep "ZBR" > backup/settings.env
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
fi


echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
