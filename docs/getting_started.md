# QPS-Infra - Getting started
## Software prerequisites
* Docker requires a user with uid=1000 and gid=1000 for simple volumes sharing, etc.
  Note: to verify the current user uid/gid, execute
  ```
  id
  uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),102(netdev),999(docker
  ```
* Install docker ([Ubuntu 16.04](http://www.techrepublic.com/article/how-to-install-docker-on-ubuntu-16-04/), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [MacOS](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/)) and [docker-composer](https://docs.docker.com/compose/install/#install-compose)


## Initial setup
* Clone [qps-infra](https://github.com/qaprosoft/qps-infra). You can also create your private repo to migrate the infrastructure easily
* Go to the qps-infra folder and launch the setup.sh script providing your hostname or ip address as an argument
```
git clone https://github.com/qaprosoft/qps-infra.git
cd qps-infra
./setup.sh myhost.domain.com
```
* Optional: adjust docker-compose.yml file by removing unused services. By default, it contains:
  nginx, postgres, zafira/zafira-ui, jenkins-master, jenkins-slave, selenium hub, sonarqube, rabbitmq, elasticsearch

### Security setup  (strongly recommended for publicly available environments)
* Regenerate AUTH_TOKEN_SECRET for production environment. (It should be base64 encoded value based on randomized string)
* Regenerate CRYPTO_SALT value (it should be randomized alpha-numeric string)
* Optional: update default credentials if neccessary
  Note: If you changed RABBITMQ_USER and RABBITMQ_PASS, please, update them in config/definitions.json and config/logstash.conf files as well  
```
cd qps-infra
nano variables.env
```
Set new secret value for AUTH_TOKEN_SECRET
Set new secret value for CRYTPO_SALT
...
Save changes in variables.env
```
./start.sh
```
* Open http://myhost.domain.com to access direct links to the sub-components: Zafira, Jenkins, etc.

## Services start/stop/restart
* Use ./stop.sh script to stop everything
* Use ./start.sh to start all containers
```
./stop.sh
./start.sh
```

## Env details
* After QPS-Infra startup, the following components are available. Take a look at variables.env for default credentials:
* [Jenkins](http://demo.qaprosoft.com/jenkins)
* [Selenium Grid](http://demo.qaprosoft.com/grid/console)
* [Zafira Reporting Tool](http://demo.qaprosoft.com/zafira)
* [SonarQube](http://demo.qaprosoft.com/sonarqube)
  Note: admin/qaprosoft are hardcoded sonarqube credentials, and they can be updated inside the Sonar Adminisration panel
  
# Jenkins Setup

## Register Organization
* Open Jenkins->Management_Jobs folder.
* Run "RegisterOrganization" providing your SCM (GitHub) organization name as folderName
* -> New folder is created with default content


## Register Repository
* Open your organization folder
* Run "RegisterRepository" pointing to your TestNG repository (use https://github.com/qaprosoft/carina-demo as default repo to scan)
* -> Repository should be scanned and TestNG jobs created

## Run Job(s)
* Open scanned repository
* Run a job from the list e.g. "Web-Demo-Single-Driver-Test"
* -> Job should be passed 
* Open Zafira e.g. http://demo.qaprosoft.com/zafira ->Test runs
* -> Test run result is present

## onPullRequest and onPush event setup
### Setup GitHub PullRequest plugin 
* Open Jenkins -> Credentials
* Update Username and Password for "ghprbhook-token" credentials

* Go to Github -> select or create Repository
* Open Pull requests
* Create new Pull request

* Open Jenkins->repository
* -> onPullRequest-carina-demo,	onPullRequest-carina-demo-trigger jobs should be scanned

