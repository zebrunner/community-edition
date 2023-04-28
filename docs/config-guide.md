# Configuration Guide

## Components details
  > Use your host domain address or IP instead of `hostname`.

| Components            | URL                                                                |
|---------------------  |------------------------------------------------------------------- |
| Zebrunner Reporting   | http://hostname                                                    |
| Jenkins               | http://hostname/jenkins                                            |
| SonarQube             | http://hostname/sonarqube                                          |
| Web Selenium Hub      | http://hostname/selenoid/wd/hub                                    |
| Mobile Selenium Hub   | http://hostname/mcloud/wd/hub                                      |
| Mobile SmartTest Farm | http://hostname/stf                                                |

> admin/changeit crendetials should be used for Reporting, Jenkins and Mobile SmartTest Farm, admin/admin for SonarQube.
   
## Organization Setup        
### Register Organization
  
  * Login to **Zebrunner Reporting**
  * Open "Account and Profile" menu in top right corner and generate token
  * Login to **Jenkins**, open "Management_Jobs" folder
  * Run "RegisterOrganization" job providing your organization name as folderName and Reporting url/token
  ![Alt text](https://github.com/zebrunner/community-edition/blob/master/docs/img/Organization.png?raw=true "Organization")
  > New organization folder is created with "RegisterRepository" job inside and registered reporting integration  

### Register Repository
  * Open your organization folder
  * Run "RegisterRepository" job providing git args (use [carina-demo](https://github.com/zebrunner/carina-demo.git) as sample repo to scan)
  ![Alt text](https://github.com/zebrunner/community-edition/blob/master/docs/img/Repository.png?raw=true "Repository")
  > SYSTEM jobs (build, onPullRequest, onPush) and all testing jobs are generated, login to **SonarQube** to see static code analysis of your test repository sources 
  * Setup [Source Code Manager](https://zebrunner.github.io/community-edition/integration/scm/) and [SonarQube](https://zebrunner.github.io/community-edition/integration/sonarqube/) integrations to automate jobs generation and static code analysis for every pull request/merge operations.

### Run any Job
  * Open generated repository folder
  > if no TestNG suite xml files detected you can use default `build` job
  * Run any TestNG job
  > Job is executed, results published to the reporting
  * Follow [User Guide](https://zebrunner.github.io/community-edition/user-guide/) practices to manage your CI jobs via code

## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
