#!/bin/bash
TARGET_VERSION=1.1

source backup/settings.env
if [[ -z ${ZBR_VERSION} ]]; then
  ZBR_VERSION=1.0
fi
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target less or equal
  echo_warning "No need to perform upgrade from ${SOURCE_VERSION} to ${TARGET_VERSION}"
  exit 0
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
