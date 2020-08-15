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
    print_banner

    set_global_settings

    cp nginx/conf.d/default.conf.original nginx/conf.d/default.conf

    sed -i 's/server_name localhost/server_name '$ZBR_HOSTNAME'/g' ./nginx/conf.d/default.conf
    sed -i 's/listen 80/listen '$ZBR_PORT'/g' ./nginx/conf.d/default.conf

    enableLayer "reporting" "Enable Zebrunner Reporting?"
    if [[ $? -eq 1 ]]; then
      reporting/zebrunner.sh setup
    fi

    enableLayer "sonarqube" "Enable SonarQube?"
    if [[ $? -eq 1 ]]; then
      sonarqube/zebrunner.sh setup
    fi

    enableLayer "jenkins" "Enable Zebrunner CI (Jenkins)?"
    if [[ $? -eq 1 ]]; then
        jenkins/zebrunner.sh setup
    fi

    enableLayer "mcloud" "Enable Zebrunner Mobile Hub (selenium: Android, iOS, AppleTV...)?"
    if [[ $? -eq 1 ]]; then
        mcloud/zebrunner.sh setup
    fi

    enableLayer "selenoid" "Enable Zebrunner Web Hub (selenoid: chrome, firefox and opera)?"
    if [[ $? -eq 1 ]]; then
        selenoid/zebrunner.sh setup
    fi

  }

  shutdown() {
    print_banner

    rm nginx/conf.d/default.conf

    jenkins/zebrunner.sh shutdown
    reporting/zebrunner.sh shutdown
    sonarqube/zebrunner.sh shutdown
    mcloud/zebrunner.sh shutdown
    selenoid/zebrunner.sh shutdown
    docker-compose down -v

  }

  start() {
    if [ ! -f ./nginx/conf.d/default.conf ]; then
      printf 'WARNING! You have to setup services in advance! For example:\n ./zebrunner.sh setup\n\n' "$(basename "$0")" >&2
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
    print_banner

    jenkins/zebrunner.sh stop
    reporting/zebrunner.sh stop
    sonarqube/zebrunner.sh stop
    mcloud/zebrunner.sh stop
    selenoid/zebrunner.sh stop
    docker-compose stop
  }

  down() {
    print_banner

    jenkins/zebrunner.sh down
    reporting/zebrunner.sh down
    sonarqube/zebrunner.sh down
    mcloud/zebrunner.sh down
    selenoid/zebrunner.sh down
    docker-compose down
  }

  backup() {
    print_banner

    cp ./nginx/conf.d/default.conf ./nginx/conf.d/default.conf.bak

    jenkins/zebrunner.sh backup
    reporting/zebrunner.sh backup
    sonarqube/zebrunner.sh backup
    mcloud/zebrunner.sh backup
  }

  restore() {
    print_banner

    cp ./nginx/conf.d/default.conf.bak ./nginx/conf.d/default.conf

    jenkins/zebrunner.sh restore
    reporting/zebrunner.sh restore
    sonarqube/zebrunner.sh restore
    mcloud/zebrunner.sh restore
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

  echo_warning() {
    echo "
      WARNING! $1"
  }

  echo_telegram() {
    echo "
      For more help join telegram channel: https://t.me/zebrunner
      "
  }

  echo_help() {
    echo "
      Usage: ./zebrunner.sh [option]
      Flags:
          --help | -h    Print help
      Arguments:
          setup          Setup Zebrunner Server (Community Edition)
      	  start          Start container
      	  stop           Stop and keep container
      	  restart        Restart container
      	  down           Stop and remove container
      	  shutdown       Stop and remove container, clear volumes
      	  backup         Backup container
      	  restore        Restore container"
      echo_telegram
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
        backup
        ;;
    restore)
        restore
        ;;
    *)
        echo "Invalid option detected: $1"
        echo_help
        exit 1
        ;;
esac

