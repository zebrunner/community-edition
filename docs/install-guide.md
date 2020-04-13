# Installation Guide
## Software prerequisites
* Docker requires a user with uid=1000 and gid=1000 for simple volumes sharing, etc.
  Note: to verify the current user uid/gid, execute
  ```
  id
  uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),102(netdev),999(docker
  ```
* Install docker ([Ubuntu 16.04](http://www.techrepublic.com/article/how-to-install-docker-on-ubuntu-16-04/), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [MacOS](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/)) and [docker-composer](https://docs.docker.com/compose/install/#install-compose)


## Initial setup
* Clone [qps-infra](https://github.com/qaprosoft/qps-infra). You can also create your private repo to migrate the infrastructure easily
* Go to the qps-infra folder and launch the setup.sh script providing your hostname or ip address as an argument
```
git clone https://github.com/qaprosoft/qps-infra.git
cd qps-infra
./setup.sh myhost.domain.com
```
* Optional: adjust docker-compose.yml file by removing unused services. By default, it contains such group of services:
  * NGiNX WebServer: nginx
  * Reporting Toolset: postgres, zafira/zafira-ui, rabbitmq, elasticsearch, redis, logstash
  * CI: jenkins-master, jenkins-slave-web, jenkins-slave-api
  * Web and mobile selenium hubs: selenium hub, ggr, selenoid
  * Local storage: ftp
  * Sonarqube: sonarqube
<br>Note: It has sense to disable whole group. Also make sure to update depends_on in docker-compose and ./nginx/conf/default.conf to disable/comment services.

## Security setup  (strongly recommended for publicly available environments)
* Regenerate AUTH_TOKEN_SECRET for production environment. (It should be base64 encoded value based on randomized string)
* Regenerate CRYPTO_SALT value (it should be randomized alpha-numeric string)
* Update default credentials in variables.env
  Note: If you change RABBITMQ_USER and RABBITMQ_PASS, please, update them in config/definitions.json and config/logstash.conf files as well  
  
## Start services
```
./start.sh
```

## Env details
* After QPS-Infra startup, the following components are available. Take a look at variables.env for default credentials:
* [Jenkins - http://demo.qaprosoft.com/jenkins](http://demo.qaprosoft.com/jenkins)
* [Selenium Grid - http://demo.qaprosoft.com/mcloud/grid/console](http://demo.qaprosoft.com/mcloud/grid/console)
* [Zafira Reporting Tool - http://demo.qaprosoft.com/app](http://demo.qaprosoft.com/app)
* [SonarQube - http://demo.qaprosoft.com/sonarqube](http://demo.qaprosoft.com/sonarqube)
  Note: Use your host domain address or IP.
  Note: admin/qaprosoft are hardcoded sonarqube credentials, and they can be updated inside the Sonar Administration panel
  

## Enjoy!

* Join [Telegram channel](https://t.me/qps_infra) in case of any question
