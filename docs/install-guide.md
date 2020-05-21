# Installation Guide

## System requirements 

### Hardware requirements

|                         	| Requirements                                                     	|
|:-----------------------:	|------------------------------------------------------------------	|
| <b>Operating System</b> 	| Linux Ubuntu 16.04, 18.04<br> Linux CentOS 7+<br> Amazon Linux 2 	|
| <b>       CPU      </b> 	| 8+ Cores                                                         	|
| <b>      Memory    </b> 	| 32 Gb RAM                                                        	|
| <b>    Free space  </b> 	| SSD 128Gb+ of free space                                         	|

> All in one standalone deployment supports up to 5 parallel executors for web and api tests. The most optimal EC2 instance type is t3.2xlarge with enabled "T2/T3 Unlimited" feature

### Software requirements

* Docker requires a user with uid=1000 and gid=1000 for simple volumes sharing, etc

* Install docker ([Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [Amazon Linux 2](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html) or [MacOS](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/))
  > MacOS is <b>not recommended</b> for production usage!
  
* Install [docker-composer](https://docs.docker.com/compose/install/#install-compose)

## Initial setup

1. Clone [qps-infra](https://github.com/qaprosoft/qps-infra) and launch the setup.sh script providing your hostname as an argument:<br>
  ```
  > git clone https://github.com/qaprosoft/qps-infra.git
  > cd qps-infra
  > set GITHUB_CLIENT_ID and GITHUB_CLIENT_SECRET in .env.original
  > ./setup.sh myhost.domain.com
  ```
  > Use public ip address if you don't have registered DNS hostname yet
  
2. [Optional] adjust docker-compose.yml file removing/disabling unused services according to the [steps](#disableremove-components).
  
3. [Optional] Generate new AUTH_TOKEN_SECRET/CRYPTO_SALT values and put into the variables.env
  > Strongly recommended for publicly available environments! AUTH_TOKEN_SECRET is randomized and base64 encoded string. CRYPTO_SALT is randomized alpha-numeric string

4. [Optional] Update default credentials in variables.env
  > If you change RABBITMQ_USER and RABBITMQ_PASS, please, update them in config/definitions.json and config/logstash.conf files as well
 
5. Start services<br>
  ```
  ./start.sh
  ```
  
6. After QPS-Infra startup, the following components are available. Take a look at variables.env for default credentials:
  > Use your host domain address or IP.
  > admin/qaprosoft are hardcoded sonarqube credentials, and they can be updated inside the Sonar Administration panel
  
| Components          	| URL                                                                                                    	|
|---------------------	|--------------------------------------------------------------------------------------------------------	|
| 1st Page            	| [http://demo.qaprosoft.com](http://demo.qaprosoft.com)                                                 	|
| Jenkins             	| [http://demo.qaprosoft.com/jenkins](http://demo.qaprosoft.com/jenkins)                                 	|
| Zebrunner Insights  	| [http://demo.qaprosoft.com/app](http://demo.qaprosoft.com/app)                                         	|
| SonarQube           	| [http://demo.qaprosoft.com/sonarqube](http://demo.qaprosoft.com/sonarqube)                             	|
| Web Selenium Hub    	| [http://demo:demo@demo.qaprosoft.com/ggr/wd/hub](http://demo:demo@demo.qaprosoft.com/ggr/wd/hub)       	|
| Mobile Selenium Hub 	| [http://demo:demo@demo.qaprosoft.com/mcloud/wd/hub](http://demo:demo@demo.qaprosoft.com/mcloud/wd/hub) 	|


## Disable/Remove component(s)
QPS-Infra contains such layers of services:

| Layer                        	| Containers                                                           	|
|------------------------------	|----------------------------------------------------------------------	|
| NGiNX WebServer              	| nginx                                                                	|
| Reporting Services           	| postgres, zafira, zafira-ui, rabbitmq, elasticsearch, redis, logstash	|
| CI (Jenkins)                 	| jenkins-master, jenkins-slave-web, jenkins-slave-api                 	|
| Local Storage                	| ftp                                                                  	|
| Code Analysis                	| sonarqube                                                            	|
| Embedded web selenium hub    	| ggr, selenoid                                                        	|
| Embedded mobile selenium hub 	| selenium-hub                                                         	|
  
Open docker-composer.yml and comment/remove all unused containers.
> Make sure to remove disabled services from depends_on directives in docker-compose.yml

## Troubleshooting

## Support Channel

* Join [Telegram channel](https://t.me/qps_infra) in case of any question
