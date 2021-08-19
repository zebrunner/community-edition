<p style="padding: 10px;" align="left">
  <img src="https://github.com/zebrunner/zebrunner/raw/master/docs/img/zebrunner_logo.png">
</p>

Zebrunner CE (Community Edition) is a Test Automation Management Tool for continuous testing and continuous deployment. It allows you to run various kinds of tests and gain successive levels of confidence in the code quality. It is built in accordance with [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) processes. 
  > Zebrunner is integrated by default with [carina-core](http://www.carina-core.io) open source TestNG framework and uses Jenkins as a CI Tool.

It is built on top of popular docker solutions, it includes Postgres database, [Zebrunner Reporting](https://zebrunner.github.io/zebrunner/), Jenkins Master/Slaves Nodes, Selenium Hub, Mobile Device Farm (MCloud), SonarQube etc.

All components are deployed under NGINX WebServer which can be configured in a fully secured environment

Zebrunner subcomponents all together can be used as an effective Test Automation infrastructure for test automation development, execution, management, etc.

## Support Zebrunner CE
Enjoy using Zebrunner Reporting in your testing process! Feel free to support the development with a [**donation**](https://www.paypal.com/donate?hosted_button_id=JLQ4U468TWQPS) for the next improvements.

<p align="center">
  <a href="https://zebrunner.com/"><img alt="Zebrunner" src="https://github.com/zebrunner/zebrunner/raw/master/docs/img/zebrunner_intro.png"></a>
</p>

## Initial setup
Visit [Zebrunner Guide](https://zebrunner.github.io/zebrunner) for detailed installation and configuration instructions.

1. Clone [Zebrunner](https://github.com/zebrunner/zebrunner) recursive and launch setup procedure:
  ```
  git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git && cd zebrunner && ./zebrunner.sh setup
  ```
  > Provide required details and start services.

2. After the startup, the following components might be available:
  > Use your host address instead of `hostname`!  
  
| Components          	| URL                                                                                    |
|---------------------	|--------------------------------------------------------------------------------------- |
| Zebrunner Reporting  	| [http://hostname](http://hostname)                                                     |
| Jenkins             	| [http://hostname/jenkins](http://hostname/jenkins)                                 	   |
| SonarQube           	| [http://hostname/sonarqube](http://hostname/sonarqube)                             	   |
| Web Selenium Hub    	| [http://demo:demo@hostname/selenoid/wd/hub](http://demo:demo@hostname/selenoid/wd/hub) |
| Mobile Selenium Hub 	| [http://demo:demo@hostname/mcloud/wd/hub](http://demo:demo@hostname/mcloud/wd/hub) 	   |
| Mobile SmartTest Farm	| [http://hostname/stf](http://hostname/stf)                                         	   |

> admin/changeit crendetials should be used for Reporting and Jenkins, admin/admin for SonarQube.


## Documentation and free support
* [Zebrunner PRO](https://zebrunner.com)
* [Zebrunner CE](https://zebrunner.github.io/zebrunner)
* [Zebrunner Reporting](https://zebrunner.com/documentation)
* [Carina Guide](http://zebrunner.github.io/carina)
* [Demo Project](https://github.com/zebrunner/carina-demo)
* [Telegram Channel](https://t.me/zebrunner)

## License
Code - [Apache Software License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

Documentation and Site - [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/deed.en_US)
