# Installation Guide

## Setup services

* Clone [Zebrunner CE](https://github.com/zebrunner/community-edition) recursive and launch setup procedure
```
git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git
cd zebrunner
./zebrunner.sh setup
```

* Provide valid protocol, host address or fully qualified domain name and port:
```
Zebrunner General Settings
Protocol [http]:
Fully qualified domain name (ip) [3.236.66.54]:
Port [80]:
Zebrunner URL: http://3.236.66.54:80
Continue? y/n [y]:y
```
> Press `Enter` to keep default values displayed in square brackets. 

* Choose S3 compatible storage service for video, screenshots and logs artifacts. By default embedded Minio storage is configured:
```
Use AWS S3 bucket for storing test artifacts (logs, video, screenshots etc)? Embedded Minio Storage can be configured if you don't have Amazon account.
Use? y/n [n]:n
```
> To use AWS S3 storage generate bucket according to the [steps](https://zebrunner.github.io/community-edition/integration/aws-s3/) and provide it's settings.

* Provide SMTP integration to be able to be able to send emailable reports:
```
Use SMTP for emailing test results?
Use? y/n [n]:y
Host [smtp.gmail.com]:
Port [587]:
Sender email []: myemail@gmail.com
User []: myemail
Password []: mypassword

SMTP Integration
host=smtp.gmail.com:587
email=myemail@gmail.com
user=myemail
password=mypassword
Continue? y/n [y]:y
```

* Keep [SonarQube](https://github.com/zebrunner/sonarqube) to organize continuous inspection of code quality to perform automatic reviews with static analysis of code to detect bugs, code smells, and security vulnerabilities etc:
```
Use embedded SonarQube to organize static code analysis and guiding your team?
Enable? y/n [y]:y
```

* Keep [Jenkins](https://github.com/zebrunner/jenkins-master) to establish automation testing CI/CD in accordance with Infrastructure as Code processes:
```
Use embedded Jenkins as recommended CI tool?
Enable? y/n [y]:y
```

* Keep light-weight [Selenium Hub]((https://github.com/zebrunner/selenoid)) to be able to execute test automation on browsers:
```
Use embedded Web Selenium Hub for testing on chrome, firefox, opera and MicrosoftEdge browsers?
Enable? y/n [y]:y
```

* Keep [MCloud](https://github.com/zebrunner/mcloud) to be able to register your physical mobile devices and emulators and execute mative and mobile web testing. 
```
Use embedded Mobile Device Farm and Selenium/Appium Hub for testing on Android, iOS, AppleTV etc devices?
Enable? y/n [y]:y
```

* Review pre-generated credentials and components links. Later you can find them in `NOTICE.txt` file
```
Copy and save auto-generated crendentials. Detailes can be found also in NOTICE.txt

ZEBRUNNER URL: http://3.236.66.54:80

REPORTING SERVICE CREDENTIALS:
USER: admin/changeit
IAM POSTGRES: postgres/7GyFmdnsHQJEePeDQa1kYpknrgu7tUtVMGQ00p9ARP5qDBck
REPORTING POSTGRES: postgres/m1lkBtdEKXqLzX48HA9gmvRrvlJbcWqM4jsayl0xTBheobij
RABBITMQ: admin/CZrbcTBh0ACHoDYuiMmbNz9jmJ2o2OESKOjmCI9R50NxDOT2
REDIS: rfdQgjU6JR4BlpflBxPSuECcyL8grjT38XmF8utyfl5RPzOn

REPORTING SMTP INTEGRATIONS:
SMTP HOST: smtp.gmail.com:587
EMAIL: myemail@gmail.com
USER: myemail/mypassword

JENKINS URL: http://3.236.66.54:80/jenkins
JENKINS USER: admin/changeit

SONARQUBE URL: http://3.236.66.54:80/sonarqube
SONARQUBE USER: admin/admin

SELENIUM HUB URL: http://3.236.66.54:80/selenoid/wd/hub

STF URL: http://3.236.66.54:80/stf
APPIUM HUB URL: http://3.236.66.54:80/mcloud/wd/hub
```

* Start Services:
```
      WARNING! Your services needs to be started after setup.
      Start now? y/n [y]:y
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
> To reconfigure services, disable/enable components, setup distributed environments re-execute again setup procedure and provide updated inputs
  
## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
