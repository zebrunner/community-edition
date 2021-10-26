#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=1.9

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# apply zebrunner-ce changes
cp .env.original .env
replace .env "ZBR_PORT=80" "ZBR_PORT=${ZBR_PORT}"

# apply nginx changes
cp nginx/conf.d/default.conf nginx/conf.d/default.conf.bak_1.8
cp nginx/conf.d/default.conf.original nginx/conf.d/default.conf

replace ./nginx/conf.d/default.conf "server_name localhost" "server_name '$ZBR_HOSTNAME'"
# declare ssl protocol for NGiNX default config
if [[ "$ZBR_PROTOCOL" == "https" ]]; then
  replace ./nginx/conf.d/default.conf "listen 80" "listen 80 ssl"

  # uncomment default ssl settings
  replace ./nginx/conf.d/default.conf "#    ssl_" "    ssl_"

  # configure valid sub-modules rules
  replace ./nginx/conf.d/default.conf "http://jenkins-master:8080;" "https://jenkins-master:8443;"
  replace ./nginx/conf.d/default.conf "upstream_sonar http://127.0.0.1:80;" "upstream_sonar https://127.0.0.1:80;"
  replace ./nginx/conf.d/default.conf "upstream_mcloud http://127.0.0.1:80;" "upstream_mcloud https://127.0.0.1:80;"
fi

if [[ $ZBR_REPORTING_ENABLED -eq 1 ]]; then
  replace ./nginx/conf.d/default.conf "default-proxy-server" "zebrunner-proxy:80"
  replace ./nginx/conf.d/default.conf "default-proxy-host" "zebrunner-proxy"
elif [[ $ZBR_MCLOUD_ENABLED -eq 1 ]]; then
  replace ./nginx/conf.d/default.conf "default-proxy-server" "stf-proxy:80"
  replace ./nginx/conf.d/default.conf "default-proxy-host" "stf-proxy"
elif [[ $ZBR_JENKINS_ENABLED -eq 1 ]]; then
  replace ./nginx/conf.d/default.conf 'set $upstream_default default-proxy-server;' ""
  replace ./nginx/conf.d/default.conf "proxy_set_header Host default-proxy-host;" ""
  replace ./nginx/conf.d/default.conf 'proxy_pass http://$upstream_default;' "rewrite / /jenkins;"
elif [[ $ZBR_SONARQUBE_ENABLED -eq 1 ]]; then
  replace ./nginx/conf.d/default.conf 'set $upstream_default default-proxy-server;' ""
  replace ./nginx/conf.d/default.conf "proxy_set_header Host default-proxy-host;" ""
  replace ./nginx/conf.d/default.conf 'proxy_pass http://$upstream_default;' "rewrite / /sonarqube;"
else
  replace ./nginx/conf.d/default.conf 'proxy_pass http://$upstream_default;' "root   /usr/share/nginx/html;"
fi

# apply jenkins changes
if [[ ! -f jenkins/.disabled ]] ; then
  # copy resources/ssl/keystore.jks to /var/jenkins_home
  docker cp jenkins/resources/ssl/keystore.jks jenkins-master:/var/jenkins_home
  # remove ./jobs/Management_Jobs/jobs/RegisterQTestCredentials
  docker run --rm --volumes-from jenkins-master "ubuntu" bash -c "rm -rf /var/jenkins_home/jobs/Management_Jobs/jobs/RegisterQTestCredentials /var/jenkins_home/jobs/Management_Jobs/jobs/RegisterTestRailCredentials /var/jenkins_home/jobs/Management_Jobs/jobs/SmartJobsRerun"
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi
fi

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  cp selenoid/.env selenoid/.env_1.8
  cp selenoid/.env.original selenoid/.env
  if [[ ! $ZBR_MINIO_ENABLED -eq 1 ]]; then
    # use case with AWS S3
    replace selenoid/.env "S3_REGION=us-east-1" "S3_REGION=${ZBR_STORAGE_REGION}"
    replace selenoid/.env "S3_ENDPOINT=http://minio:9000" "S3_ENDPOINT=${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}"
    replace selenoid/.env "S3_BUCKET=zebrunner" "S3_BUCKET=${ZBR_STORAGE_BUCKET}"
    replace selenoid/.env "S3_ACCESS_KEY_ID=zebrunner" "S3_ACCESS_KEY_ID=${ZBR_STORAGE_ACCESS_KEY}"
    replace selenoid/.env "S3_SECRET=J33dNyeTDj" "S3_SECRET=${ZBR_STORAGE_SECRET_KEY}"

    if [[ ! -z $ZBR_STORAGE_TENANT ]]; then
      replace selenoid/.env "/artifacts" "${ZBR_STORAGE_TENANT}/artifacts"
    fi
  fi
fi


# apply reporting changes
if [[ ! -f reporting/.disabled ]] ; then
  cp reporting/.env.original reporting/.env

  docker stop reporting-service
  sleep 3
  docker cp patch/sql/reporting-1.26-db-migration.sql postgres:/tmp
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as postgres container not available."
    exit 1
  fi
  docker exec -i postgres /usr/bin/psql -U postgres -f /tmp/reporting-1.26-db-migration.sql
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to apply reporting-1.26-db-migration.sql"
    exit 1
  fi
fi

#apply mcloud changes
if [[ ! -f mcloud/.disabled ]] ; then
  cp mcloud/.env.original mcloud/.env
  stf_url="$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT"
  replace mcloud/.env "STF_URL=http://localhost:8082" "STF_URL=${stf_url}"
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
