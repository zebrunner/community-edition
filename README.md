Zebrunner Starter (QPS Infrastructure)
==================

[![zafira pulls](https://img.shields.io/docker/pulls/qaprosoft/zafira.svg?label=zafira%20pulls)](https://hub.docker.com/r/qaprosoft/zafira/)
[![rabbitmq pulls](https://img.shields.io/docker/pulls/qaprosoft/rabbitmq.svg?label=rabbitmq%20pulls)](https://hub.docker.com/r/qaprosoft/rabbitmq/)
[![jenkins-master pulls](https://img.shields.io/docker/pulls/qaprosoft/jenkins-master.svg?label=jenkins-master%20pulls)](https://hub.docker.com/r/qaprosoft/jenkins-master/)
[![jenkins-slave pulls](https://img.shields.io/docker/pulls/qaprosoft/jenkins-slave.svg?label=jenkins-slave%20pulls)](https://hub.docker.com/r/qaprosoft/jenkins-slave/)
[![postgres pulls](https://img.shields.io/docker/pulls/qaprosoft/postgres.svg?label=postgres%20pulls)](https://hub.docker.com/r/qaprosoft/postgres/)

<b>QPS-Infra becomes part of [Zebrunner solution](https://medium.com/@zebrunner_official/qps-infra-becomes-part-of-zebrunner-solution-dbcf233e49f)!</b>

QPS-Infra is a [Continuous configuration automation](https://en.wikipedia.org/wiki/Infrastructure_as_code#Continuous_configuration_automation) framework for continuous testing (running various kinds of tests on the code to gain successive levels of confidence in the quality of the code), and (optionally) continuous deployment. It is built in accordance with [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) processes. 
> It is integrated by default with [carina-core](http://www.carina-core.io) open source TestNG framework and uses Jenkins as a CI Tool.

* QPS-Infra is built on top of popular docker solutions, it includes Postgres database, [Zafira Reporting Tool](http://qaprosoft.github.io/zafira), Jenkins Master/Slaves Nodes, Selenium Hub, SonarQube, RabbitMQ, etc.

* All components are deployed under NGINX WebServer which can be configured in a fully secured environment

* QPS-Infra and its subcomponents all together can be used as an effective Test Automation infrastructure for test automation development, execution, management, etc.

![Alt text](./docs/img/qps-infra.png?raw=true "QPS-Infra")

## Documentation and free support
* [QPS infra manual](https://qaprosoft.github.io/qps-infra)
* [Zafira manual](http://qaprosoft.github.io/zafira)
* [Carina manual](http://qaprosoft.github.io/carina)
* [Demo project](https://github.com/qaprosoft/carina-demo)
* [Telegram channel](https://t.me/qps_infra)

## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
