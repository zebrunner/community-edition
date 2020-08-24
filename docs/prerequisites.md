#  Prerequisites

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

### Security requirements

* NGiNX WebServer port is shared
  > By default 80 for http and 443 for https
  
### [Optional] SMTP requirements

* Valid smtp host and user for sending notifications

### Create a GitHub OAuth App

* Follow Steps 1–4 [here](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/) to start creating your GitHub OAuth App
* Under **GitHub App name**, give your app a name, such as "Zebrunner (Community Edition)".
* Add a **Homepage URL** and **Authorization callback URL**. Set this to your instance's base URL. For example, https://your.zebrunner.domain.com/

### AWS S3 bucket

**Note:**
Only for case when embedded S3 compatible minio storage not used

TODO
  
