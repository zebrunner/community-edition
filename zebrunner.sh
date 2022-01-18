#!/bin/bash

# shellcheck disable=SC1091
source patch/utility.sh
source reporting/patch/settings.sh

  print_banner() {
  echo "
███████╗███████╗██████╗ ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗      ██████╗███████╗
╚══███╔╝██╔════╝██╔══██╗██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗    ██╔════╝██╔════╝
  ███╔╝ █████╗  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝    ██║     █████╗  
 ███╔╝  ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗    ██║     ██╔══╝  
███████╗███████╗██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║    ╚██████╗███████╗
╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝     ╚═════╝╚══════╝
"

  }

  setup() {
    print_banner

    # load default interactive installer settings
    # shellcheck disable=SC1091
    source backup/settings.env.original

    # load ./backup/settings.env if exist to declare ZBR* vars from previous run!
    if [[ -f backup/settings.env ]]; then
      source backup/settings.env
    fi

    export ZBR_INSTALLER=1
    export ZBR_VERSION=1.9
    set_global_settings

    cp .env.original .env
    replace .env "ZBR_PORT=80" "ZBR_PORT=${ZBR_PORT}"
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

    # Reporting is obligatory component now. But to be able to disable it we can register REPORTING_DISABLED=1 env variable before setup
    if [[ $ZBR_REPORTING_ENABLED -eq 1 && -z $REPORTING_DISABLED ]]; then
      set_reporting_settings
      reporting/zebrunner.sh setup
    else
      # explicitly disable reporting and minio as it was disabled by engineer via REPORTING_DISABLED env var
      export ZBR_REPORTING_ENABLED=0
      disableLayer "reporting"
      disableLayer "reporting/minio-storage"
    fi

    enableLayer "sonarqube" "Use embedded SonarQube to organize static code analysis and guiding your team?" "$ZBR_SONARQUBE_ENABLED"
    export ZBR_SONARQUBE_ENABLED=$?

    # jenkins after sonar to detect and put valid SONAR_URL value
    enableLayer "jenkins" "Use embedded Jenkins as recommended CI tool?" "$ZBR_JENKINS_ENABLED"
    export ZBR_JENKINS_ENABLED=$?

    enableLayer "selenoid" "Use embedded Web Selenium Hub for testing on chrome, firefox, opera and MicrosoftEdge browsers?" "$ZBR_SELENOID_ENABLED"
    export ZBR_SELENOID_ENABLED=$?

    enableLayer "mcloud" "Use embedded Mobile Device Farm and Selenium/Appium Hub for testing on Android, iOS, AppleTV etc devices?" "$ZBR_MCLOUD_ENABLED"
    export ZBR_MCLOUD_ENABLED=$?

    if [[ $ZBR_SONARQUBE_ENABLED -eq 1 ]]; then
      sonarqube/zebrunner.sh setup
      export ZBR_SONAR_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/sonarqube
    fi

    if [[ $ZBR_JENKINS_ENABLED -eq 1 ]]; then
      jenkins/zebrunner.sh setup
    fi

    if [[ $ZBR_MCLOUD_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 0 ]] || [[ $ZBR_SELENOID_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 0 ]]; then
      set_aws_storage_settings
    fi

    if [[ $ZBR_MCLOUD_ENABLED -eq 1 ]]; then
      mcloud/zebrunner.sh setup
    fi

    if [[ $ZBR_JENKINS_ENABLED -eq 1 && $ZBR_REPORTING_ENABLED -eq 1 ]]; then
      # update reporting-jenkins integration vars
      replace reporting/configuration/reporting-service/variables.env "JENKINS_ENABLED=false" "JENKINS_ENABLED=true"
      replace reporting/configuration/reporting-service/variables.env "JENKINS_URL=" "JENKINS_URL=$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins"
    fi

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

    # export all ZBR* variables to save user input
    export_settings

    echo
    echo "Copy and save auto-generated crendentials. Detailes can be found also in NOTICE.txt"
    echo

    notice=NOTICE.txt
    echo "NOTICES AND INFORMATION" > $notice
    echo >> $notice
    echo >> $notice

    echo "ZEBRUNNER URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT" | tee -a $notice
    echo | tee -a $notice

    if [[ $ZBR_REPORTING_ENABLED -eq 1 ]]; then
      echo "REPORTING SERVICE CREDENTIALS:" | tee -a $notice
      echo "USER: admin/changeit" | tee -a $notice
      echo "IAM POSTGRES: postgres/$ZBR_IAM_POSTGRES_PASSWORD" | tee -a $notice
      echo "REPORTING POSTGRES: postgres/$ZBR_POSTGRES_PASSWORD" | tee -a $notice
      echo "RABBITMQ: $ZBR_RABBITMQ_USER/$ZBR_RABBITMQ_PASSWORD" | tee -a $notice
      echo "REDIS: $ZBR_REDIS_PASSWORD" | tee -a $notice
      echo | tee -a $notice

      if [[ ZBR_SMTP_ENABLED -eq 1 ]]; then
        echo "REPORTING SMTP INTEGRATIONS:" | tee -a $notice
        echo "SMTP HOST: $ZBR_SMTP_HOST:$ZBR_SMTP_PORT" | tee -a $notice
        echo "EMAIL: $ZBR_SMTP_EMAIL" | tee -a $notice
        echo "USER: $ZBR_SMTP_USER/$ZBR_SMTP_PASSWORD" | tee -a $notice
        echo | tee -a $notice
      fi
    fi

    if [[ $ZBR_JENKINS_ENABLED -eq 1 ]]; then
      echo "JENKINS URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/jenkins" | tee -a $notice
      echo "JENKINS USER: admin/changeit" | tee -a $notice
      echo | tee -a $notice
    fi

    if [[ $ZBR_SONARQUBE_ENABLED -eq 1 ]]; then
      echo "SONARQUBE URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/sonarqube" | tee -a $notice
      echo "SONARQUBE USER: admin/admin" | tee -a $notice
      echo | tee -a $notice
    fi

    if [[ $ZBR_SELENOID_ENABLED -eq 1 ]]; then
      echo "SELENIUM HUB URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/selenoid/wd/hub" | tee -a $notice
      echo | tee -a $notice
    fi

    if [[ $ZBR_MCLOUD_ENABLED -eq 1 ]]; then
      echo "STF URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/stf" | tee -a $notice
      echo "APPIUM HUB URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT/mcloud/wd/hub" | tee -a $notice
      echo | tee -a $notice
    fi

    # append copyright and licensing info
    echo >> $notice
    echo "Copyright 2018-2021 ZEBRUNNER" >> $notice
    echo >> $notice

    echo "Licensed under the Apache License, Version 2.0 (the \"License\");" >> $notice
    echo "you may not use this file except in compliance with the License." >> $notice
    echo "You may obtain a copy of the License at" >> $notice
    echo >> $notice

    echo "http://www.apache.org/licenses/LICENSE-2.0" >> $notice
    echo >> $notice

    echo "Unless required by applicable law or agreed to in writing, software" >> $notice
    echo "distributed under the License is distributed on an \"AS IS\" BASIS," >> $notice
    echo "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied." >> $notice
    echo "See the License for the specific language governing permissions and" >> $notice
    echo "limitations under the License." >> $notice

    if [[ "$ZBR_PROTOCOL" == "https" ]]; then
      echo_warning "Replace self-signed ssl.crt and ssl.key in ./nginx/ssl onto valid ones!"
    fi

    echo_warning "Your services needs to be started after setup."
    confirm "" "      Start now?" "y"
    export start_services=$?
    echo
    echo

    if [[ $ZBR_SELENOID_ENABLED -eq 1 ]]; then
       selenoid/zebrunner.sh setup
    fi

    if [[ $start_services -eq 1 ]]; then
      start
    fi

  }

  shutdown() {
    if [ ! -f backup/settings.env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    echo_warning "Shutdown will erase all settings and data for \"${BASEDIR}\"!"
    confirm "" "      Do you want to continue?" "n"
    if [[ $? -eq 0 ]]; then
      exit
    fi

    print_banner

    jenkins/zebrunner.sh shutdown
    reporting/zebrunner.sh shutdown
    sonarqube/zebrunner.sh shutdown
    mcloud/zebrunner.sh shutdown
    selenoid/zebrunner.sh shutdown
    docker-compose down -v

    rm -f NOTICE.txt
    rm -f .env
    rm -f nginx/conf.d/default.conf
    rm -f backup/settings.env

    rm -f reporting/database/reporting/sql/db-jenkins-integration.sql
    rm -f reporting/database/reporting/sql/db-mcloud-integration.sql
    rm -f reporting/database/reporting/sql/db-selenium-integration.sql

  }

  start() {
    if [ ! -f .env ]; then
      # need proceed with setup steps in advance!
      setup
      exit -1
    fi

    source backup/settings.env
    if [[ -z ${ZBR_VERSION} ]]; then
      ZBR_VERSION=1.0
    fi
    ACTUAL_VERSION=${ZBR_VERSION}

    source .env
    DESIRED_VERSION=${ZBR_VERSION}

    if [[ "${ACTUAL_VERSION}" < "${DESIRED_VERSION}" ]]; then
      echo_warning "You have to upgrade services in advance using: ./zebrunner.sh upgrade"
      echo_telegram
      exit -1
    fi

    print_banner

    # create infra network only if not exist
    docker network inspect infra >/dev/null 2>&1 || docker network create infra

    #-------------- START EVERYTHING ------------------------------
    selenoid/zebrunner.sh start
    mcloud/zebrunner.sh start
    jenkins/zebrunner.sh start
    reporting/zebrunner.sh start
    sonarqube/zebrunner.sh start

    docker-compose up -d
  }

  stop() {
    if [ ! -f .env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    jenkins/zebrunner.sh stop
    reporting/zebrunner.sh stop
    sonarqube/zebrunner.sh stop
    mcloud/zebrunner.sh stop
    selenoid/zebrunner.sh stop
    docker-compose stop
  }

  restart() {
    if [ ! -f .env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    down
    start
  }

  down() {
    if [ ! -f .env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    jenkins/zebrunner.sh down
    reporting/zebrunner.sh down
    sonarqube/zebrunner.sh down
    mcloud/zebrunner.sh down
    selenoid/zebrunner.sh down
    docker-compose down
  }

  backup() {
    if [ ! -f .env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    confirm "" "      Your services will be stopped. Do you want to do a backup now?" "n"
    if [[ $? -eq 0 ]]; then
      exit
    fi

    print_banner

    stop

    cp .env .env.bak
    cp ./nginx/conf.d/default.conf ./nginx/conf.d/default.conf.bak
    cp backup/settings.env backup/settings.env.bak
    if [[ -f reporting/database/reporting/sql/db-jenkins-integration.sql ]]; then
      cp reporting/database/reporting/sql/db-jenkins-integration.sql reporting/database/reporting/sql/db-jenkins-integration.sql.bak
    fi
    if [[ -f reporting/database/reporting/sql/db-mcloud-integration.sql ]]; then
      cp reporting/database/reporting/sql/db-mcloud-integration.sql reporting/database/reporting/sql/db-mcloud-integration.sql.bak
    fi
    if [[ -f reporting/database/reporting/sql/db-selenium-integration.sql ]]; then
      cp reporting/database/reporting/sql/db-selenium-integration.sql reporting/database/reporting/sql/db-selenium-integration.sql.bak
    fi


    jenkins/zebrunner.sh backup
    reporting/zebrunner.sh backup
    sonarqube/zebrunner.sh backup
    mcloud/zebrunner.sh backup
    selenoid/zebrunner.sh backup

    echo_warning "Your services needs to be started after backup."
    confirm "" "      Start now?" "y"
    if [[ $? -eq 1 ]]; then
      start
    fi

  }

  restore() {
    if [ ! -f .env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    confirm "" "      Your services will be stopped and current data might be lost. Do you want to do a restore now?" "n"
    if [[ $? -eq 0 ]]; then
      exit
    fi

    print_banner

    stop
    cp .env.bak .env
    cp ./nginx/conf.d/default.conf.bak ./nginx/conf.d/default.conf
    cp backup/settings.env.bak backup/settings.env
    if [[ -f reporting/database/reporting/sql/db-jenkins-integration.sql.bak ]]; then
      cp reporting/database/reporting/sql/db-jenkins-integration.sql.bak reporting/database/reporting/sql/db-jenkins-integration.sql
    fi
    if [[ -f reporting/database/reporting/sql/db-mcloud-integration.sql.bak ]]; then
      cp reporting/database/reporting/sql/db-mcloud-integration.sql.bak reporting/database/reporting/sql/db-mcloud-integration.sql
    fi
    if [[ -f reporting/database/reporting/sql/db-selenium-integration.sql.bak ]]; then
      cp reporting/database/reporting/sql/db-selenium-integration.sql.bak reporting/database/reporting/sql/db-selenium-integration.sql
    fi

    jenkins/zebrunner.sh restore
    reporting/zebrunner.sh restore
    sonarqube/zebrunner.sh restore
    mcloud/zebrunner.sh restore
    selenoid/zebrunner.sh restore
    down

    echo_warning "Your services needs to be started after restore."
    confirm "" "      Start now?" "y"
    if [[ $? -eq 1 ]]; then
      start
    fi

  }

  upgrade() {
    if [ ! -f backup/settings.env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    confirm "" "      Do you want to do an upgrade?" "n"
    if [[ $? -eq 0 ]]; then
      exit
    fi

    patch/1.1.sh
    p1_1=$?
    if [[ ${p1_1} -eq 1 ]]; then
      echo "ERROR! 1.1 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.2.sh
    p1_2=$?
    if [[ ${p1_2} -eq 1 ]]; then
      echo "ERROR! 1.2 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.3.sh
    p1_3=$?
    if [[ ${p1_3} -eq 1 ]]; then
      echo "ERROR! 1.3 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.4.sh
    p1_4=$?
    if [[ ${p1_4} -eq 1 ]]; then
      echo "ERROR! 1.4 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.5.sh
    p1_5=$?
    if [[ ${p1_5} -eq 1 ]]; then
      echo "ERROR! 1.5 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.6.sh
    p1_6=$?
    if [[ ${p1_6} -eq 1 ]]; then
      echo "ERROR! 1.6 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.7.sh
    p1_7=$?
    if [[ ${p1_7} -eq 1 ]]; then
      echo "ERROR! 1.7 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.8.sh
    p1_8=$?
    if [[ ${p1_8} -eq 1 ]]; then
      echo "ERROR! 1.8 patchset was not applied correctly!"
      exit -1
    fi

    patch/1.9.sh
    p1_9=$?
    if [[ ${p1_9} -eq 1 ]]; then
      echo "ERROR! 1.9 patchset was not applied correctly!"
      exit -1
    fi

    # IMPORTANT! Increment latest verification to new version, i.e. p1_3, p1_4 etc to verify latest upgrade status
    if [[ ${p1_9} -eq 2 ]]; then
      echo "No need to restart service as nothing was upgraded."
      exit -1
    fi

    echo_warning "Your services needs to restart to finish important updates."
    confirm "" "      Restart now?" "y"
    if [[ $? -eq 1 ]]; then
      down
      start
    fi

  }

  version() {
    if [ ! -f .env ]; then
      echo_warning "You have to setup services in advance using: ./zebrunner.sh setup"
      echo_telegram
      exit -1
    fi

    source backup/settings.env

    echo "
      zebrunner: ${ZBR_VERSION}
      $(jenkins/zebrunner.sh version)
      $(mcloud/zebrunner.sh version)
      $(reporting/zebrunner.sh version)
      $(selenoid/zebrunner.sh version)
      $(sonarqube/zebrunner.sh version)"
  }

  enableLayer() {
    local layer=$1
    local message=$2
    local isEnabled=$3

    echo
    confirm "$message" "Enable?" "$isEnabled"
    if [[ $? -eq 1 ]]; then
      # enable component/layer
      if [[ -f $layer/.disabled ]]; then
        rm "$layer"/.disabled
      fi
      return 1
    else
      disableLayer "$layer"
      return 0
    fi
  }

  disableLayer() {
    # disbale component/layer
    echo > "$1"/.disabled
    return 0
  }

  set_global_settings() {
    # Setup global settings: protocol, hostname and port
    echo "Zebrunner General Settings"
    local is_confirmed=0
    if [[ -z $ZBR_HOSTNAME ]]; then
      ZBR_HOSTNAME=`curl -s ifconfig.me`
    fi

    while [[ $is_confirmed -eq 0 ]]; do
      read -r -p "Protocol [$ZBR_PROTOCOL]: " local_protocol
      if [[ ! -z $local_protocol ]]; then
        ZBR_PROTOCOL=$local_protocol
      fi

      read -r -p "Fully qualified domain name (ip) [$ZBR_HOSTNAME]: " local_hostname
      if [[ ! -z $local_hostname ]]; then
        ZBR_HOSTNAME=$local_hostname
      fi

      read -r -p "Port [$ZBR_PORT]: " local_port
      if [[ ! -z $local_port ]]; then
        ZBR_PORT=$local_port
      fi

      confirm "Zebrunner URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT" "Continue?" "y"
      is_confirmed=$?
    done

    export ZBR_PROTOCOL=$ZBR_PROTOCOL
    export ZBR_HOSTNAME=$ZBR_HOSTNAME
    export ZBR_PORT=$ZBR_PORT

  }

  echo_help() {
    echo "
      Usage: ./zebrunner.sh [option]
      Flags:
          --help | -h    Print help
      Arguments:
          setup          Setup Zebrunner Community Edition
      	  start          Start container
      	  stop           Stop and keep container
      	  restart        Restart container
      	  down           Stop and remove container
      	  shutdown       Stop and remove container, clear volumes
      	  backup         Backup container
      	  restore        Restore container
          upgrade        Upgrade to the latest version of Zebrunner Community Edition
      	  version        Version of components"
      echo_telegram
      exit 0
  }

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${BASEDIR}" || exit

case "$1" in
    setup)
        setup
        ;;
    start)
	start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    down)
        down
        ;;
    shutdown)
        shutdown
        ;;
    backup)
        backup
        ;;
    restore)
        restore
        ;;
    upgrade)
        upgrade
        ;;
    version)
        version
        ;;
    *)
        echo_help
        exit 1
        ;;
esac

