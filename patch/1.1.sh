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

# Apply postgres DB migration script only if reporting enabled
if [[ ! -f reporting/.disabled ]] ; then
  docker cp patch/reporting-1.12-db-migration.sql postgres:/tmp
  if [[ $? -eq 1 ]]; then
    echo "ERROR! Unable to proceed upgrade as postgres container not available"
    exit -1
  fi
  docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/reporting-1.12-db-migration.sql
  if [[ $? -eq 1 ]]; then
    echo "ERROR! Unable to apply reporting-1.12-db-migration.sql"
    exit 0
  fi
fi


# Zebrunner NGiNX WebServer configuration
cp ./nginx/conf.d/default.conf.original ./nginx/conf.d/default.conf
sed -i 's/server_name localhost/server_name '$ZBR_HOSTNAME'/g' ./nginx/conf.d/default.conf
sed -i 's/listen 80/listen '$ZBR_PORT'/g' ./nginx/conf.d/default.conf

# Zebrunner Reporting steps:

# apply new nginx rules for logs and screenshots artifacts
cp reporting/configuration/zebrunner-proxy/nginx.conf.original reporting/configuration/zebrunner-proxy/nginx.conf
if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
  # use case with AWS S3
  sed -i "s#custom_secret_value#${ZBR_STORAGE_AGENT_KEY}#g" reporting/configuration/zebrunner-proxy/nginx.conf
  sed -i "s#/zebrunner/#/${ZBR_STORAGE_BUCKET}/#g" reporting/configuration/zebrunner-proxy/nginx.conf
  sed -i "s#http://minio:9000#${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}#g" reporting/configuration/zebrunner-proxy/nginx.conf
fi

# adding new variables for elasticsearch
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

# apply new logstash settings 
cp reporting/configuration/logstash/logstash.conf.original reporting/configuration/logstash/logstash.conf
sed -i "s#rabbitmq-user#${ZBR_RABBITMQ_USER}#g" reporting/configuration/logstash/logstash.conf
sed -i "s#rabbitmq-password#${ZBR_RABBITMQ_PASSWORD}#g" reporting/configuration/logstash/logstash.conf

# apply new rabbitmq settings
cp reporting/configuration/rabbitmq/variables.env.original reporting/configuration/rabbitmq/variables.env
sed -i "s#RABBITMQ_DEFAULT_USER=rabbitmq-user#RABBITMQ_DEFAULT_USER=${ZBR_RABBITMQ_USER}#g" reporting/configuration/rabbitmq/variables.env
sed -i "s#RABBITMQ_DEFAULT_PASS=rabbitmq-password#RABBITMQ_DEFAULT_PASS=${ZBR_RABBITMQ_PASSWORD}#g" reporting/configuration/rabbitmq/variables.env

# apply new rabbitmq definitions
cp reporting/configuration/rabbitmq/001-general-definition.json.original reporting/configuration/rabbitmq/definitions/001-general-definition.json
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
