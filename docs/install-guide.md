# Installation Guide

## Clone and setup
Clone [Zebrunner](https://github.com/zebrunner/zebrunner) recursive and launch setup procedure
```
git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git
cd zebrunner
./zebrunner.sh setup
```
> Provide required details to finish configuration and start services

## Start services
Use `./zebrunner.sh` script to start/stop/restart etc Zebrunner Community Edition services
```
ubuntu@ip-172-31-22-237:~/tools/community-edition$ ./zebrunner.sh

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
          version        Version of components

      For more help join telegram channel: https://t.me/zebrunner
```
  
## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
