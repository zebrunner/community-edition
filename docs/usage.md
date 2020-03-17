# QPS-Infra - Getting started Use Cases
## 1:Update Jenkins credentials
* ## Preconditions:

  Jenkins is installed and started
 
* ## Steps:

1.Open Jenkins

2.Click on Credentials in the left menu

3.Select "ghprbhook-token" and click on the link

4.Click on Update in the left menu

5.Enter Username e.g."okamara"

6.Near Password click Change password

7.Enter value of "Git token access" that was generated before for this user

8.Save changes


## 2:RegisterOrganization
* ## Preconditions:

1.Jenkins is started          

2.Open Jenkins e.g. http://54.193.74.120/jenkins/ 

3.Open jenkins/configure and change value of branch QPS_PIPELINE_GIT_BRANCH to “master”

4.Open Management_Jobs folder e.g.http://54.193.74.120/jenkins/job/Management_Jobs/

* ## Steps: 
                                                      

1.Tap on Register Organization

Expected Result: Pipeline RegisterOrganization is opened

2.Tap Build with Parameters in right top menu

3.Enter folder name - select your name e.g. okamara

4.Tap Build

* Expected Result: Organization is registered and new folder e.g. okamara appears in Jenkins(http://54.193.74.120/jenkins/)

5.If error appears in console 
A: remove completely $HOME/.m2/repository and QPS_HONE/jenkins/.groovy/grapes content to allow jenkins to redownload everything from scratch

* Expected Result: Go to step 6-8

6.Open Terminal and run the following commands:
sudo rm -rf ~/.m2/repository
cd ~/qps-infra
rm -rf ./jenkins/.groovy/grapes

7.Restart Jenking in web via url e.g. http://54.193.74.120/jenkins/restart

* Expected Result: Jenkins is restarted

8.Repeat Register organization steps 1-4

* Expected Result: Pipeline RegisterOrganization is done

## 3:RegisterRepository
* ## Preconditions:

Open my organization that was created e.g. jenkins/okamara

* ## Steps:  

1.Tap RegisterRepository

* Expected Result:Pipeline RegisterRepository page is opened

2.Verify that the following values are preset up in the fields:
scmHost - github.com,
scmOrg is entered e.g. okamara,
branch - master,
pipelineLibrary - QPS-Pipeline,
runnerClass - com.qaprosoft.jenkins.pipeline.runner.maven.QARunner

* Expected Result:The following values are preset up in the fields: scmHost - github.com, scmOrg is entered e.g. okamara , branch - master, pipelineLibrary - QPS-Pipeline, runnerClass - com.qaprosoft.jenkins.pipeline.runner.maven.QARunner

3.Enter scmuser - e.g. okamara,
scmTocken - enter your token (should be generated on 
gihub for your user),
repo - e.g. ”carina-demo”

4.Tap Build

* Expected Result:Build is successful

5.Verify that jenkins/okamara/carina-demo/ contains jobs: onPullRequest-carina-demo-trigger and 
onPullRequest-carina-demo

* Expected Result:jenkins/okamara/carina-demo/ contains jobs: onPullRequest-carina-demo-trigger and 
onPullRequest-carina-demo


## 4:Create fork via Github
* ## Preconditions:
Github account is created for you

* ## Steps:  

1.Sign in to Github with your user account https://github.com/

2.Open My profile

3.Go to qaprosoft/carina-demo

4.Tap Fork

5.Verify that okamara/carina-demo repository is created

  * Expected Result:okamara/carina-demo repository is created

## 5:Configure Webhook via GitHub
* ## Preconditions:

Instruction is here http://54.193.74.120/jenkins/job/okamara/job/carina-demo/job/onPullRequest-carina-demo-trigger/

or 
Open https://github.com

* ## Steps:  

1.Sign in with your user account

2.Open created before your repository e.g. okamara/carina-demo https://github.com/okamara/carina-demo

3.Open Settings

4.Open Webhooks in menu

5.Tap Add Webhook

6.Enter Payload URL e.g. http://54.193.74.120/jenkins/ghprbhook/

7.Select application/x-www-form-urlencoded in "Content Type" field

8.Select "Let me select individual events" with "Issue comments" and "Pull requests enabled" option

9.Click "Add webhook" button

  * Expected Result:Webhook is created
  
## 6:Send Pull request via github  
* ## Preconditions:

Open jenkins/configure e.g. http://54.193.74.120/jenkins/configure

* ## Steps:

1.Go to GitHub Pull Request Builder

2.Add check mark to Test adding comment to Pull Request

3.Set in Issue ID of Pull request from Git e.g.
test for jenkins #1 https://github.com/okamara/carina-demo/pull/1 enter “1”

4.Enter Comment to post e.g. “Comment”

5.Tap “Comment to Issue”

6.Verify that comment is set via Pull request

## 7:Close/Restart Pull request via github
* ## Preconditions:
Open pull request in GitHub https://github.com/okamara/carina-demo/pull/1

* ## Steps:

1.Tap “Close pull request”

2.Tap “Reopen pull request”

3.Verify that carina-demo jobs run is done on e.g. 1. http://54.193.74.120/jenkins/job/okamara/job/carina-demo/

* Expected Result:The following jobs are run onPullRequest-carina-demo-trigger and 
onPullRequest-carina-demo 

##  Workaround to run jobs without errors(.m2 folder)
* ## Preconditions:

If onPullRequest-carina-demo and onPullRequest-carina-demo-trigger job run with errors like e.g.
[ERROR] Could not create local repository at /var/jenkins_home/.m2/repository -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]

