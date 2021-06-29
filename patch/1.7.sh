#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=1.7

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# apply mcloud changes
if [[ ! -f mcloud/.disabled ]] ; then
  # backup previous file
  cp mcloud/.env mcloud/.env_1.6
  # regenerate .env to bump up to mcloud-grid:1.1
  cp mcloud/.env.original mcloud/.env
  replace mcloud/.env "localhost" "${ZBR_HOSTNAME}"
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
