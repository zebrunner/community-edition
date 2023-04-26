#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh

TARGET_VERSION=2.3

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
cp nginx/conf.d/default.conf nginx/conf.d/default.conf.bak_2.2
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

#apply mcloud changes
if [[ ! -f mcloud/.disabled ]] ; then
  cp mcloud/.env mcloud/.env_2.2
  cp mcloud/variables.env  mcloud/variables.env_2.2

  mcloud/zebrunner.sh setup
fi

#apply jenkins changes
if [[ ! -f jenkins/.disabled ]] ; then
  cp jenkins/variables.env jenkins/variables.env_2.2
  #549 remove ./jobs/Management_Jobs/jobs/* to recreate using new main branch
  docker run --rm --volumes-from jenkins-master "ubuntu" bash -c "rm -rf /var/jenkins_home/jobs/Management_Jobs/jobs/DeleteOrganization \
	/var/jenkins_home/jobs/Management_Jobs/jobs/RegisterHubCredentials \
	/var/jenkins_home/jobs/Management_Jobs/jobs/RegisterMavenSettings \
	/var/jenkins_home/jobs/Management_Jobs/jobs/RegisterOrganization \
	/var/jenkins_home/jobs/Management_Jobs/jobs/RegisterReportingCredentials \
	/var/jenkins_home/jobs/Management_Jobs/jobs/RegisterUserCredentials"
  jenkins/zebrunner.sh setup
fi

# apply sonarqube changes
if [[ ! -f sonarqube/.disabled ]] ; then
  docker rm -f sonarqube
  docker volume rm sonarqube_data-volume sonarqube_extensions-volume sonarqube_logs-volume
  sonarqube/zebrunner.sh setup
fi

# apply selenoid changes
if [[ ! -f selenoid/.disabled ]] ; then
  cp selenoid/.env selenoid/.env_2.2
  selenoid/zebrunner.sh setup
fi

echo "Upgrade to ${TARGET_VERSION} finished successfully"

#remember successfully applied version in settings.env file
export ZBR_VERSION=${TARGET_VERSION}

#save information about upgraded zebrunner version
export_settings
