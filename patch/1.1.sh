#!/bin/bash

# shellcheck disable=SC1091
source utility.sh

export_settings() {
    export -p | grep "ZBR" > backup/settings.env
}

TARGET_VERSION=1.1

# shellcheck disable=SC1091
source backup/settings.env
if [[ -z ${ZBR_VERSION} ]]; then
    ZBR_VERSION=1.0
fi
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
    #target Zebrunner version less or equal existing
    echo "No need to perform upgrade to ${TARGET_VERSION}"
    exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"

# Apply postgres DB migration script only if reporting enabled
if [[ ! -f reporting/.disabled ]] ; then
    docker stop reporting-service
    sleep 3
    docker cp patch/sql/reporting-1.12-db-migration.sql postgres:/tmp
    if [[ $? -ne 0 ]]; then
        echo "ERROR! Unable to proceed upgrade as postgres container not available"
        exit 1
    fi
    docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/reporting-1.12-db-migration.sql
    if [[ $? -ne 0 ]]; then
        echo "ERROR! Unable to apply reporting-1.12-db-migration.sql"
        exit 1
    fi
fi


# Zebrunner NGiNX WebServer configuration
cp ./nginx/conf.d/default.conf.original ./nginx/conf.d/default.conf
replace ./nginx/conf.d/default.conf "server_name localhost" "server_name '$ZBR_HOSTNAME'"
replace ./nginx/conf.d/default.conf "listen 80" "listen '$ZBR_PORT'"

# Zebrunner Reporting steps:

# apply new nginx rules for logs and screenshots artifacts
cp reporting/configuration/zebrunner-proxy/nginx.conf.original reporting/configuration/zebrunner-proxy/nginx.conf
if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
    # use case with AWS S3
    replace reporting/configuration/zebrunner-proxy/nginx.conf "custom_secret_value" "${ZBR_STORAGE_AGENT_KEY}"
    replace reporting/configuration/zebrunner-proxy/nginx.conf "/zebrunner/" "/${ZBR_STORAGE_BUCKET}/"
    replace reporting/configuration/zebrunner-proxy/nginx.conf "http://minio:9000" "${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}"
fi

# adding new variables for elasticsearch
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

# apply new logstash settings
cp reporting/configuration/logstash/logstash.conf.original reporting/configuration/logstash/logstash.conf
replace reporting/configuration/logstash/logstash.conf "rabbitmq-user" "${ZBR_RABBITMQ_USER}"
replace reporting/configuration/logstash/logstash.conf "rabbitmq-password" "${ZBR_RABBITMQ_PASSWORD}"

# apply new rabbitmq settings
cp reporting/configuration/rabbitmq/variables.env.original reporting/configuration/rabbitmq/variables.env
replace reporting/configuration/rabbitmq/variables.env "RABBITMQ_DEFAULT_USER=rabbitmq-user" "RABBITMQ_DEFAULT_USER=${ZBR_RABBITMQ_USER}"
replace reporting/configuration/rabbitmq/variables.env "RABBITMQ_DEFAULT_PASS=rabbitmq-password" "RABBITMQ_DEFAULT_PASS=${ZBR_RABBITMQ_PASSWORD}"

# apply new rabbitmq definitions
cp reporting/configuration/rabbitmq/001-general-definition.json.original reporting/configuration/rabbitmq/definitions/001-general-definition.json
replace reporting/configuration/rabbitmq/definitions/001-general-definition.json "rabbitmq-user" "${ZBR_RABBITMQ_USER}"
replace reporting/configuration/rabbitmq/definitions/001-general-definition.json "rabbitmq-password" "${ZBR_RABBITMQ_PASSWORD}"

#remove old rabbitmq definition file
rm -f reporting/configuration/rabbitmq/definitions.json.original
rm -f reporting/configuration/rabbitmq/definitions.json

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
