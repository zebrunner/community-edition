# User Guide (Draft)

## How to use these features?

## Summary of Annotations

To start there are a number of additional parameters that can be added to an existing Test Suite xml.
These parameters are: 
</br>
<b> jenkinsJobName </b> - This property is just the name that Jenkins should create a job for, the normal pattern here is to include the platform name in the job itself to make it easier to find inside of Jenkins. 
</br>
<b>jenkinsJobType </b> – This property tells Jenkins what type of job it is. This field can take a “web” or “api” value.
If value set to “api” – Jenkins knows that there is no need to use web browser for run this Test Suite.
If value set to “web” – Jenkins will use web browser to run the Test. Chrome browser will be used by default.
</br>
<b> jenkinsEmail </b> - This property takes a comma separated list of emails/distribution lists that end results of a Test Suite will be emailed to. 
</br>
<b> jenkinsFailedEmail </b> - This property takes a comma separated list of emails/distribution lists that end results of a Test Suite that contains failures will be emailed to. 
</br>
<b>jenkinsRegressionPipeline </b> - This property takes a comma separated string of the various pipelines that a specific Test Suite will be attached to. (i.e. nightly_regression_cron, full_regression_cron). This would end up creating two pipeline jobs inside of Jenkins. 
</br>
<b>jenkinsEnvironments </b> - This property takes a comma separated string of the various environments that will be tested for that particular suite. (i.e. PROD, QA,DEV,STAGE,BETA, etc...) 
</br>
<b> jenkinsPipelineEnvironments </b> - This property takes a comma separated string of the various environments that will be tested for a particular suite in a particular pipeline (i.e. PROD,QA,DEV,STAGE) 
</br>
<b>jenkinsJobExecutionOrder</b> - This property takes a number value and allows for a pipeline to be generated which will run tests in a sequential synchronous manner, compared to the default asynchronous manner. 
</br>
<b> jenkinsJobExecutionMode </b> -This property is only consumed when a jenkinsJobExecutionOrder has been set on a pipeline which would put that pipeline into a synchronous mode and takes a value of "continue". 
When that is specified if a prior job has had an error while running the next job in sequence will still pick up and run instead of halting the entire pipeline. 
</br>
<b> jenkinsRegressionMatrix </b> - This property we use for creating configuration test matrix. 
</br>
<b> overrideFields </b> - This property takes any number of custom fields that need to be available at run-time for a job to run successfully.
</br>
<b> jenkinsSlackChannels </b> - This property is responsible for send test run results to Slack channel via slack-api.
</br>
<b> TestRailProjectId </b> - This property is project ID in TestRail of the test suite.
</br>
<b> TestRailSuiteId </b>  - This property is suite ID in Test Suite xml.
</br>
<b> jenkinsDefaultThreadCount </b> - This property is the number of test flows for current test suite. The value should be according to the number of devices or simulators that will be used for run the test suite. Note: In xml tag <suite> should be populated param "parallel".
  </br>
<b> jenkinsMobileDefaultPool </b> - This property means the name of the devices that will be used for running  test cases on mobile.
</br>

## Test Jobs (API/Web/Mobile)
Jenkins Pipeline Job - this is a job that can be created for each suite and can be executed on demand or by schedule. 

### Create a Job

* Open TestNG suite xml file
* Fill the bunch of necessary parameters in your xml:
```
<parameter name="suiteOwner" value="qpsdemo"/>
<parameter name="jenkinsJobName" value="Job1"/>
<parameter name="jenkinsJobType" value="api"/>
<parameter name="jenkinsEmail" value="test@qaprosoft.com"/>
<parameter name="jenkinsEnvironments" value="DEMO"/> 
```
* Commit and merge.
* You will see "Job1" Job after Scan is finished (automatic or manual). 

### Run a Job
Steps:

* Login to Jenkins
* Go to organization/repository and open a Job
* Click Build with Parameters and run Build 
* When Job is Completed analyze published reports/logs (Carina reports/Zafira reports/TestNG reports)

### Schedule a Job
* Open TestNG suite xml file
* Fill the bunch of necessary parameters in your xml if they are absent:
```
<parameter name="scheduling" value="H 2 * * *" /> 
```
> Note: As a value provide regular Jenkins Cron expression.To prganize multiple schedules use "\n" as separator:
```
<parameter name="scheduling" value="H 2 * * *\nH 10 * * *" /> 
```
* Commit and merge.

### Delete a Job

* Delete TestNG suite xml file
* Commit and merge.
* Ask your administrator to remove the Job on Jenkins.

## Cron Jobs(Layer of testing)
Jenkins Pipeline Cron - this is a job that can include different suites/jobs and can be executed on demand or by schedule.

### Create a Cron
* Open each TestNG suite xml file(s) 
* Declare "jenkinsRegressionPipeline" property in xml:
```
<parameter name="jenkinsRegressionPipeline" value="nightly_regression, full_regression"/>
```
* Commit and merge.
* After Scan is finished (automatic or manual) nightly_regression, full_regression crons are created in Jenkins.

#### How to Set up Configuration Matrix
* Open TestNG suite xml file 
* Declare "jenkinsRegressionMatrix" property in xml:
```
<parameter name="jenkinsRegressionPipeline" value="Carina-Demo-Regression-Pipeline"/>
<parameter name="jenkinsRegressionMatrix" value="env: DEMO, branch: master; env:PROD, branch: prod"/>
```
* Commit and merge.
* After Scan is finished (automatic or manual) Carina-Demo-Regression-Pipeline cron job is created in Jenkins.
* Every time you run Carina-Demo-Regression-Pipeline job it should start your suite xml child job twice for DEMO and PROD environments using appropriate branches.
> Note: Any param values pairs can be provided. Comma separated - for single job params. Semicolon separated for multiple child job params.

### Run a Cron
Steps:

* Go to organization/repository and open a Cron Job
> Note: There is a "CRON" view for such kind of jobs
* Click Build with Parameters and run Build 
* Cron Job should trigger children jobs according to desired configuration matrix
* When Cron Job is Completed analyze children jobs' reports/logs (Carina reports/Zafira reports/TestNG reports)

### Schedule a Cron
* Open any child TestNG suite xml file 
* Declare "jenkinsRegressionScheduling" parameter :
```
<parameter name="jenkinsRegressionPipeline" value="Carina-Demo-Regression-Pipeline"/>
<parameter name="jenkinsRegressionScheduling" value="H 2 * * *" /> 
```
* Commit and merge.
* After Scan is finished (automatic or manual) Carina-Demo-Regression-Pipeline is created and sheduled to run periodically in Jenkins.

### Delete a Cron

* Open each TestNG suite xml file(s) and remove declaration of "jenkinsRegressionPipeline" property.
* Commit and merge.
* Ask your administrator to delete Cron job in Jenkins

## Troubleshooting

## Support Channel

* Join [Telegram channel](https://t.me/qps_infra) in case of any question
