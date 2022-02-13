# Installation Guide

## Clone and setup
Clone [Zebrunner CE](https://github.com/zebrunner/community-edition) recursive and launch setup procedure
```
git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git
cd zebrunner
./zebrunner.sh setup
```
> Provide required details to finish configuration and start services. To use AWS S3 storage generate bucket according to the [steps](https://zebrunner.github.io/community-edition/integration/aws-s3/)

## Start services
```
./zebrunner.sh start
``` 

## Manage services
Use `./zebrunner.sh` script to start/stop/restart etc Zebrunner Community Edition services
```
./zebrunner.sh

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
> To reconfigure services, disable/enable components re-execute again setup procedure and provide updated inputs
  
## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
