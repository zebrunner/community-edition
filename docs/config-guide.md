# Configuration Guide
## Jenkins Setup

### Register Organization
* Open Jenkins->Management_Jobs folder.
* Run "RegisterOrganization" providing your SCM (GitHub) organization name as folderName
* -> New folder is created with default content

### Register Repository
* Open your organization folder
* Run "RegisterRepository" pointing to your TestNG repository (use https://github.com/qaprosoft/carina-demo as default repo to scan)
* -> Repository should be scanned and TestNG jobs created

### onPullRequest Job/Event setup

#### Setup GitHub PullRequest plugin 
* Open Jenkins -> Credentials
* Update Username and Password for "ghprbhook-token" credentials

#### Trigger onPullRequest Job(s)
* Go to your GitHub repository
* Create new Pull Request
* -> Verify in Jenkins that onPullRequest-repo,onPullRequest-repo-trigger jobs launched and succeed

### onPush Job/Event setup

#### Setup GitHub WebHook
* Go to your GitHub repository
* Click "Settings" tab
* Click "Webhooks" menu option
* Click "Add webhook" button
* Type http://your-jenkins-domain.com/jenkins/github-webhook/ into "Payload URL" field
* Select application/json in "Content Type" field
* Tick "Send me everything." option
* Click "Add webhook" button

#### Trigger onPush Job(s)
* -> After any push or merge into the master onPush-repo job is launched, suites scanned, TestNG jobs created
