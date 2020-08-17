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

    # load default interactive installer settings
    source backup/settings.env.original

    # load ./backup/settings.env if exist to declare ZBR* vars from previous run!
    if [[ -f backup/settings.env ]]; then
      source backup/settings.env
    fi
    set_global_settings

    cp nginx/conf.d/default.conf.original nginx/conf.d/default.conf

    sed -i 's/server_name localhost/server_name '$ZBR_HOSTNAME'/g' ./nginx/conf.d/default.conf
    sed -i 's/listen 80/listen '$ZBR_PORT'/g' ./nginx/conf.d/default.conf

    enableLayer "reporting" "Enable Zebrunner Reporting?"
    ZBR_REPORTING_ENABLED=$?
    if [[ $ZBR_REPORTING_ENABLED -eq 1 ]]; then
      enableLayer "reporting/minio-storage" "Enable Zebrunner Minio Storage for Reporting?"
      ZBR_MINIO_ENABLED=$?
      set_reporting_settings

      set_storage_settings
    else
      # no need to ask about enabling minio sub-module
      disableLayer "reporting/minio-storage"
    fi

    enableLayer "sonarqube" "Enable SonarQube?"
    ZBR_SONARQUBE_ENABLED=$?

    enableLayer "jenkins" "Enable Zebrunner CI (Jenkins)?"
    ZBR_JENKINS_ENABLED=$?

    enableLayer "mcloud" "Enable Zebrunner Mobile Hub (selenium: Android, iOS, AppleTV...)?"
    ZBR_MCLOUD_ENABLED=$?

    enableLayer "selenoid" "Enable Zebrunner Web Hub (selenoid: chrome, firefox and opera)?"
    ZBR_SELENOID_ENABLED=$?

    if [[ $ZBR_REPORTING_ENABLED -eq 1 ]]; then
      reporting/zebrunner.sh setup
    fi

    if [[ $ZBR_SONARQUBE_ENABLED -eq 1 ]]; then
      sonarqube/zebrunner.sh setup
    fi

    if [[ $ZBR_JENKINS_ENABLED -eq 1 ]]; then
        jenkins/zebrunner.sh setup
    fi

    if [[ $ZBR_MCLOUD_ENABLED -eq 1 ]]; then
        mcloud/zebrunner.sh setup
    fi

    if [[ $ZBR_SELENOID_ENABLED -eq 1 ]]; then
        selenoid/zebrunner.sh setup
    fi

    #TODO: export all ZBR_* variables into the .installer file!
    export_settings
  }

  shutdown() {
    print_banner

    rm nginx/conf.d/default.conf
    rm backup/settings.env

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
    cp backup/settings.env backup/settings.env.bak

    jenkins/zebrunner.sh backup
    reporting/zebrunner.sh backup
    sonarqube/zebrunner.sh backup
    mcloud/zebrunner.sh backup
  }

  restore() {
    print_banner

    cp ./nginx/conf.d/default.conf.bak ./nginx/conf.d/default.conf
    cp backup/settings.env.bak backup/settings.env

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
      disableLayer $1
      return 0
    fi
  }

  disableLayer() {
    # disbale component/layer
    echo > $1/.disabled
    return 0
  }

  set_global_settings() {
    # Setup global settings: protocol, hostname and port
    local is_confirmed=0
    if [[ -z $ZBR_HOSTNAME ]]; then
      ZBR_HOSTNAME=$HOSTNAME
    fi

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

      echo 
      echo "URL:"
      confirm "$ZBR_PROTOCOL://$ZBR_HOSTNAME:$ZBR_PORT" "Continue?"
      is_confirmed=$?
    done

    export ZBR_PROTOCOL=$ZBR_PROTOCOL
    export ZBR_HOSTNAME=$ZBR_HOSTNAME
    export ZBR_PORT=$ZBR_PORT

  }

  set_reporting_settings() {
    # Collect reporting settings
    ## Crypto token and salt
    local is_confirmed=0
    while [[ $is_confirmed -eq 0 ]]; do
      read -p "SIGNIN TOKEN SECRET (randomized base64 encoded string) [$ZBR_TOKEN_SIGNING_SECRET]: " local_token
      if [[ ! -z $local_token ]]; then
        ZBR_TOKEN_SIGNING_SECRET=$local_token
      fi

      read -p "CRYPTO SALT [$ZBR_CRYPTO_SALT]: " local_salt
      if [[ ! -z $local_salt ]]; then
        ZBR_CRYPTO_SALT=$local_salt
      fi

      echo
      echo "REPORTING CRYPTO:"
      echo "SIGNIN TOKEN SECRET=$ZBR_TOKEN_SIGNING_SECRET"
      echo "CRYPTO SALT=$ZBR_CRYPTO_SALT"
      confirm "Reporting Crypto Settings" "Continue?"
      is_confirmed=$?
    done

    export ZBR_TOKEN_SIGNING_SECRET=$ZBR_TOKEN_SIGNING_SECRET
    export ZBR_CRYPTO_SALT=$ZBR_CRYPTO_SALT


    ## iam-service posgtres
    local is_confirmed=0
    while [[ $is_confirmed -eq 0 ]]; do
      read -p "IAM POSTGRES USER [$ZBR_IAM_POSTGRES_USER]: " local_iam_postgres_user
      if [[ ! -z $local_iam_postgres_user ]]; then
        ZBR_IAM_POSTGRES_USER=$local_iam_postgres_user
      fi

      read -p "IAM POSTGRES PASSWORD [$ZBR_IAM_POSTGRES_PASSWORD]: " local_iam_postgres_password
      if [[ ! -z $local_iam_postgres_password ]]; then
        ZBR_IAM_POSTGRES_PASSWORD=$local_iam_postgres_password
      fi

      echo
      echo "REPORTING IAM POSTGRES:"
      echo "USER=$ZBR_IAM_POSTGRES_USER"
      echo "PASSWORD=$ZBR_IAM_POSTGRES_PASSWORD"
      confirm "Reporting IAM Postgres Credentials" "Continue?"
      is_confirmed=$?
    done

    export ZBR_IAM_POSTGRES_USER=$ZBR_IAM_POSTGRES_USER
    export ZBR_IAM_POSTGRES_PASSWORD=$ZBR_IAM_POSTGRES_PASSWORD


    ## reporting posgtres instance
    local is_confirmed=0
    while [[ $is_confirmed -eq 0 ]]; do
      read -p "POSTGRES USER [$ZBR_POSTGRES_USER]: " local_postgres_user
      if [[ ! -z $local_postgres_user ]]; then
        ZBR_POSTGRES_USER=$local_postgres_user
      fi

      read -p "POSTGRES PASSWORD [$ZBR_POSTGRES_PASSWORD]: " local_postgres_password
      if [[ ! -z $local_postgres_password ]]; then
        ZBR_POSTGRES_PASSWORD=$local_postgres_password
      fi

      echo
      echo "REPORTING POSTGRES:"
      echo "USER=$ZBR_POSTGRES_USER"
      echo "PASSWORD=$ZBR_POSTGRES_PASSWORD"
      confirm "Reporting Postgres Credentials" "Continue?"
      is_confirmed=$?
    done

    export ZBR_POSTGRES_USER=$ZBR_POSTGRES_USER
    export ZBR_POSTGRES_PASSWORD=$ZBR_POSTGRES_PASSWORD


    ## email-service (smtp)
    local is_confirmed=0
    while [[ $is_confirmed -eq 0 ]]; do
      read -p "SMTP HOST [$ZBR_SMTP_HOST]: " local_smtp_host
      if [[ ! -z $local_smtp_host ]]; then
        ZBR_SMTP_HOST=$local_smtp_host
      fi

      read -p "SMTP PORT [$ZBR_SMTP_PORT]: " local_smtp_port
      if [[ ! -z $local_smtp_port ]]; then
        ZBR_SMTP_PORT=$local_smtp_port
      fi

      read -p "SMTP USER EMAIL[$ZBR_SMTP_EMAIL]: " local_smtp_email
      if [[ ! -z $local_smtp_email ]]; then
        ZBR_SMTP_EMAIL=$local_smtp_email
      fi

      read -p "SMTP USER [$ZBR_SMTP_USER]: " local_smtp_user
      if [[ ! -z $local_smtp_user ]]; then
        ZBR_SMTP_USER=$local_smtp_user
      fi

      read -p "SMTP PASSWORD [$ZBR_SMTP_PASSWORD]: " local_smtp_password
      if [[ ! -z $local_smtp_password ]]; then
        ZBR_SMTP_PASSWORD=$local_smtp_password
      fi

      echo
      echo "SMTP EMAIL SETTINGS:"
      echo "HOST:PORT=$ZBR_SMTP_HOST:$ZBR_SMTP_PORT"
      echo "SENDER EMAIL=$ZBR_SMTP_EMAIL"
      echo "USER/PASSWORD=$ZBR_SMTP_USER/$ZBR_SMTP_PASSWORD"
      confirm "Reporting Email (SMTP) Credentials" "Continue?"
      is_confirmed=$?
    done

    export ZBR_SMTP_HOST=$ZBR_SMTP_HOST
    export ZBR_SMTP_PORT=$ZBR_SMTP_PORT
    export ZBR_SMTP_EMAIL=$ZBR_SMTP_EMAIL
    export ZBR_SMTP_USER=$ZBR_SMTP_USER
    export ZBR_SMTP_PASSWORD=$ZBR_SMTP_PASSWORD


    ## reporting rabbitmq
    local is_confirmed=0
    while [[ $is_confirmed -eq 0 ]]; do
      read -p "RABBITMQ USER [$ZBR_RABBITMQ_USER]: " local_rabbitmq_user
      if [[ ! -z $local_rabbitmq_user ]]; then
        ZBR_RABBITMQ_USER=$local_rabbitmq_user
      fi

      read -p "RABBITMQ PASSWORD [$ZBR_RABBITMQ_PASSWORD]: " local_rabbitmq_password
      if [[ ! -z $local_rabbitmq_password ]]; then
        ZBR_RABBITMQ_PASSWORD=$local_rabbitmq_password
      fi

      echo
      echo "REPORTING RABBITMQ:"
      echo "USER/PASSWORD=$ZBR_RABBITMQ_USER/$ZBR_RABBITMQ_PASSWORD"
      confirm "Reporting Rabbitmq Credentials" "Continue?"
      is_confirmed=$?
    done

    export ZBR_RABBITMQ_USER=$ZBR_RABBITMQ_USER
    export ZBR_RABBITMQ_PASSWORD=$ZBR_RABBITMQ_PASSWORD

    ## reporting redis
    local is_confirmed=0
    while [[ $is_confirmed -eq 0 ]]; do
      read -p "REDIS PASSWORD [$ZBR_REDIS_PASSWORD]: " local_redis_password
      if [[ ! -z $local_redis_password ]]; then
        ZBR_REDIS_PASSWORD=$local_redis_password
      fi

      echo
      echo "REPORTING REDIS:"
      echo "PASSWORD=$ZBR_REDIS_PASSWORD"
      confirm "Reporting Redis Credentials" "Continue?"
      is_confirmed=$?
    done

    export ZBR_REDIS_PASSWORD=$ZBR_REDIS_PASSWORD
  }

  set_storage_settings() {
    ## Minio or AWS S3 storage 
    echo "TODO: implement storage minio creds setup"
  }

  export_settings() {
    export -p | grep "ZBR" > backup/settings.env
  }

  random_string() {
    cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9 | head -c 48; echo
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

