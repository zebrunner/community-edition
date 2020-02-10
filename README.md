QPS Infrastructure
==================

[![zafira pulls](https://img.shields.io/docker/pulls/qaprosoft/zafira.svg?label=zafira%20pulls)](https://hub.docker.com/r/qaprosoft/zafira/)
[![rabbitmq pulls](https://img.shields.io/docker/pulls/qaprosoft/rabbitmq.svg?label=rabbitmq%20pulls)](https://hub.docker.com/r/qaprosoft/rabbitmq/)
[![jenkins-master pulls](https://img.shields.io/docker/pulls/qaprosoft/jenkins-master.svg?label=jenkins-master%20pulls)](https://hub.docker.com/r/qaprosoft/jenkins-master/)
[![jenkins-slave pulls](https://img.shields.io/docker/pulls/qaprosoft/jenkins-slave.svg?label=jenkins-slave%20pulls)](https://hub.docker.com/r/qaprosoft/jenkins-slave/)
[![postgres pulls](https://img.shields.io/docker/pulls/qaprosoft/postgres.svg?label=postgres%20pulls)](https://hub.docker.com/r/qaprosoft/postgres/)

QPS-Infra is a dockerized QA infrastructure solution for Test Automation. It is integrated by default with [carina-core](http://www.carina-core.io) open source solution and uses jenkins as CI Tool.

* QPS-Infra is built on top of popular docker solutions, it includes Postgres database, [Zafira Reporting Tool](http://qaprosoft.github.io/zafira), Jenkins Master/Slaves Nodes, Selenium Hub, SonarQube, Rabbitmq, etc.

* All components are deployed under NGINX WebServer which can be configured in fully secured environment

* QPS-Infra and its subcomponents all together can be used as effective Test Automation infrastructure for test automation development, execution, managing, etc.

![Alt text](./qps-infra.png?raw=true "QPS-Infra")

## Contents
* [Software prerequisites](#software-prerequisites)
* [Initial setup](#initial-setup)
* [Services start/stop/restart](#services-startstoprestart)
* [Env details](#env-details)
* [Documentation and free support](#documentation-and-free-support)
## 
* [License](#license)


## Software prerequisites
* Docker requires to use user with uid=1000 and gid=1000 for simple volumes sharing etc.
  Note: to verify current user uid/gid execute
  ```
  id
  uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),102(netdev),999(docker
  ```
* Install docker ([Ubuntu](http://www.techrepublic.com/article/how-to-install-docker-on-ubuntu-16-04/), [MacOS](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/)) and [docker-composer](https://docs.docker.com/compose/install/#install-compose)


## Initial setup
* Clone [qps-infra](https://github.com/qaprosoft/qps-infra). Optionally create your private repo for it to have easily migrated infrastructure
* Goto qps-infra folder and launch setup.sh script providing your hostname or ip address as argument
```
git clone https://github.com/qaprosoft/qps-infra.git
cd qps-infra
./setup.sh myhost.domain.com
```
* Optional: update default credentials if neccessary (strongly recommended for publicly available environments)
  Note: If you changed RABBITMQ_USER and RABBITMQ_PASS please update them in config/definitions.json and config/logstash.conf files as well
* Optional: adjust docker-compose.yml file by removing unused services. By default it contains:
  nginx, postgres, zafira/zafira-ui, jenkins-master, jenkins-slave, selenium hub, sonarqube, rabbitmq, elasticsearch
* Execute ./start.sh to start all containers
* Open http://myhost.domain.com to get access to direct links to the sub-components: zafira, jenkins etc


## Services start/stop/restart
* Use ./stop.sh script to stop everything
* Opional: it is recommended to remove old containers during restart
* Use ./start.sh to start all containers
```
./stop.sh
docker-compose rm -g
./start.sh
```

## Env details
* After QPS-Infra startup the following components are available. Take a look at variables.env for default credentials:
* [Jenkins](http://demo.qaprosoft.com/jenkins)
* [Selenium Grid](http://demo.qaprosoft.com/grid/console)
* [Zafira Reporting Tool](http://demo.qaprosoft.com/zafira)
* [SonarQube](http://demo.qaprosoft.com/sonarqube)
  Note: admin/qaprosoft are hardcoded sonarqube credentials and they can be updated inside Sonar Adminisration panel
  
## Documentation and free support
* [Zafira manual](http://qaprosoft.github.io/zafira)
* [Carina manual](http://qaprosoft.github.io/carina)
* [Demo project](https://github.com/qaprosoft/carina-demo)
* [Telegram channel](https://t.me/qps_infra)

## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