* ## Steps:

1.Run the following commands via terminal:
sudo chown -R ubuntu:ubuntu ~/.m2
sudo chmod -R a+rws ~/.m2
./stop.sh
docker-compose rm -fv
./start.sh

2.Stop/Resend pull request via github and verify that jobs onPullRequest-carina-demo and onPullRequest-carina-demo-trigger run without errors
 
## Workaround for "Error grabbing Grapes"(.m2) during create organization or start jobs
* ## Preconditions:

If onPullRequest-carina-demo and onPullRequest-carina-demo-trigger job run with errors like e.g.
[ERROR] General error during conversion: Error grabbing Grapes -- [download failed: org.beanshell#bsh;2.0b4!bsh.jar]

* ## Steps:

1.remove completely $HOME/.m2/repository and QPS_HONE/jenkins/.groovy/grapes content to allow jenkins to redownload everything from scratch

Run the following commands via terminal:
./stop.sh
sudo rm -rf ~/.m2/repository
cd ~/tools/qps-infra
rm -rf ./jenkins/.groovy/grapes
./start.sh

## 8:Run Web-Demo-Test job(should be failed)
* ## Preconditions:

Jenkins is started
Organization is created
Repo is registered

* ## Steps:

1.Go to qaprosoft/carina-demo and start Web-Demo-Test

* Expected Result:Pipeline Web-Demo-Test is opened

2.Click Build with Parameters and run Build

* Expected Result: Pipeline Web-Demo-Test is started

3.Open Jenkins and verify that web tests are running in web node

4.Open Build History in Web-Demo-Test and select Zafira Report

* Expected Result:Zafira report Web-demo-test in opened

5.Verify that Web-Demo-Test should be failed

6.Click "Logs" and verify that the report had status "failed"

## 9:Run API-Demo-Test job(should be passed)
* ## Preconditions:

Jenkins is started
Organization is created
Repo is registered

* ## Steps:

1.Go to qaprosoft/carina-demo and start API-Demo-Test job

* Expected Result:Pipeline API-Demo-Test job is opened

2.Click Build with Parameters and run Build

* Expected Result:Pipeline API-Demo-Test job is started

3.Open Jenkins and verify that web tests are running in web node

4.Open Build History in API-Demo-Test and select Zafira Report

* Expected Result:

5.Click "Logs" and verify that the report looks correctly

## 10:Run nightly_regression job(should be passed)
* ## Preconditions:

Jenkins is started
Organization is created
Repo is registered

* ## Steps:

1.Go to qaprosoft/carina-demo and start nightly_regression job

* Expected Result:Nightly_regression job is opened

2.Click Build with Parameters and run Build

* Expected Result:Pipeline Nightly_regression is started

3.Open Jenkins and verify that web tests are running in web node

4.Go to qaprosoft/carina-demo and verify that API-Demo-Test, API-DataProvider, SOAP-Demo,Tags-Demo-Test,API-CustomParams, Web-Demo-Single-Driver are completed and Passed.
Web-Demo-Test is completed and failed.

## 11:Run full_regression job(need to stop mobile jobs to complete this task)
* ## Preconditions:

Jenkins is started
Organization is created
Repo is registered

* ## Steps:

1.Go to qaprosoft/carina-demo and start full_regression job

* Expected Result:Full_regression job is opened

2.Click Build with Parameters and run Build

* Expected Result:Pipeline full_regression job is started

3.Open Jenkins and verify that web tests are running in web node

4.Go to qaprosoft/carina-demo and verify that API-Demo-Test, API-DataProvider-Classes, SOAP-Demo, Tags-Demo-Test, API-CustomParams, Web-Demo-Single-Driver-Test, Mobile-Android-Demo-Test, Mobile-iOS-Demo-Test are completed and Passed.
Web-Demo-Test, API-DataProvider-Classes are completed and failed.






















