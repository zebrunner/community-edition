QPS Infrastructure
==================

QPS-Infra is a dockerized QA infrastructure solution for Test Automation. It is integrated by default with [carina-core](http://www.carina-core.io) open source solution and uses jenkins as CI Tool.

* QPS-Infra is built on top of popular docker solutions, it includes Postgres database, [Zafira Reporting Tool](http://qaprosoft.github.io/zafira), Jenkins Master/Slaves Nodes, Selenium Hub, SonarQube, Rabbitmq, etc.

* All components are deployed under NGINX WebServer which can be configured in fully secured environment

* QPS-Infra and its subcomponents all together can be used as effective Test Automation infrastructure for test automation development, execution, managing, etc.

![Alt text](./qps-infra.png?raw=true "QPS-Infra")

## Contents
* [Software prerequisites](#software-prerequisites)
* [Initial setup](#initial-setup)
* [Services start/stop/restart](#services-restart)
* [Env details](#env-details)
* [License](#license)


## Software prerequisites
* Create new user, then change uid/guid to uid=1000 and gid=1000 - (https://github.com/jenkinsci/docker) for this user
  Note: for current user just change uid/guid inside /etc/passwd and reboot host
* Install [docker](http://www.techrepublic.com/article/how-to-install-docker-on-ubuntu-16-04/) and [docker-composer](https://docs.docker.com/compose/install/#install-compose)


## Initial setup
* Update ./nginx/conf.d/default.conf file by replacing demo.qaprosoft.com with real server_name or IP address. Also specify valid resolver host(s)
* Update ./variables.env file by replacing demo.qaprosoft.com with real server_name or IP address
* Optional: update default credentials if neccessary
* Optional: adjust docker-compose.yml file by removing unused services. By default it contains:
  nginx, postgres, zafira, jenkins-master, jenkins-slave, selenium hub, sonarqube, rabbitmq  
* Update username, password in definitions.json for RabbitMQ if you are not using default qpsdemo/qpsdemo user


## Services start/stop/restart
* Use ./stop.sh script to stop everything
* User ./start.sh to start all containers


## Env details
* After QPS-Infra startup the following components are available. Take a look at variables.env for default credentials:
* [Jenkins](http://demo.qaprosoft.com/jenkins)
* [Selenium Grid](http://demo.qaprosoft.com/grid/console)
* [Zafira Reporting Tool](http://demo.qaprosoft.com/zafira)
* [SonarQube](http://demo.qaprosoft.com/sonarqube)


## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
