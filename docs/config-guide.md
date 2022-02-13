# Configuration Guide

## Components details
  > Use your host domain address or IP instead of `hostname`.

| Components            | URL                                                                |
|---------------------  |------------------------------------------------------------------- |
| Zebrunner Reporting   | [http://hostname](http://hostname)                                 |
| Jenkins               | [http://hostname/jenkins](http://hostname/jenkins)                 |
| SonarQube             | [http://hostname/sonarqube](http://hostname/sonarqube)             |
| Web Selenium Hub      | [http://hostname/selenoid/wd/hub](http://hostname/selenoid/wd/hub) |
| Mobile Selenium Hub   | [http://hostname/mcloud/wd/hub](http://hostname/mcloud/wd/hub)     |
| Mobile SmartTest Farm | [http://hostname/stf](http://hostname/stf)                         |

> admin/changeit crendetials should be used for Reporting and Jenkins, admin/admin for SonarQube.
   
## Organization Setup        
### Register Organization
  
  * Login to [Zebrunner Reporting](http://hostname)
  * Open "Account and Profile" menu in top right corner and generate token
  * Login to [Jenkins](http://hostname/jenkins), open "Management_Jobs" folder
  * Run "RegisterOrganization" job providing your organization name as folderName and Reporting url/token
  ![Alt text](https://github.com/zebrunner/zebrunner/blob/develop/docs/img/Organization.png?raw=true "Organization")
  > New organization folder is created with "RegisterRepository" job inside and registered reporting integration  

### Register Repository
  * Open your organization folder
  * Run "RegisterRepository" job providing git args (use [carina-demo](https://github.com/zebrunner/carina-demo.git) as sample repo to scan)
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/Repository.png?raw=true "Repository")
  > SYSTEM jobs (build, onPullRequest, onPush) and all testing jobs are generated, login to [SonarQube](http://hostname/sonarqube) to see static code analysis of your test repository sources 
  * Setup [Source Code Manager](https://zebrunner.github.io/community-edition/integration/scm/) and [SonarQube](https://zebrunner.github.io/community-edition/integration/sonarqube/) integrations to automate jobs generation and static code analysis for every pull request/merge operations.

### Run any Job
  * Open generated repository folder
  > if no TestNG suite xml files detected you can use default `build` job
  * Run any TestNG job
  > Job is executed, results published to the reporting
  * Follow [User Guide](https://zebrunner.github.io/community-edition/user-guide/) practices to manage your CI jobs via code

## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
