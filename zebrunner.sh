#!/bin/bash

  print_banner() {
  echo "
███████╗███████╗██████╗ ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗
╚══███╔╝██╔════╝██╔══██╗██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗
  ███╔╝ █████╗  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
 ███╔╝  ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
███████╗███████╗██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║
╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
"
  }

  start() {
    if [ ! -f .env ] || [ ! -f ./nginx/conf.d/default.conf ]; then
      printf 'WARNING! You have to setup services in advance! For example:\n ./zebrunner.sh setup\n\n' "$(basename "$0")" >&2
      exit -1
    fi


    # create infra network only if not exist
    docker network inspect infra >/dev/null 2>&1 || docker network create infra

    #-------------- START EVERYTHING ------------------------------
    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml up -d
    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml up -d
    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml up -d

    ${BASEDIR}/reporting/zebrunner.sh start
    ${BASEDIR}/sonarqube/zebrunner.sh start

    docker-compose up -d
  }

  stop() {
    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml stop
    ${BASEDIR}/reporting/zebrunner.sh stop
    ${BASEDIR}/sonarqube/zebrunner.sh stop
    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml stop
    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml stop
    docker-compose stop
  }

  down() {
    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml down
    ${BASEDIR}/reporting/zebrunner.sh down
    ${BASEDIR}/sonarqube/zebrunner.sh down
    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml down
    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml down
    docker-compose down
  }

  shutdown() {
    docker-compose --env-file ${BASEDIR}/.env -f jenkins/docker-compose.yml down -v
    ${BASEDIR}/reporting/zebrunner.sh down -v
    ${BASEDIR}/sonarqube/zebrunner.sh shutdown
    docker-compose --env-file ${BASEDIR}/.env -f mcloud/docker-compose.yml down -v
    docker-compose --env-file ${BASEDIR}/.env -f selenoid/docker-compose.yml down -v
    docker-compose down -v

    rm -rf ./selenoid/video/*.mp4
    mv selenoid/browsers.json selenoid/browsers.json.bak
    mv ./nginx/conf.d/default.conf ./nginx/conf.d/default.conf.bak
    mv .env .env.bak
  }

  set_sonar() {
    confirm "Enable SonarQube?"
    if [[ $? -eq 1 ]]; then
      # enable sonar
      if [[ -f sonarqube/.disabled ]]; then
        rm sonarqube/.disabled
      fi
    else
      # disbale sonar
      echo > sonarqube/.disabled
    fi
  }

  set_host() {
    echo "Specify fully qualified domain name or ip address"
    HOST_NAME=""
    local IS_CONFIRMED=0
    while [[ -z $HOST_NAME || $HOST_NAME == "localhost" || $HOST_NAME == "127.0.0.1" || $IS_CONFIRMED -eq 0 ]]; do
      read -p "HOST_NAME: " HOST_NAME
      if [[ -z $HOST_NAME || $HOST_NAME == "localhost" || $HOST_NAME == "127.0.0.1" ]]; then
        echo "Unable to proceed with HOST_NAME=\"${HOST_NAME}\"!"
      else
        confirm "Continue?"
        IS_CONFIRMED=$?
      fi
    done


    echo "HOST_NAME=$HOST_NAME"
    echo generating .env...
    sed 's/demo.qaprosoft.com/'$HOST_NAME'/g' .env.original > .env
    echo generating ./nginx/conf.d/default.conf...
    sed 's/demo.qaprosoft.com/'$HOST_NAME'/g' ./nginx/conf.d/default.conf.original > ./nginx/conf.d/default.conf

  }

  confirm() {
    while true; do
      read -p "$1 [y/n]" yn
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
        docker network inspect infra >/dev/null 2>&1 || docker network create infra
        print_banner

        set_host

        ${BASEDIR}/reporting/zebrunner.sh setup

	set_sonar
	${BASEDIR}/sonarqube/zebrunner.sh setup
	echo

#        echo WARNING! Increase vm.max_map_count=262144 appending it to /etc/sysctl.conf on Linux Ubuntu
#        echo your current value is `sysctl vm.max_map_count`

#        echo Setup finished successfully using $HOST_NAME hostname.
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

