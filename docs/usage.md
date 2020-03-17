# QPS-Infra - Getting started Use Cases
## 1:Update Jenkins credentials
*  Preconditions:

  Jenkins is installed and started
 
* Steps:

1.Open Jenkins

2.Click on Credentials in the left menu

3.Select "ghprbhook-token" and click on the link

4.Click on Update in the left menu

5.Enter Username e.g."okamara"

6.Near Password click Change password

7.Enter value of "Git token access" that was generated before for this user

8.Save changes


## 2:RegisterOrganization
*  Preconditions:

1.Jenkins is started          

2.Open Jenkins e.g. http://54.193.74.120/jenkins/ 

3.Open jenkins/configure and change value of branch QPS_PIPELINE_GIT_BRANCH to “master”

4.Open Management_Jobs folder e.g.http://54.193.74.120/jenkins/job/Management_Jobs/

* Steps:   
                                                      

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
*  Preconditions:

Open my organization that was created e.g. jenkins/okamara

* Steps:   

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











