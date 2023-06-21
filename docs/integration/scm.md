# Source Code Manager Integration

## Setup webhook events (push and pull requests)

 In order to enable full CI/CD workflow you need to add a webhook to your repository registered in Zebrunner, this webhook will trigger onPush and onPullRequests events on the CI component (Jenkins by default). 
 
 After each Push and Pull Request events, related Jenkins jobs will pull your repository, scan and generate new test jobs automatically and optionally execute the static code analysis via the sonarqube.
 
### Configure required credentials

After you register a repository a jenkins credential is generated with the format of `orgName-scmType-webhook-token`, these credentials must be updated with the `new token`.
> Note: this jenkins credentials are globally used for each repository of an organization registered in zebrunner.

#### Update Jenkins Credentials

  * Go to **Jenkins > Manage Jenkins > Manage credentials**.
  * Find your `orgName-scmType-webhook-token` credential and click on the ID.
  * Update the **Secret text** with your `new token`.
  * Click save.
> You can choose any text value as the `new token`
   
### Configure Webhooks

#### GitHub: Configure Webhook for Pushes and Pull Requests
  * Go to your **GitHub repository page > Settings > Webhooks > Add webhook**.
  * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=new-token-here` into "Payload URL" field.
  * Select application/json in "Content Type" field.
  * Click **Let me select individual events** and select **Pushes, Pull Requests**.
  * Click **Add webhook**.
   
#### Gitlab: Configure Webhook for Pushes and Pull Requests 
  * Go to your **Gitlab repository page > Settings > Webhooks**.
  * Add `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=new-token-here` into "Payload URL" field.
  * "Secret Token" is empty field.
  * Select **Push and Merge Requests events**.
  * Click **Add webhook**.
   
#### BitBucket Cloud: Configure Webhook for Pushes
  * Go to your **BitBucket repository page > Repository Settings > Webhooks > add webhook**.
  * Enter `http://your-zebrunner-domain.com/jenkins/generic-webhook-trigger/invoke?token=new-token-here` into **URL** field.
  * Check that **Repository push** is selected.
  * Click **Save**.

## Support Channel

  * Join [Telegram channel](https://t.me/zebrunner) in case of any question
