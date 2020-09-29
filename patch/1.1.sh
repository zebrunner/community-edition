#!/bin/bash

export_settings() {
  export -p | grep "ZBR" > backup/settings.env
}


TARGET_VERSION=1.1

source backup/settings.env
if [[ -z ${ZBR_VERSION} ]]; then
  ZBR_VERSION=1.0
fi
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade from ${SOURCE_VERSION} to ${TARGET_VERSION}"
  exit 0
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# Zebrunner Reporting steps:
# apply new logstash settings 
cp reporting/configuration/logstash/logstash.conf.original reporting/configuration/logstash/logstash.conf
sed -i "s#rabbitmq-user#${ZBR_RABBITMQ_USER}#g" reporting/configuration/logstash/logstash.conf
sed -i "s#rabbitmq-password#${ZBR_RABBITMQ_PASSWORD}#g" reporting/configuration/logstash/logstash.conf

# apply new rabbitmq settings
cp reporting/configuration/rabbitmq/variables.env.original reporting/configuration/rabbitmq/variables.env
sed -i "s#RABBITMQ_DEFAULT_USER=qpsdemo#RABBITMQ_DEFAULT_USER=${ZBR_RABBITMQ_USER}#g" reporting/configuration/rabbitmq/variables.env
sed -i "s#RABBITMQ_DEFAULT_PASS=qpsdemo#RABBITMQ_DEFAULT_PASS=${ZBR_RABBITMQ_PASSWORD}#g" reporting/configuration/rabbitmq/variables.env

# apply new rabbitmq definitions
cp reporting/configuration/rabbitmq/definitions/001-general-definition.json.original reporting/configuration/rabbitmq/definitions/001-general-definition.json
sed -i "s#rabbitmq-user#${ZBR_RABBITMQ_USER}#g" reporting/configuration/rabbitmq/definitions/001-general-definition.json
sed -i "s#rabbitmq-password#${ZBR_RABBITMQ_PASSWORD}#g" reporting/configuration/rabbitmq/definitions/001-general-definition.json

#remove old rabbitmq definition file
rm -f reporting/configuration/rabbitmq/definitions.json.original
rm -f reporting/configuration/rabbitmq/definitions.json

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
