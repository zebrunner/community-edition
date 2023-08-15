#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=2.4

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}
#echo SOURCE_VERSION: $SOURCE_VERSION

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"

# apply nginx changes

#apply mcloud changes
if [[ ! -f mcloud/.disabled ]] ; then
  cp mcloud/.env mcloud/.env_2.3
  cp mcloud/variables.env  mcloud/variables.env_2.3

  mcloud/zebrunner.sh setup
fi

#apply jenkins changes
if [[ ! -f jenkins/.disabled ]] ; then
  cp jenkins/variables.env jenkins/variables.env_2.3
  jenkins/zebrunner.sh setup
fi

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  cp selenoid/.env selenoid/.env_2.3
  selenoid/zebrunner.sh setup
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
