#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=1.4

source backup/settings.env
SOURCE_VERSION=${ZBR_VERSION}

if ! [[ "${TARGET_VERSION}" > "${SOURCE_VERSION}" ]]; then
  #target Zebrunner version less or equal existing
  echo "No need to perform upgrade to ${TARGET_VERSION}"
  exit 2
fi

echo "Upgrading Zebrunner from ${SOURCE_VERSION} to ${TARGET_VERSION}"
# apply jenkins changes
if [[ ! -f jenkins/.disabled ]] ; then
  # remove ./resources/init.groovy.d/setup_aws_credentials.groovy
  docker run --rm --volumes-from jenkins-master "ubuntu" bash -c "rm /var/jenkins_home/init.groovy.d/setup_aws_credentials.groovy"
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi

  # override default RegisterRepository job by new one
  docker cp jenkins/resources/jobs/RegisterRepository/config.xml jenkins-master:/var/jenkins_home/jobs/RegisterRepository/
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi
  # override default launcher job by new one
  docker cp jenkins/resources/jobs/launcher/config.xml jenkins-master:/var/jenkins_home/jobs/launcher/
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Unable to proceed upgrade as jenkins-master container not available!"
    exit 1
  fi


  # backup previous file
  cp jenkins/variables.env jenkins/variables.env_1.3
  # regenerage variables.env to register new ZEBRUNNER_VERSION var
  cp jenkins/variables.env.original jenkins/variables.env
  replace jenkins/variables.env "http://localhost:8080/jenkins" "$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins"
  replace jenkins/variables.env "INFRA_HOST=localhost:8080" "INFRA_HOST=${ZBR_INFRA_HOST}"

  if [[ ! -z $ZBR_SONAR_URL ]]; then
    replace jenkins/variables.env "SONAR_URL=" "SONAR_URL=${ZBR_SONAR_URL}"
  fi
fi

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  if [[ -f selenoid/.env ]]; then
    cp selenoid/.env selenoid/.env_1.3
  fi
  #.env.original -> .env to adjust s3 key pattern
  cp selenoid/.env.original selenoid/.env
  if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
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
  cp reporting/configuration/zebrunner-proxy/nginx.conf reporting/configuration/zebrunner-proxy/nginx.conf_1.3
  # apply new nginx rules for test and run artifacts
  cp reporting/configuration/zebrunner-proxy/nginx.conf.original reporting/configuration/zebrunner-proxy/nginx.conf
  if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
    # use case with AWS S3
    replace reporting/configuration/zebrunner-proxy/nginx.conf "custom_secret_value" "${ZBR_STORAGE_AGENT_KEY}"
    replace reporting/configuration/zebrunner-proxy/nginx.conf "/zebrunner/" "/${ZBR_STORAGE_BUCKET}/"
    replace reporting/configuration/zebrunner-proxy/nginx.conf "http://minio:9000" "${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}"
  fi
fi

# apply mcloud changes
if [[ ! -f mcloud/.disabled ]] ; then
  cp mcloud/.env mcloud/.env_1.3
  # apply new changes to .env using .env.original
  cp mcloud/.env.original mcloud/.env
  replace mcloud/.env "localhost" "${ZBR_HOSTNAME}"

  cp mcloud/variables.env mcloud/variables.env_1.3
  # apply new changes to variables.env using variables.env.original
  cp mcloud/variables.env.original mcloud/variables.env
  replace mcloud/variables.env "http://localhost:8082" "${url}"
  replace mcloud/variables.env "localhost" "${ZBR_HOSTNAME}"

  if [[ $ZBR_MINIO_ENABLED -eq 0 ]]; then
    # use case with AWS S3
    replace mcloud/variables.env "S3_REGION=us-east-1" "S3_REGION=${ZBR_STORAGE_REGION}"
    replace mcloud/variables.env "S3_ENDPOINT=http://minio:9000" "S3_ENDPOINT=${ZBR_STORAGE_ENDPOINT_PROTOCOL}://${ZBR_STORAGE_ENDPOINT_HOST}"
    replace mcloud/variables.env "S3_BUCKET=zebrunner" "S3_BUCKET=${ZBR_STORAGE_BUCKET}"
    replace mcloud/variables.env "S3_ACCESS_KEY_ID=zebrunner" "S3_ACCESS_KEY_ID=${ZBR_STORAGE_ACCESS_KEY}"
    replace mcloud/variables.env "S3_SECRET=J33dNyeTDj" "S3_SECRET=${ZBR_STORAGE_SECRET_KEY}"
    replace mcloud/variables.env "S3_TENANT=" "S3_TENANT=${ZBR_STORAGE_TENANT}"
  fi

  # remove deprecated containers
  docker rm -f selenium-hub ftp

  # ask about removal of the ftp data volume
  confirm "" "      Do you want to remove MCloud FTP data volume? You might lose old video recordings! Answer \"n\" to keep FTP artifacts." "n"
  if [[ $? -eq 1 ]]; then
    docker volume rm mcloud_data-volume
  fi

fi

# apply nginx changes
cp nginx/conf.d/default.conf nginx/conf.d/default.conf_1.3
cp nginx/conf.d/default.conf.original nginx/conf.d/default.conf

replace ./nginx/conf.d/default.conf "server_name localhost" "server_name '$ZBR_HOSTNAME'"
replace ./nginx/conf.d/default.conf "listen 80" "listen '$ZBR_PORT'"

# finish with NGiNX default tool selection
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

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
