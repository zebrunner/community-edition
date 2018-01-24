QPS Infrastructure
==================

QPS-Infra is dockerized QA infrastructure solution for Test Automation. Is is integrated by default with [carina-core](http://www.carina-core.io) open source solution and use jenkins as CI Tool.

* QPS-Infra is built on the top of popular docker solutions, it includes Postgres database, [Zafira Reporting Tool](http://www.carina-core.io), Jenkins Master/Slaves Nodes, Selenium Hub, SonarQube, Rabbitmq etc.

* All components are deployed under NGINX WebServer which can be configured in fully secure environment

* All together can be used as effective Test Automation infrastructure for test automation development, execution, managing etc.

![Alt text](./qps-infra.png?raw=true "QPS-Infra")

## Contents
* [Software prerequisites](#software-prerequisites)
* [Initial setup](#initial-setup)
* [Services start/stop/restart](#services-restart)
* [Env details](#env-details)
* [License](#license)


## Software prerequisites
* Change current user uid/guid to uid=1000 and gid=1000 - (https://github.com/jenkinsci/docker)
  Note: for current user just change uid/guid inside /etc/passwd and reboot host
* Install [docker](http://www.techrepublic.com/article/how-to-install-docker-on-ubuntu-16-04/)
* Installed [docker-composer](https://docs.docker.com/compose/install/#install-compose)


## Initial setup
* Update ./nginx/conf.d/default.conf file replacing demo.qaprosoft.com with real server_name or ip address. Also specify valid resolver host(s)
* Update ./variables.env file replacing demo.qaprosoft.com with real server_name or ip address
* Optional: update default credentials if neccessary
* Optional: adjust docker-compose.yml file removing unused service. By default it contains:
  nginx, postgres, zafira, jenkins-master, jenkins-slave, selenium hub, sonarqube, rabbitmq  


## Services start/stop/restart
* Use ./stop.sh script to stop everything
* User ./start.sh to start all containers


## Env details
* After QPS-Infra startup such components are available. take a look to variables.env for default credentials:
* [Jenkins](http://demo.qaprosoft.com/jenkins)
* [Selenium Grid](http://demo.qaprosoft.com/grid/console)
* [Zafira Reporting Tool](http://demo.qaprosoft.com/zafira)
* [Sonarqube](http://demo.qaprosoft.com/sonarqube)
*  Note: replace demo.qaprosoft.com with your actual server name or ip address

## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
