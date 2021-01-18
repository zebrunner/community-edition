# Installation Guide

## Initial setup

1. Clone [Zebrunner](https://github.com/zebrunner/zebrunner) recursive and launch setup procedure
  ```
  git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git && cd zebrunner && ./zebrunner.sh setup
  ```
  > Provide required details to finish configuration and start services
  
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

## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
