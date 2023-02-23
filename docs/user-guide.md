# User Guide

## Preconditions

- TestNG repository is available. 
 > For quick start use [carina archetype](https://zebrunner.github.io/carina/getting_started/) 
- Infrustructure is deployed, and optionally onPullRequest/onPush events configured.

## Continious Intergration (Jenkins)

All test jobs are created and maintained automatically according to [IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) processes. 
For every TestNG [suite](https://www.toolsqa.com/testng/testng-test-suite/) dedicated job is created.
> For example visit [carina suites](https://github.com/qaprosoft/carina-demo/tree/master/src/test/resources/testng_suites) 

## Test Jobs (API/Web/Mobile)

To generate special type of jobs, coverage matrix etc we have to use special annotations otherwise "api" job is generated using suite ["name"](https://github.com/qaprosoft/carina-demo/blob/14f7f7a7c426b1c6d86768abddf4c6467b32b016/src/test/resources/testng_suites/api.xml#L2). 
Test Jobs can be executed on-demand, scheduled, included into different testing layers (Smoke, Regression, etc.).

### Create a Job

* Open TestNG suite xml file
* Fill the bunch of parameters in your xml:
```
<parameter name="suiteOwner" value="qpsdemo"/>
<parameter name="jenkinsJobName" value="Job1"/>
<parameter name="jenkinsJobType" value="api"/>
<parameter name="jenkinsEmail" value="test@qaprosoft.com"/>
<parameter name="jenkinsEnvironments" value="DEMO"/> 
```
* Commit and merge.
* After scan is finished (automatic or manual) "Job1" test job is created in Jenkins.

### Run a Job
Steps:

* Login to Jenkins
* Go to organization/repository and open a Job
* Click Build with Parameters and run Build 
* When Job is completed analyze published reports/logs (Carina reports/Zebrunner reports/TestNG reports)

### Schedule a Job
* Open TestNG suite xml file
* Declare "scheduling" parameter :
```
<parameter name="scheduling" value="H 2 * * *" /> 
```
> Note: Provide regular Jenkins Cron expression as a value. To organize multiple schedules use "\n" as separator:
```
<parameter name="scheduling" value="H 2 * * *\nH 10 * * *" /> 
```
* Commit and merge.

### Delete a Job

* Delete TestNG suite xml file
* Commit and merge.
* Ask your administrator to remove the Job on Jenkins.

## Cron Jobs (Layer of Testing)
Jenkins Pipeline Cron - this is a job that can execute different suites/jobs in scope of single run. Test Job can be assigned to testing layer(cron) using "jenkinsRegressionPipeline" annotation.

### Create a Cron
* Open TestNG suite xml file
* Declare "jenkinsRegressionPipeline" property in xml:
```
<parameter name="jenkinsRegressionPipeline" value="nightly_regression, full_regression"/>
```
* Commit and merge.
* After scan is finished (automatic or manual) nightly_regression and full_regression crons are created in Jenkins.
* During execution nightly_regression or full_regression crons current test suite(job) must be executed.

#### How to Set up Configuration Matrix
* Open TestNG suite xml file 
* Declare "jenkinsRegressionMatrix" property in xml:
```
<parameter name="jenkinsRegressionPipeline" value="Carina-Demo-Regression-Pipeline"/>
<parameter name="jenkinsRegressionMatrix" value="env: DEMO, branch: master; env:PROD, branch: prod"/>
```
* Commit and merge.
* After scan is finished (automatic or manual) Carina-Demo-Regression-Pipeline cron job is created in Jenkins.
* Every time you run Carina-Demo-Regression-Pipeline job it should start your suite xml child job twice for DEMO and PROD environments using appropriate branches.
> Note: Any param values pairs can be provided. Comma separated - for single job params. Semicolon separated for multiple child job params.

### Run a Cron
Steps:

* Go to organization/repository and open a Cron Job
> Note: There is a "CRON" view for such kind of jobs
* Click Build with Parameters and run Build 
* Cron Job should trigger children jobs according to desired configuration matrix
* When Cron and children jobs are finished analyze children jobs' reports/logs (Carina reports/Zebrunner reports/TestNG reports)

### Schedule a Cron
* Open any child TestNG suite xml file 
* Declare "jenkinsRegressionScheduling" parameter :
```
<parameter name="jenkinsRegressionPipeline" value="Carina-Demo-Regression-Pipeline"/>
<parameter name="jenkinsRegressionScheduling" value="H 2 * * *" /> 
```
* Commit and merge.
* After scan is finished (automatic or manual) Carina-Demo-Regression-Pipeline is created and sheduled to run periodically in Jenkins.

### Delete a Cron

* Open <b>each</b> TestNG suite xml file(s) and remove declaration of "jenkinsRegressionPipeline" property.
* Commit and merge.
* Ask your administrator to delete Cron job in Jenkins

## Special Annotations

To start there are a number of additional parameters that can be added to an existing Test Suite xml.
These parameters are: 
</br>
<b>jenkinsJobName</b> - This property is just the name that Jenkins should create a job for, the normal pattern here is to include the platform name in the job itself to make it easier to find inside of Jenkins. 
</br>
<b>jenkinsJobDisabled</b> - This property is for disable job on Jenkins. 
</br>
<b>jenkinsJobType</b> – This property tells Jenkins what type of job it is. This field can take a “web”, “api”, “ios”, “android” value. For each type of job appropriate capabilities and parameter are generated.
If value set to “api” – Jenkins knows that there is no need to use web browser for run this Test Suite.
If value set to “web” – Jenkins will use web browser to run the Test. Chrome browser will be used by default.
If value set to “ios” – ios native application test job.
If value set to “android” – android native application test job.
</br>
<b>capabilities</b> - This property is extended W3C driver capabilities.
</br>
<b>scheduling</b> - This property is for running jobs by the schedule.
</br>
<b>jenkinsGroups</b> - This property is for running jobs in accordance with testng groups annotation. 
</br>
<b>jenkinsEmail</b> - This property takes a comma separated list of emails/distribution lists that end results of a Test Suite will be emailed to. 
</br>
<b>jenkinsFailedEmail</b> - This property takes a comma separated list of emails/distribution lists that end results of a Test Suite that contains failures will be emailed to. 
</br>
<b>jenkinsRegressionPipeline</b> - This property takes a comma separated string of the various pipelines that a specific Test Suite will be attached to. 
</br>
<b>jenkinsEnvironments</b> - This property takes a comma separated string of the various environments that might be tested for that particular suite i.e. PROD, QA, DEV, STAGE, BETA, etc.
</br>
<b>jenkinsPipelineEnvironments</b> - This property takes a comma separated string of the various environments that will be tested for a particular suite in a particular pipeline (i.e. PROD,QA,DEV,STAGE) 
</br>
<b>jenkinsJobExecutionOrder</b> - This property takes a number value and allows for a pipeline to be generated which will run tests in a sequential synchronous manner, compared to the default asynchronous manner. 
</br>
<b>jenkinsJobExecutionMode</b> - This property is only consumed when a jenkinsJobExecutionOrder has been set on a pipeline which would put that pipeline into a synchronous mode and takes a value of "continue" or "abort". 
When it is "abort" we halt the entire pipeline as only failed job detected. It might be useful to setup extended health-check scenarios. 
</br>
<b>jenkinsRegressionMatrix</b> - This property we use for creating configuration test matrix. 
</br>
<b>overrideFields</b> - This property takes any number of custom fields that need to be available at run-time for a job to run successfully. They can override any CI parameter forcibly.
</br>
<b>jenkinsSlackChannels</b> - This property is responsible for send test run results to Slack channel via slack-api.
</br>
<b>jenkinsFailedSlackChannels</b> - This property takes a comma separated list of slack channels to notify about failures.
</br>
<b>jenkinsDefaultRetryCount</b> - This property allows to provide custom retry_count property (number of extra attempts for test execution).
</br>
<b>jenkinsNodeLabel</b> - This property allows to override slave label and execute test on custom server.
</br>
<b>overrideFields</b> - This property allows to add custom Fields that can override default fields.
</br>
<b>provider</b> - This property is for add provider for test job.
</br>
<b>jenkinsAutoScreenshot</b> - This property is a boolean parameter mostly to enable auto_screenshot which is disabled by default.
</br>

## Support Channel

* Join [Telegram channel](https://t.me/zebrunner) in case of any question
