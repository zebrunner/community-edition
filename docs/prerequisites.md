#  Prerequisites

## System requirements 

### Hardware requirements

|                         	| Requirements                                                     	|
|:-----------------------:	|------------------------------------------------------------------	|
| <b>Operating System</b> 	| Ubuntu 16.04, 18.04, 20.04<br>Linux CentOS 7+<br>Amazon Linux 2 	|
| <b>       CPU      </b> 	| 8+ Cores                                                         	|
| <b>      Memory    </b> 	| 32 Gb RAM                                                        	|
| <b>    Free space  </b> 	| SSD 128Gb+ of free space                                         	|

> All in one standalone deployment supports up to 5 parallel executors for web and api tests. The most optimal EC2 instance type is t3a.2xlarge with enabled "T2/T3 Unlimited" feature

### Software requirements

* Install docker ([Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04), [Amazon Linux 2](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html), [Redhat/Cent OS](https://www.cyberciti.biz/faq/install-use-setup-docker-on-rhel7-centos7-linux/))
  
* Install [docker-composer](https://docs.docker.com/compose/install/#install-compose) 1.25.5+

* Install git 2.20.0+

### Security requirements

* NGiNX WebServer port is shared
  > By default 80 for http and 443 for https
