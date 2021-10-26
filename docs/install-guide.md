# Installation Guide

## Initial setup

1. Clone [Zebrunner](https://github.com/zebrunner/zebrunner) recursive and launch setup procedure
  ```
  git clone --recurse-submodule https://github.com/zebrunner/zebrunner.git && cd zebrunner && ./zebrunner.sh setup
  ```
  > Provide required details to finish configuration and start services
  
2. After startup, the following components might be available:
  > Use your host domain address or IP instead of `hostname`.
  
| Components            | URL                                                                |
|---------------------	|------------------------------------------------------------------- |
| Zebrunner Reporting   | [http://hostname](http://hostname)                                 |
| Jenkins               | [http://hostname/jenkins](http://hostname/jenkins)                 |
| SonarQube             | [http://hostname/sonarqube](http://hostname/sonarqube)             |
| Web Selenium Hub      | [http://hostname/selenoid/wd/hub](http://hostname/selenoid/wd/hub) |
| Mobile Selenium Hub   | [http://hostname/mcloud/wd/hub](http://hostname/mcloud/wd/hub)     |
| Mobile SmartTest Farm	| [http://hostname/stf](http://hostname/stf)                         |

> admin/changeit crendetials should be used for Reporting and Jenkins, admin/admin for SonarQube.

## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
