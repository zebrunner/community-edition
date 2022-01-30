#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=1.10

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# apply nginx changes
cp nginx/conf.d/default.conf nginx/conf.d/default.conf.bak_1.9
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
  replace ./nginx/conf.d/default.conf "upstream_stf http://stf-proxy:80;" "upstream_stf https://stf-proxy:80;"
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

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  cp selenoid/.env selenoid/.env_1.9
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
fi

#apply mcloud changes
if [[ ! -f mcloud/.disabled ]] ; then
  cp mcloud/.env mcloud/.env_1.9
  cp mcloud/configuration/stf-proxy/nginx.conf mcloud/configuration/stf-proxy/nginx.conf_1.9
  cp mcloud/variables.env  mcloud/variables.env_1.9

  url="$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT"
  cp mcloud/.env.original mcloud/.env
  replace mcloud/.env "STF_URL=http://localhost:8082" "STF_URL=${url}"
  replace mcloud/.env "STF_PORT=8082" "STF_PORT=$ZBR_MCLOUD_PORT"

  cp mcloud/variables.env.original mcloud/variables.env
  replace mcloud/variables.env "http://localhost:8082" "${url}"
  replace mcloud/variables.env "localhost" "${ZBR_HOSTNAME}"

  replace mcloud/variables.env "STF_ADMIN_NAME=admin" "STF_ADMIN_NAME=${ZBR_MCLOUD_ADMIN_NAME}"
  replace mcloud/variables.env "STF_ADMIN_EMAIL=admin@zebrunner.com" "STF_ADMIN_EMAIL=${ZBR_MCLOUD_ADMIN_EMAIL}"

  cp mcloud/configuration/stf-proxy/nginx.conf.original mcloud/configuration/stf-proxy/nginx.conf
  replace mcloud/configuration/stf-proxy/nginx.conf "server_name localhost" "server_name '$ZBR_HOSTNAME'"
  # declare ssl protocol for NGiNX default config
  if [[ "$ZBR_PROTOCOL" == "https" ]]; then
    replace mcloud/configuration/stf-proxy/nginx.conf "listen 80" "listen 80 ssl"

    # uncomment default ssl settings
    replace mcloud/configuration/stf-proxy/nginx.conf "#    ssl_" "    ssl_"
  fi
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
