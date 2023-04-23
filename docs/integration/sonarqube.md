# SonarQube Integration

The sonarqube static analysis is invoked for each webhook event triggered on your target repository(pushes and/or pull/merge requests).

If the event is a pull/merge request the reports from the sonarqube analysis will be decorated into the pull request itself for the correspondant scm system. On the contrary, only the analysis will run for push events.
> Note: default credentials for embedded sonarqube are: admin/admin. Please, change them after 1st login

  * Login to SonarQube
  * Go to **My Account > Security**
  * Generate new token using **Global Analysis Token** type and **No expiration**
  * Login to the Jenkins, go to **Manage Jenkins > System Configuration > Global Properties**
  * Search for **SONAR_TOKEN** and put generated value
  > To integrate private sonarqube server update also **SONAR_URL** global env variable.

## GitHub configuration

To enable **pull request decoration** on your github repository you need to create a **GitHub App**, its purpose is to publish the sonarqube reports generated on the webhook event being processed as **checks** into the pull request itself on github.
> Steps were generated based on original Sonarqube [article](https://docs.sonarqube.org/9.8/devops-platform-integration/github-integration/)

### Create a [GitHub App](https://developer.github.com/apps/about-apps/)

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
     |      Contents            | Read-only     |
     |      Email addresses     | Read-only     |
     |      Members             | Read-only     |
     |      Projects            | Read-only     |

  > Note: if your are using **Github Enterprise** the permission "Metadata" is renamed to "Repository Metadata"

  * Under "Where can this GitHub App be installed?" select **Any account.**
  * Click **Create GitHub App**. This will take you to your new GitHub App's page.
  * Scroll down to the bottom of your app page and click **Generate Private Key.** This downloads a .pem file that you'll use in the **Configure SonarQube server section.**
  > Tip: in order to acces the private key open the .pem file with your favorite text editor.
  
### Install your app

Once the app is created, you need to install it in your target organization to **grant acces** to all of your repositories with the permissions specified in the **Create a [GitHub App]** section.

Install your GitHub App from the app's settings page.


  * Go to your **GitHub profile > Developer settings > GitHub Apps > Your app name > Install App**
  * Select the organization to install the app
  * Select **All repositories**
  * Click install
  > Note: You can select specific repositories, so the github application will have access **only for those specified**

### Configure sonarqube with your app

  * Login into your sonarqube instance
  * Go to **Administration > DevOps Platform Integrations > GitHub** add your GitHub App **Client ID, Client Secret**
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarGitHubConfig.png?raw=true "SonarGitHubConfig")
   
  * Create new GitHub configuation. Add your GitHub **App ID, App Name, App Private Key**
  TODO
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarPullRequestConfig.png?raw=true "SonarPullRequestConfig")
  
  > Note: make sure to copy all content from the .pem file generated in the **Create GitHub App** section
  
### Configure DevOps Integration for your project

  * Login into your sonarqube instance
  * Go to your project **General Settings > DevOps Platform Integrations**
  * Choose **Configuration name**, specify **Repository name** and **Enable analysis summary under the GitHub Conversation tab**
  TODO
  ![Alt text](https://github.com/qaprosoft/qps-infra/blob/develop/docs/img/SonarProjectPullRequestConfig.png?raw=true "SonarProjectPullRequestConfig")

### Pull Request decoration example

When you create a pull and the sonar analysis reported issues, your pull request will be decorated with those issues and links to the sonarqube instance with your project.

![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/github-pr-deco1.png?raw=true "github-pr-deco1")
![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/github-pr-deco2.png?raw=true "github-pr-deco2")
  
## Gitlab, Bitbucket and Azure configuration

Visit original Sonarqube integration [guide](https://docs.sonarqube.org/latest/devops-platform-integration/github-integration/)
  
## Configure sonarqube base URL

This will serve static context(such as images, links, etc.) for pull/merge requests decoration. Follow the below steps to configure your server base URL:

  * Add your SonarQube server under **Administration > Configuration > General Settings > Server base URL**
  > Tip: If you are missing images in your decorated pull/merge request it is probably due to configuration issues or the sonarqube server being unavailable at that moment.
   
   
## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
