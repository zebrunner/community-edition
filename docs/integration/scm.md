# Source Code Manager Integration

## Setup webhook events (push and pull requests)

 In order to enable full CI/CD workflow you need to add a webhook to your repository registered in Zebrunner, this webhook will trigger onPush and onPullRequests events on the CI component (Jenkins by default). 
 
 After each Push and Pull Request events, related Jenkins jobs will pull your repository, scan and generate new test jobs automatically and optionally execute the staic code analysis via the sonarqube.
 
### Configure required credentials

After you register a repository a jenkins credential is generated with the format of `orgName-scmType-webhook-token`, this credential needs to be updated with a personal access token generated in your repository scm.
> Note: this jenkins credentials are globally used for each repository of an organization registered in zebrunner.

#### Github access token

  * Follow steps 1-9 [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) to create your GitHub personal access token.
  * Grant access for the following permissions: **repo and admin:repo_hook**.

#### Gitlab access token
  * Follow steps 1-7 [here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#creating-a-personal-access-token) to create your Gitlab personal access token.
  * In step **5** select the **api, read_repository, write_repository** scopes.


#### BitBucket Cloud token
  * Open your terminal and run the following command ```echo -n username:password | base64``` where username and password are your BitBucket credentials, this will return a token encoded in base64.
   
> Note: make sure to copy your token as your are going to need it in the **Configure Webhooks** and **Update Jenkins Credentials** sections.

#### Update Jenkins Credentials

  * Go to **Jenkins > Manage Jenkins > Manage credentials**.
  * Find your `orgName-scmType-webhook-token` credential and click on the ID.
  * Update the **Secret text** with your correspondent scm token.
  * Click save.
   
### Configure Webhooks

#### GitHub: Configure Webhook for Pushes and Pull Requests
  * Go to your **GitHub repository page > Settings > Webhooks > Add webhook**.
  * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=github-token-here` into "Payload URL" field.
  * Select application/json in "Content Type" field.
  * Click **Let me select individual events** and select **Pushes, Pull Requests**.
  * Click **Add webhook**.
   
#### Gitlab: Configure Webhook for Pushes and Pull Requests 
  * Go to your **Gitlab repository page > Settings > Webhooks**.
  * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=gitlab-token-here` into "Payload URL" field.
  * "Secret Token" is empty field.
  * Select **Push and Merge Requests events**.
  * Click **Add webhook**.
   
#### BitBucket Cloud: Configure Webhook for Pushes
  * Go to your **BitBucket repository page > Repository Settings > Webhooks > add webhook**.
  * Enter `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=bitbucket-token-here` into **URL** field.
  * Check that **Repository push** is selected.
  * Click **Save**.

## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
