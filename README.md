<p style="padding: 10px;" align="left">
  <img src="https://github.com/zebrunner/zebrunner/raw/master/docs/img/zebrunner_logo.png">
</p>

Zebrunner CE (Community Edition) is a Test Automation Management Tool for continuous testing and continuous deployment. It allows you to run various kinds of tests and gain successive levels of confidence in the code quality. It is built in accordance with [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) processes. 
  > Zebrunner is integrated by default with [carina-core](http://www.carina-core.io) open source TestNG framework and uses Jenkins as a CI Tool.

It is built on top of popular docker solutions, it includes Postgres database, [Zebrunner Reporting](https://zebrunner.com/documentation), Jenkins Master/Slaves Nodes, Selenium Hub, Mobile Device Farm (MCloud), SonarQube etc.

All components are deployed under NGINX WebServer which can be configured in a fully secured environment

Zebrunner subcomponents all together can be used as an effective Test Automation infrastructure for test automation development, execution, management, etc.

## Support Zebrunner CE
Enjoy using Zebrunner Reporting in your testing process! Feel free to support the development with a [**donation**](https://www.paypal.com/donate?hosted_button_id=JLQ4U468TWQPS) for the next improvements.

<p align="center">
  <a href="https://zebrunner.com/"><img alt="Zebrunner" src="https://github.com/zebrunner/zebrunner/raw/master/docs/img/zebrunner_intro.png"></a>
</p>

## System requirements 

### Hardware requirements

|                         	| Requirements                                                     	|
|:-----------------------:	|------------------------------------------------------------------	|
| <b>Operating System</b> 	| Ubuntu 16.04 - 21.10<br>Linux CentOS 7+<br>Amazon Linux 2 	      |
| <b>       CPU      </b> 	| 8+ Cores                                                         	|
| <b>      Memory    </b> 	| 32 Gb RAM                                                        	|
| <b>    Free space  </b> 	| SSD 128Gb+ of free space                                         	|

### Software requirements

* Install docker ([Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04), [Amazon Linux 2](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html), [Redhat/Cent OS](https://www.cyberciti.biz/faq/install-use-setup-docker-on-rhel7-centos7-linux/))
  
* Install [docker-composer](https://docs.docker.com/compose/install/#install-compose) 1.25.5+

* Install git 2.20.0+

## Initial setup
Visit [Zebrunner Guide](https://zebrunner.github.io/community-edition) for detailed installation and configuration instructions.

1. Clone [Zebrunner CE](https://github.com/zebrunner/community-edition) recursively and launch setup procedure:
   ```
   git clone --recurse-submodule https://github.com/zebrunner/community-edition.git && cd community-edition && ./zebrunner.sh setup
   ```
   > Provide required details and start services.

2. After the startup, the following components might be available:
   > Use your host address instead of `hostname`!  
  
| Components            | URL                                                                |
|---------------------  | ------------------------------------------------------------------ |
| Zebrunner Reporting   | [http://hostname](http://hostname)                                 |
| Jenkins               | [http://hostname/jenkins](http://hostname/jenkins)                 |
| SonarQube             | [http://hostname/sonarqube](http://hostname/sonarqube)             |
| Web Selenium Hub      | [http://hostname/selenoid/wd/hub](http://hostname/selenoid/wd/hub) |
| Mobile Selenium Hub   | [http://hostname/mcloud/wd/hub](http://hostname/mcloud/wd/hub)     |
| Mobile SmartTest Farm | [http://hostname/stf](http://hostname/stf)                         |

  > admin/changeit crendetials should be used for Reporting and Jenkins, admin/admin for SonarQube.


## Documentation and free support
* [Zebrunner PRO](https://zebrunner.com)
* [Zebrunner CE](https://zebrunner.github.io/community-edition)
* [Zebrunner Reporting](https://zebrunner.com/documentation)
* [Carina Guide](http://zebrunner.github.io/carina)
* [Demo Project](https://github.com/zebrunner/carina-demo)
* [Telegram Channel](https://t.me/zebrunner)

## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
