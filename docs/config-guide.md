# Configuration Guide
   
## Organization Setup        
### Register Organization
   
  * Open Jenkins->Management_Jobs folder.
  * Run "RegisterOrganization" providing your organization name as folderName
  * New folder is created with default content   
  ![Alt text](https://github.com/zebrunner/zebrunner/blob/develop/docs/img/Organization.png?raw=true "Organization")

### Register Repository
   * Open your organization folder
   * Select the scm type of your repository(GitHub, Gitlab or BitBucket)
   * Run "RegisterRepository" pointing to your TestNG repository (use https://github.com/qaprosoft/carina-demo.git as sample repo to scan)
   ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/Repository.png?raw=true "Repository")
   > Note: Repository is scanned and TestNG jobs created
   
   > Note: https and ssh cloning are suported, make sure that you repository url ends up with **.git**

   > Note: Repository is scanned and TestNG jobs created

### Setup scm webhook events (push and pull requests)

 In order to enable full ci/cd workflow you need to add a webhook to your repository registered in Zebrunner, this webhook will trigger onPush and onPullRequests events on the ci component(Jenkins by default) as builds. 
 
 After each Push and Pull Request related Jenkins jobs will pull your repository, run the specified test and execute the sonarqube analysys. If the webhook event is a pull request the reports from the sonarqube analysis will be decorated into the pull request for the correspondant scm system.
 
 > Note: if the sonarqube server is not available the scan will be skipped
 
#### GitHub: Configure Webhook for Pushes,Pull Requests
   
   * Follow steps 1-6 [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) to create your GitHub personal access token.
   * Grant access for the following permissions: **repo and admin:reopo_hook**.
   * Go to your **GitHub repository page > Settings > Webhooks > Add webhook**.
   * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=github-token-here` into "Payload URL" field.
   * Select application/json in "Content Type" field.
   * Click **Let me select individual events** and select **Pushes, Pull Requests**.
   * Click **Add webhook**.
   
#### Gitlab: Configure Webhook for Pushes,Pull Requests 

   * Follow steps 1-7 [here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token) to create your Gitlab personal access token.
   * In step **5** select the **api** scope.
   * Go to your **Gitlab repository page > Settings > Webhooks**.
   * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=gitlab-token-here` into "Payload URL" field.
   * Select application/json in "Content Type" field.
   * Select **Push and Merge Requests events**.
   * Click **Add webhook**.
   
   #### BitBucket Cloud: Configure Webhook for Pushes

   * Open your terminal and run the following command ```echo -n username:password | base64``` where username and password are your BitBucket credentials, this will return a token encoded in base64.
   * Go to your **BitBucket repository page > Repository Settings > Webhooks > add webhook**.
   * Enter `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=bitbucket-token-here` into **URL** field.
   * Check that **Repository push** is selected.
   * Click **Save**.
   
> Note: make sure to copy your token as your are going to need it in the **Update Jenkins Credentials**.

## Update Jenkins Credentials

When you register a repository a credential is generated with the format of `orgName-scmType-webhook-token`, this credential needs to be updated with the correspondant scm token created in the **Setup scm webhook events (push and pull requests)** step.

* Go to **Jenkins > Manage Jenkins > Manage credentials**.
* Find your credential and click on the id.
* Update the **Secret text** with your correspondant scm token.
* Click save.

> Note: this webhook credentials are globally used for each repository of an organization registered in zebrunner.

## SonarQube Integration

Sonarqube pull request decoration is supported for **github and gitlab**

In order to integrate non-embedded SonarQube instance, please:
  * Login to Jenkins, go to **Manage Jenkins > System Configuration > Global Properties**
  * Search for **SONAR_URL** and change the value for your private SonarQube instance
  > Note: Compatible SonarQube version is 7.9.3+
   
### GitHub

#### Create a [GitHub App](https://developer.github.com/apps/about-apps/)

  * Follow Steps 1–4 [here](https://developer.github.com/apps/building-github-apps/creating-a-github-app/) to start creating your GitHub App
  * Under **GitHub App name**, give your app a name, such as SonarQubePRDecorator.
  * Add a **Homepage URL**. GitHub requires this, but it isn't important for Pull Request decoration. You can use any URL, such as https://zebrunner.com/.
  * Enter your **User authorization callback URL**. Set this to your instance's base URL. For example, `https://your-zebrunner-domain/sonarqube/oauth2/callback`
  * Add **Webhook URL**. Set this to your instance's base URL. For example, https://zebrunner.com/.
  * Grant access for the following **Permissions**:
  
     |Permission                | Access        |
     |:------------------------:|---------------|
     |      Checks              | Read & Write  | 
     |      Metadata            | Read-Only     | 
     |      Pull Requests       | Read & Write  |
     |      Commit statuses     | Read-only     |
  > Note: if your are using **Github Enterprise** the permission "Metadata" is renamed to "Repository Metadata"

  * Under "Where can this GitHub App be installed?," select **Any account.**
  * Click **Create GitHub App**. This will take you to your new GitHub App's page.
  * Scroll down to the bottom of your app page and click <**Generate Private Key.** This downloads a .pem file that you'll use in the **Configure SonarQube server section.**
  > Tip: in order to acces the private key open the .pem file with your favorite text editor.
  
#### Install your app
Installing your GitHub App from the app's settings page.

  * Go to your **GitHub profile > Developer settings > GitHub Apps > Your app name > Install App**
  * Select the organization to install the app
  * Select **All repositories**
  * Click install

  
### Configure SonarQube server

  * Login into your sonarqube instance.
  > Note: default credentials for embeded sonarqube are: admin/admin, we recommend changing them after setting up the zebrunner.
  
  * Add your SonarQube server under **Configuration > General Settings > Server base URL**
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarBaseUrlConfig.png?raw=true "SonarBaseUrlConfig")
  
  * For Github go to **Configuration > GitHub** add your GitHub App **Client ID, Client Secret**
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarGitHubConfig.png?raw=true "SonarGitHubConfig")
   
  * In **Configuration > Pull Request** add your GitHub **App ID, App Name, App Private Key**
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarPullRequestConfig.png?raw=true "SonarPullRequestConfig")
  
  > Note: make sure to copy all content from the .pem file generated in the **Create GitHub App** section
  
  > Note: for **gitlab** add the token generated in the **Setup scm webhook events (push and pull requests)** in Sonarqube instance go to **Administration > Configuration > Pull request >integration with gitlab** section


## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
