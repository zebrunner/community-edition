# Configuration Guide
   
## Organization Setup        
### Register Organization
   
  * Open Jenkins->Management_Jobs folder.
  * Run "RegisterOrganization" providing your organization name as folderName
  * New folder is created with default content   
  ![Alt text](https://github.com/zebrunner/zebrunner/blob/develop/docs/img/Organization.png?raw=true "Organization")

### Register Repository
   * Open your organization folder
   * Open RegisterRepository Job
   * Select the scm type of your repository(GitHub, Gitlab or BitBucket)
   * Add your TestNG repository url (use https://github.com/qaprosoft/carina-demo.git as sample repo to scan)
   * Click build
   ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/Repository.png?raw=true "Repository")
   > Note: Repository is scanned and TestNG jobs created
   
   > Note: https and ssh cloning are suported, make sure that you repository url ends up with **.git**

### Setup webhook events (push and pull requests)

 In order to enable full ci/cd workflow you need to add a webhook to your repository registered in Zebrunner, this webhook will trigger onPush and onPullRequests events on the ci component(Jenkins by default) as builds. 
 
 After each Push and Pull Request events, related Jenkins jobs will pull your repository, build your code and execute the sonarqube analysis.
 
#### Configure required credentials

After you register a repository a jenkins credential is generated with the format of `orgName-scmType-webhook-token`, this credential needs to be updated with a personal access token generated in your repository scm.
> Note: this jenkins credentials are globally used for each repository of an organization registered in zebrunner.

##### Github access token

   * Follow steps 1-9 [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) to create your GitHub personal access token.
   * Grant access for the following permissions: **repo and admin:repo_hook**.

##### Gitlab access token
   * Follow steps 1-7 [here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token) to create your Gitlab personal access token.
   * In step **5** select the **api, read_repository, write_repository** scopes.


##### BitBucket Cloud token
   * Open your terminal and run the following command ```echo -n username:password | base64``` where username and password are your BitBucket credentials, this will return a token encoded in base64.
   
> Note: make sure to copy your token as your are going to need it in the **Configure Webhooks** and **Update Jenkins Credentials** sections.

##### Update Jenkins Credentials

   * Go to **Jenkins > Manage Jenkins > Manage credentials**.
   * Find your `orgName-scmType-webhook-token` credential and click on the ID.
   * Update the **Secret text** with your correspondent scm token.
   * Click save.
   
#### Configure Webhooks

##### GitHub: Configure Webhook for Pushes and Pull Requests
   * Go to your **GitHub repository page > Settings > Webhooks > Add webhook**.
   * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=github-token-here` into "Payload URL" field.
   * Select application/json in "Content Type" field.
   * Click **Let me select individual events** and select **Pushes, Pull Requests**.
   * Click **Add webhook**.
   
##### Gitlab: Configure Webhook for Pushes and Pull Requests 
   * Go to your **Gitlab repository page > Settings > Webhooks**.
   * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=gitlab-token-here` into "Payload URL" field.
   * Select application/json in "Content Type" field.
   * Select **Push and Merge Requests events**.
   * Click **Add webhook**.
   
##### BitBucket Cloud: Configure Webhook for Pushes
   * Go to your **BitBucket repository page > Repository Settings > Webhooks > add webhook**.
   * Enter `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=bitbucket-token-here` into **URL** field.
   * Check that **Repository push** is selected.
   * Click **Save**.

## SonarQube Integration

The sonarqube static analysis is invoked for each webhook event triggered on your target repository(pushes and/or pull/merge requests).

If the event is a pull/merge request the reports from the sonarqube analysis will be decorated into the pull request itself for the correspondant scm system. On the contrary, only the analysis will run for push events.


> Note: default credentials for embedded sonarqube are: admin/admin, we recommend to change them after setting up zebrunner

> Note: Sonarqube pull request decoration is supported for **Github** and **Gitlab**

> Note: if the sonarqube server is not available the analysis will be skipped

### Integrate private sonarqube server

If you have a private sonarqube instance and you have decided to use it, please follow the steps bellow:

   * Login to Jenkins, go to **Manage Jenkins > System Configuration > Global Properties**
   * Search for **SONAR_URL** and change the value with your private SonarQube instance url
   > Note: Compatible SonarQube version is 7.9.3 - 8.0
     
### GitHub configuration

To enable **pull reqeuest decoration** on your github repository you need to create a **GitHub App**, his purpose is to publish the sonarqube reports generated on the webhook event being processed as **checks** into the pull request itself on github. 

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

  * Under "Where can this GitHub App be installed?" select **Any account.**
  * Click **Create GitHub App**. This will take you to your new GitHub App's page.
  * Scroll down to the bottom of your app page and click **Generate Private Key.** This downloads a .pem file that you'll use in the **Configure SonarQube server section.**
  > Tip: in order to acces the private key open the .pem file with your favorite text editor.
  
#### Install your app

Once the app is created, you need to install it in your target organization to **grant acces** to all of your repositories with the permissions specified in the **Create a [GitHub App]** section.

Install your GitHub App from the app's settings page.

  * Go to your **GitHub profile > Developer settings > GitHub Apps > Your app name > Install App**
  * Select the organization to install the app
  * Select **All repositories**
  * Click install
  > Note: You can select specific repositories, so the github application will have access **only for those specified**

#### Configure sonarqube with your app

  * Login into your sonarqube instance
  * Go to **Administration > Configuration > GitHub** add your GitHub App **Client ID, Client Secret**
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarGitHubConfig.png?raw=true "SonarGitHubConfig")
   
  * In **Administration > Configuration > Pull Request** add your GitHub **App ID, App Name, App Private Key**
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarPullRequestConfig.png?raw=true "SonarPullRequestConfig")
  
  > Note: make sure to copy all content from the .pem file generated in the **Create GitHub App** section
  
#### Pull Request decoration example

When you create a pull and the sonar analysis reported issues, your pull request will be decorated with those issues and links to the sonarqube instance with your project.

![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/github-pr-deco1.png?raw=true "github-pr-deco1")
![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/github-pr-deco2.png?raw=true "github-pr-deco2")
  
### Gitlab configuration
  
To enable **merge requests decoration** on your gitlab repository we are going to use the token generated in **Gitlab access token** step. The sonarqube report is published as pipeline status and comments into the merge request itself.
   
   * Login into your sonarqube instance
   * Go to **Administration > Configuration > Pull Requests > Integration with Gitlab** and in the token input paste your gitlab acces token.

#### Merge request decoration exmaple

When you create a merge request and the sonar analysis reports issues, your merge request will be decorated with those issues and links to the sonarqube instance with your project.

![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/gitlab-mr-deco1.png?raw=true "gitlab-mr-deco1")
![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/gitlab-mr-deco2.png?raw=true "gitlab-mr-deco2")
   
### Configure sonarqube base URL

This will serve static context(such as images, links, etc.) for pull/merge requests decoration. Follow the below steps to configure your server base URL:

   * Add your SonarQube server under **Administration > Configuration > General Settings > Server base URL**
   ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarBaseUrlConfig.png?raw=true "SonarBaseUrlConfig")
   > Tip: If you are missing images in your decorated pull/merge request it is probably due to configuration issues or the sonarqube server being unavailable at that moment.
   
   
## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
