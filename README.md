<p style="padding: 10px;" align="left">
  <img src="./docs/img/zebrunner_logo.png">
</p>

Zebrunner is a [Continuous configuration automation](https://en.wikipedia.org/wiki/Infrastructure_as_code#Continuous_configuration_automation) framework for continuous testing (running various kinds of tests on the code to gain successive levels of confidence in the quality of the code), and (optionally) continuous deployment. It is built in accordance with [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) processes. 
  > It is integrated by default with [carina-core](http://www.carina-core.io) open source TestNG framework and uses Jenkins as a CI Tool.

It is built on top of popular docker solutions, it includes Postgres database, [Zebrunner Reporting](https://zebrunner.github.io/documentation/), Jenkins Master/Slaves Nodes, Selenium Hub, Mobile Device Farm (MCloud), SonarQube etc.

All components are deployed under NGINX WebServer which can be configured in a fully secured environment

Zebrunner subcomponents all together can be used as an effective Test Automation infrastructure for test automation development, execution, management, etc.

## Initial setup
Visit [Zebrunner Guide] for detailed installation and configuration instructions.

1. Clone [Zebrunner](https://github.com/zebrunner/zebrunner) recursive and launch setup procedure
  ```
  git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git && cd zebrunner && ./zebrunner.sh setup
  ```
  > Provide required details and start services

2. After startup, the following components might be available:
  > Use your host domain address or IP.  
  
| Components          	| URL                                                                                                    	   |
|---------------------	|----------------------------------------------------------------------------------------------------------	   |
| Zebrunner Reporting  	| [http://demo.zebrunner.com](http://demo.zebrunner.com)                                                 	   |
| Jenkins             	| [http://demo.zebrunner.com/jenkins](http://demo.zebrunner.com/jenkins)                                 	   |
| SonarQube           	| [http://demo.zebrunner.com/sonarqube](http://demo.zebrunner.com/sonarqube)                             	   |
| Web Selenium Hub    	| [http://demo:demo@demo.zebrunner.com/selenoid/wd/hub](http://demo:demo@demo.zebrunner.com/selenoid/wd/hub)       |
| Mobile Selenium Hub 	| [http://demo:demo@demo.zebrunner.com/mcloud/wd/hub](http://demo:demo@demo.zebrunner.com/mcloud/wd/hub) 	   |
| Mobile SmartTest Farm	| [http://demo.zebrunner.com/stf](http://demo.zebrunner.com/stf)                                         	   |

> admin/changeit crendetials should be used for Reporting and Jenkins, admin/admin for SonarQube.


## Documentation and free support
* [Zebrunner CE](https://zebrunner.github.io/zebrunner)
* [Zebrunner Reporting](https://zebrunner.github.io/documentation/)
* [Carina Manual](http://qaprosoft.github.io/carina)
* [Demo Project](https://github.com/qaprosoft/carina-demo)
* [Telegram Channel](https://t.me/zebrunner)

## QPS-Infra becomes part of [Zebrunner solution](https://medium.com/@zebrunner_official/qps-infra-becomes-part-of-zebrunner-solution-dbcf233e49f)!

## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
