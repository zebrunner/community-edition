#!/bin/bash

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
    docker network inspect infra >/dev/null 2>&1 || docker network create infra
    print_banner

    set_global_settings

    if [[ ! -f ${BASEDIR}/nginx/conf.d/default.conf.original ]]; then
      #make a backup of the original file
      cp ${BASEDIR}/nginx/conf.d/default.conf ${BASEDIR}/nginx/conf.d/default.conf.original
    fi

    sed -i 's/server_name localhost/server_name '$ZBR_HOSTNAME'/g' ./nginx/conf.d/default.conf
    sed -i 's/listen 80/listen '$ZBR_PORT'/g' ./nginx/conf.d/default.conf


    enableLayer "reporting" "Enable Zebrunner Reporting?"
    if [[ $? -eq 1 ]]; then
      ${BASEDIR}/reporting/zebrunner.sh setup
    fi

    enableLayer "sonarqube" "Enable SonarQube?"
    if [[ $? -eq 1 ]]; then
      ${BASEDIR}/sonarqube/zebrunner.sh setup
    fi

    enableLayer "jenkins" "Enable Zebrunner CI (Jenkins)?"
    if [[ $? -eq 1 ]]; then
      echo "TODO: implement zebrunner.sh for component..."
#        ${BASEDIR}/jenkins/zebrunner.sh setup
    fi

    enableLayer "selenoid" "Enable Zebrunner Engine (Selenium Hub for Web - chrome, firefox and opera)?"
    if [[ $? -eq 1 ]]; then
      echo "TODO: implement zebrunner.sh for component..."
#        ${BASEDIR}/selenoid/zebrunner.sh setup
    fi

    enableLayer "mcloud" "Enable Zebrunner Engine (Selenium Hub for Mobile - Android, iOS, AppleTV etc)?"
    if [[ $? -eq 1 ]]; then
      echo "TODO: implement zebrunner.sh for component..."
#        ${BASEDIR}/mcloud/zebrunner.sh setup
    fi


#        echo WARNING! Increase vm.max_map_count=262144 appending it to /etc/sysctl.conf on Linux Ubuntu
#        echo your current value is `sysctl vm.max_map_count`

#        echo Setup finished successfully using $HOST_NAME hostname.
  }

  start() {
    if [ ! -f ./nginx/conf.d/default.conf ]; then
      printf 'WARNING! You have to setup services in advance! For example:\n ./zebrunner.sh setup\n\n' "$(basename "$0")" >&2
      exit -1
    fi


    # create infra network only if not exist
    docker network inspect infra >/dev/null 2>&1 || docker network create infra

    #-------------- START EVERYTHING ------------------------------
#    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml up -d
#    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml up -d
#    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml up -d

    ${BASEDIR}/reporting/zebrunner.sh start
    ${BASEDIR}/sonarqube/zebrunner.sh start

    docker-compose up -d
  }

  stop() {
#    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml stop
    ${BASEDIR}/reporting/zebrunner.sh stop
    ${BASEDIR}/sonarqube/zebrunner.sh stop
#    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml stop
#    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml stop
    docker-compose stop
  }

  down() {
#    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml down
    ${BASEDIR}/reporting/zebrunner.sh down
    ${BASEDIR}/sonarqube/zebrunner.sh down
#    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml down
#    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml down
    docker-compose down
  }

  shutdown() {
    if [[ -f ${BASEDIR}/nginx/conf.d/default.conf.original ]]; then
      mv ${BASEDIR}/nginx/conf.d/default.conf.original ${BASEDIR}/nginx/conf.d/default.conf
    fi


 #   docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml down -v
    ${BASEDIR}/reporting/zebrunner.sh shutdown
    ${BASEDIR}/sonarqube/zebrunner.sh shutdown
#    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml down -v
#    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml down -v
    docker-compose down -v

#    rm -rf ./selenoid/video/*.mp4
#    mv selenoid/browsers.json selenoid/browsers.json.bak

  }

  enableLayer() {
    confirm "$2"
    if [[ $? -eq 1 ]]; then
      # enable component/layer
      if [[ -f $1/.disabled ]]; then
        rm $1/.disabled
      fi
      return 1
    else
      # disbale component/layer
      echo > $1/.disabled
      return 0
    fi
  }

  set_global_settings() {

    # Setup global settings: protocol, hostname and port
    local is_confirmed=0
    ZBR_PROTOCOL=http
    ZBR_HOSTNAME=$HOSTNAME
    ZBR_PORT=80

    while [[ $is_confirmed -eq 0 ]]; do
      read -p "PROTOCOL [$ZBR_PROTOCOL]: " local_protocol
      if [[ ! -z $local_protocol ]]; then
        ZBR_PROTOCOL=$local_protocol
      fi

      read -p "HOSTNAME [$ZBR_HOSTNAME]: " local_hostname
      if [[ ! -z $local_hostname ]]; then
        ZBR_HOSTNAME=$local_hostname
      fi

      read -p "PORT [$ZBR_PORT]: " local_port
      if [[ ! -z $local_port ]]; then
        ZBR_PORT=$local_port
      fi

      confirm "URL: $ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT" "Continue?"
      is_confirmed=$?
    done

    export ZBR_PROTOCOL=$ZBR_PROTOCOL
    export ZBR_HOSTNAME=$ZBR_HOSTNAME
    export ZBR_PORT=$ZBR_PORT

  }

  confirm() {
    while true; do
      echo "$1"
      read -p "$2 [y/n]" yn
      case $yn in
      [y]*)
        return 1
        ;;
      [n]*)
        return 0
        ;;
      *)
        echo
        echo "Please answer y (yes) or n (no)."
        echo
        ;;
      esac
    done
  }


BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd ${BASEDIR}

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
        down
        start
        ;;
    down)
        down
        ;;
    shutdown)
        shutdown
        ;;
    backup)
        cp ./nginx/conf.d/default.conf ./nginx/conf.d/default.conf.bak

        ${BASEDIR}/reporting/zebrunner.sh backup
        ${BASEDIR}/sonarqube/zebrunner.sh backup
        ;;
    restore)
        ${BASEDIR}/reporting/zebrunner.sh restore
        ${BASEDIR}/sonarqube/zebrunner.sh restore
        ;;
    *)
        echo "Usage: ./zebrunner-server setup|start|stop|restart|down|shutdown|backup|restore"
        exit 1
        ;;
esac

