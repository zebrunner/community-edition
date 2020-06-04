QPS Infrastructure
==================

[![zafira pulls](https://img.shields.io/docker/pulls/qaprosoft/zafira.svg?label=zafira%20pulls)](https://hub.docker.com/r/qaprosoft/zafira/)
[![rabbitmq pulls](https://img.shields.io/docker/pulls/qaprosoft/rabbitmq.svg?label=rabbitmq%20pulls)](https://hub.docker.com/r/qaprosoft/rabbitmq/)
[![jenkins-master pulls](https://img.shields.io/docker/pulls/qaprosoft/jenkins-master.svg?label=jenkins-master%20pulls)](https://hub.docker.com/r/qaprosoft/jenkins-master/)
[![jenkins-slave pulls](https://img.shields.io/docker/pulls/qaprosoft/jenkins-slave.svg?label=jenkins-slave%20pulls)](https://hub.docker.com/r/qaprosoft/jenkins-slave/)
[![postgres pulls](https://img.shields.io/docker/pulls/qaprosoft/postgres.svg?label=postgres%20pulls)](https://hub.docker.com/r/qaprosoft/postgres/)

## Overview
QPS-Infra is a [Continuous configuration automation](https://en.wikipedia.org/wiki/Infrastructure_as_code#Continuous_configuration_automation) framework for continuous testing (running various kinds of tests on the code to gain successive levels of confidence in the quality of the code), and (optionally) continuous deployment. It is built in accordance with [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) processes. 
> It is integrated by default with [carina-core](http://www.carina-core.io) open source TestNG framework and uses Jenkins as a CI Tool.

* QPS-Infra is built on top of popular docker solutions, it includes Postgres database, [Zebrunner Insights](https://zebrunner.github.io/documentation/) - former Zafira Reporting Tool, Jenkins Master/Slaves Nodes, Selenium Hub(s), [MCloud](https://github.com/qaprosoft/mcloud) SonarQube, etc. 
  > In additions it is easily intergated with 3rd party devices/browsers cloud providers like: [Zebrunner Engine](https://zebrunner.com/), [MCloud](https://mobiletesting.farm/), [Browserstack](https://www.browserstack.com/), [SauceLabs](https://saucelabs.com/) etc

* All components are deployed under NGiNX WebServer which can be configured in a fully secured environment

* QPS-Infra and its subcomponents all together can be used as an effective Test Automation infrastructure for test automation development, execution, management, etc.

![Alt text](https://raw.githubusercontent.com/qaprosoft/qps-infra/master/docs/img/qps-infra.png?raw=true "QPS-Infra")

## Purpose
Welcome to the QPS-Infra Tutorial. This manual is designed to help you install, configure and maintain your system, and to optimize and extend or re-configure it to meet the changing needs of your business. 
> In short, the aim of this manual is to explain the tasks involved in administering QPS-Infra system

## Audience
This guide is written for all levels of administrators, from those responsible for deployment and setup, to those who oversee the entire system and its usage. In addition, some information from [User Guide](https://qaprosoft.github.io/qps-infra/user-guide/) is intended for TestOps engineers who want to build effective Test Automation process and follow best practices.

## Assumed Knowledge
Installation and Configuration guides are for administrators who install, deploy and Manage QPS-Infra products. It assumes the following knowledge:

 * Docker platform and docker compose orchestration tool skills
 * UNIX/Linux administration skills
 * Security and server administration skills
 * Understanding of your organization's security infrastructure, including authentication providers such as LDAP, and use of SSL
 * Understanding of your organization's network environment and port usage
 
User guide is for TestOps engineers who develop test automation scenarios, execute and maintain them etc. It assumes the following knowledge:

 * Preferable Test Automation language and framework. 
   > Java/Maven/[TestNG](https://testng.org/)
   </br>
   > [Carina](https://www.carina-core.io/) experience is a plus
 * Understanding of the basics of Jenkins pipeline and JobDSL


## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
