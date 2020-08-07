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
        ${BASEDIR}/jenkins/zebrunner.sh setup
    fi

    enableLayer "mcloud" "Enable Zebrunner Mobile Hub (selenium: Android, iOS, AppleTV...)?"
    if [[ $? -eq 1 ]]; then
        ${BASEDIR}/mcloud/zebrunner.sh setup
    fi

    enableLayer "selenoid" "Enable Zebrunner Web Hub (selenoid: chrome, firefox and opera)?"
    if [[ $? -eq 1 ]]; then
        ${BASEDIR}/selenoid/zebrunner.sh setup
    fi



#TODO: moved to reporting setup
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
    ${BASEDIR}/selenoid/zebrunner.sh start
    ${BASEDIR}/mcloud/zebrunner.sh start
    ${BASEDIR}/jenkins/zebrunner.sh start
    ${BASEDIR}/reporting/zebrunner.sh start
    ${BASEDIR}/sonarqube/zebrunner.sh start

    docker-compose up -d
  }

  stop() {
    ${BASEDIR}/jenkins/zebrunner.sh stop
    ${BASEDIR}/reporting/zebrunner.sh stop
    ${BASEDIR}/sonarqube/zebrunner.sh stop
    ${BASEDIR}/mcloud/zebrunner.sh stop
    ${BASEDIR}/selenoid/zebrunner.sh stop
    docker-compose stop
  }

  down() {
    ${BASEDIR}/jenkins/zebrunner.sh down
    ${BASEDIR}/reporting/zebrunner.sh down
    ${BASEDIR}/sonarqube/zebrunner.sh down
    ${BASEDIR}/mcloud/zebrunner.sh down
    ${BASEDIR}/selenoid/zebrunner.sh down
    docker-compose down
  }

  shutdown() {
    if [[ -f ${BASEDIR}/nginx/conf.d/default.conf.original ]]; then
      mv ${BASEDIR}/nginx/conf.d/default.conf.original ${BASEDIR}/nginx/conf.d/default.conf
    fi


    ${BASEDIR}/jenkins/zebrunner.sh shutdown
    ${BASEDIR}/reporting/zebrunner.sh shutdown
    ${BASEDIR}/sonarqube/zebrunner.sh shutdown
    ${BASEDIR}/mcloud/zebrunner.sh shutdown
    ${BASEDIR}/selenoid/zebrunner.sh shutdown
    docker-compose down -v

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

      read -p "FQDN HOSTNAME [$ZBR_HOSTNAME]: " local_hostname
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

  echo_help() {
    echo "
      Usage: ./zebrunner.sh [option]
      Flags:
          --help | -h    Print help
      Arguments:
          start          Start container
          stop           Stop and keep container
          restart        Restart container
          down           Stop and remove container
          shutdown       Stop and remove container, clear volumes
          backup         Backup container
          restore        Restore container
      For more help join telegram channel https://t.me/qps_infra"
      exit 0
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

        ${BASEDIR}/jenkins/zebrunner.sh backup
        ${BASEDIR}/reporting/zebrunner.sh backup
        ${BASEDIR}/sonarqube/zebrunner.sh backup
        ${BASEDIR}/mcloud/zebrunner.sh backup
        ;;
    restore)
        ${BASEDIR}/jenkins/zebrunner.sh restore
        ${BASEDIR}/reporting/zebrunner.sh restore
        ${BASEDIR}/sonarqube/zebrunner.sh restore
        ${BASEDIR}/mcloud/zebrunner.sh restore
        ;;
    *)
        echo "Invalid option detected: $1"
        echo_help
        exit 1
        ;;
esac

