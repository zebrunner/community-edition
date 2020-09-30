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

# apply new nginx rules for logs and screenshots artifacts
cp reporting/configuration/zebrunner-proxy/nginx.conf.original reporting/configuration/zebrunner-proxy/nginx.conf
if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
  # use case with AWS S3
  sed -i "s#custom_secret_value#${ZBR_STORAGE_AGENT_KEY}#g" reporting/configuration/zebrunner-proxy/nginx.conf
  sed -i "s#/zebrunner/#/${ZBR_STORAGE_BUCKET}/#g" reporting/configuration/zebrunner-proxy/nginx.conf
  sed -i "s#http://minio:9000#${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}#g" reporting/configuration/zebrunner-proxy/nginx.conf
fi

# apply new elasticsearch variables
cp reporting/configuration/reporting-service/variables.env.original reporting/configuration/reporting-service/variables.env
sed -i "s#http://localhost:8081#${url}#g" reporting/configuration/reporting-service/variables.env

sed -i "s#GITHUB_HOST=github.com#GITHUB_HOST=${ZBR_GITHUB_HOST}#g" reporting/configuration/reporting-service/variables.env
sed -i "s#GITHUB_CLIENT_ID=#GITHUB_CLIENT_ID=${ZBR_GITHUB_CLIENT_ID}#g" reporting/configuration/reporting-service/variables.env
sed -i "s#GITHUB_CLIENT_SECRET=#GITHUB_CLIENT_SECRET=${ZBR_GITHUB_CLIENT_SECRET}#g" reporting/configuration/reporting-service/variables.env

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
