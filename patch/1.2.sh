#!/bin/bash

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

  # override all default jobs by new ones
  docker cp jenkins/resources/jobs jenkins-master:/var/jenkins_home/
  if [[ $? -eq 1 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit -1
  fi

  # ask about presence of any private Global Pipeline Library. If not - replace by new value.
  confirm "" "      Do you have custom Global Pipeline Libraries registered? If answer \"n\" they will be overwritten by new Zebrunner-CE?" "n"
  if [[ $? -eq 0 ]]; then
    docker cp jenkins/resources/configs/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml jenkins-master:/var/jenkins_home/
  fi

  # ask about presence of any custom global choice lists. If not - replace by new values.
  confirm "" "      Do you have custom Global Pipeline Libraries registered? If answer \"n\" they will be overwritten by new Zebrunner-CE?" "n"
  if [[ $? -eq 0 ]]; then
    docker cp jenkins/resources/configs/jp.ikedam.jenkins.plugins.extensible_choice_parameter.GlobalTextareaChoiceListProvider.xml jenkins-master:/var/jenkins_home/
  fi
fi


echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
