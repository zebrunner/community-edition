## User Guide

### How to use these features? 
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


### Test Jobs (API/Web/Mobile)
Jenkins Pipeline Job - this is a job that can be created for each suite and can be executed on demand or by schedule. 

#### Create a Job

1. Open TestNG suite xml file
2. Fill the bunch of necessary parameters in your xml:
```
<parameter name="suiteOwner" value="qpsdemo"/>
<parameter name="jenkinsJobName" value="Job1"/>
<parameter name="jenkinsJobType" value="api"/>
<parameter name="jenkinsEmail" value="test@qaprosoft.com"/>
<parameter name="jenkinsEnvironments" value="DEMO"/> 
```
3. Commit and merge.
4. You will see "Job1" Job after Scan is finished (automatic or manual). 
</br>
<b> Example: </b>
```
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite verbose="1" name="Demo Tests - API Sample" parallel="tests" annotations="JDK">
	<parameter name="suiteOwner" value="qpsdemo"/>
	<parameter name="zafira_project" value="UNKNOWN"/>
	<parameter name="jenkinsJobName" value="Job1"/>
	<parameter name="jenkinsJobType" value="api"/>
        <parameter name="jenkinsEmail" value="test@qaprosoft.com"/>
	<parameter name="jenkinsEnvironments" value="DEMO"/>
</suite>
``` 
#### Run a Job
Steps:

1. Login to Jenkins
2. Go to organization/repository and open a Job
3. Click Build with Parameters and run Build 
4. When Job is Completed analyze published reports/logs (Carina reports/Zafira reports/TestNG reports)

#### Schedule a Job
1. Open TestNG suite xml file
2. Fill the bunch of necessary parameters in your xml if they are absent:
```
<parameter name="scheduling" value="H 2 * * *" /> 
```
Note: As a value provide regular Jenkins Cron expression.To prganize multiple schedules use "\n" as separator:
```
<parameter name="scheduling" value="H 2 * * *\nH 10 * * *" /> 
```
4. Commit and merge.

#### Delete a Job

1. Delete TestNG suite xml file
2. Commit and merge.
3. Ask your administrator to remove the Job on Jenkins.

### Cron Jobs(Layer of testing)
Jenkins Pipeline Cron - this is a job that can include different suites/jobs and can be executed on demand or by schedule.

#### Create a Cron
1. Open each TestNG suite xml file(s) 
2. Declare "jenkinsRegressionPipeline" property in xml:
```
<parameter name="jenkinsRegressionPipeline" value="nightly_regression, full_regression"/>
```
3. Commit and merge.
4. After Scan is finished (automatic or manual) nightly_regression, full_regression crons are created in Jenkins.

##### How to Set up Configuration Matrix
1. Open TestNG suite xml file 
2. Declare "jenkinsRegressionMatrix" property in xml:
```
<parameter name="jenkinsRegressionPipeline" value="Carina-Demo-Regression-Pipeline"/>
<parameter name="jenkinsRegressionMatrix" value="env: DEMO, branch: master; env:PROD, branch: prod"/>
```
3. Commit and merge.
4. After Scan is finished (automatic or manual) Carina-Demo-Regression-Pipeline cron job is created in Jenkins.
5. Every time you run Carina-Demo-Regression-Pipeline job it should start your suite xml child job twice for DEMO and PROD environments using appropriate branches.
Note: Any param values pairs can be provided. Comma separated - for single job params. Semicolon separated for multiple child job params.

#### Run a Cron
Steps:

1. Go to organization/repository and open a Cron Job
Note: There is a "CRON" view for such kind of jobs
2. Click Build with Parameters and run Build 
3. Cron Job should trigger children jobs according to desired configuration matrix
4. When Cron Job is Completed analyze children jobs' reports/logs (Carina reports/Zafira reports/TestNG reports)

#### Schedule a Cron
1. Open any child TestNG suite xml file 
2. Declare "jenkinsRegressionScheduling" parameter :
```
<parameter name="jenkinsRegressionPipeline" value="Carina-Demo-Regression-Pipeline"/>
<parameter name="jenkinsRegressionScheduling" value="H 2 * * *" /> 
```
3. Commit and merge.
4. After Scan is finished (automatic or manual) Carina-Demo-Regression-Pipeline is created and sheduled to run periodically in Jenkins.

#### Delete a Cron

1. Open each TestNG suite xml file(s) and remove declaration of "jenkinsRegressionPipeline" property.
2. Commit and merge.
3. Ask your administrator to delete Cron job in Jenkins
