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

* Install docker ([Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [Amazon Linux 2](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html), [Redhat/Cent OS](https://www.cyberciti.biz/faq/install-use-setup-docker-on-rhel7-centos7-linux/) or [MacOS](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/))
  > MacOS is <b>not recommended</b> for production usage!
  
* Install [docker-composer](https://docs.docker.com/compose/install/#install-compose)

## Initial setup

1. Clone recursive [Zebrunner Server](https://github.com/zebrunner/zebrunner)

2. Launch the setup.sh script providing your hostname as an argument:<br>
  ```
  git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git && cd zebrunner && ./zebrunner.sh setup
  ```
  > Provide required details to finish configuration

3. Start services<br>
  ```
  ./zebrunner.sh start
  ```

4. After startup, the following components are available:
  > Use your host domain address or IP.
  > admin/admin are hardcoded sonarqube credentials, and they can be updated inside the Sonar Administration panel
  
| Components          	| URL                                                                                                    	   |
|---------------------	|----------------------------------------------------------------------------------------------------------	   |
| Zebrunner Reporting  	| [http://demo.qaprosoft.com](http://demo.qaprosoft.com)                                                 	   |
| Jenkins             	| [http://demo.qaprosoft.com/jenkins](http://demo.qaprosoft.com/jenkins)                                 	   |
| SonarQube           	| [http://demo.qaprosoft.com/sonarqube](http://demo.qaprosoft.com/sonarqube)                             	   |
| Web Selenium Hub    	| [http://demo:demo@demo.qaprosoft.com/selenoid/wd/hub](http://demo:demo@demo.qaprosoft.com/selenoid/wd/hub)       |
| Mobile Selenium Hub 	| [http://demo:demo@demo.qaprosoft.com/mcloud/wd/hub](http://demo:demo@demo.qaprosoft.com/mcloud/wd/hub) 	   |
| Mobile SmartTestFarm 	| [http://demo.qaprosoft.com/stf](http://demo.qaprosoft.com/stf)                                         	   |

## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
