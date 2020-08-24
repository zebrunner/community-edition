#  Prerequisites

## System requirements 

### Hardware requirements

|                         	| Requirements                                                     	|
|:-----------------------:	|------------------------------------------------------------------	|
| <b>Operating System</b> 	| Linux Ubuntu 16.04, 18.04<br> Linux CentOS 7+<br> Amazon Linux 2 	|
| <b>       CPU      </b> 	| 8+ Cores                                                         	|
| <b>      Memory    </b> 	| 32 Gb RAM                                                        	|
| <b>    Free space  </b> 	| SSD 128Gb+ of free space                                         	|

> All in one standalone deployment supports up to 5 parallel executors for web and api tests. The most optimal EC2 instance type is t3.2xlarge with enabled "T2/T3 Unlimited" feature

### Software requirements

* Install docker ([Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04), [Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04), [Amazon Linux 2](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html), [Redhat/Cent OS](https://www.cyberciti.biz/faq/install-use-setup-docker-on-rhel7-centos7-linux/) or [MacOS](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/))
  > MacOS is <b>not recommended</b> for production usage!
  
* Install [docker-composer](https://docs.docker.com/compose/install/#install-compose)

### Security requirements

* NGiNX WebServer port is shared
  > By default 80 for http and 443 for https
  
### [Optional] SMTP requirements

* Valid smtp host and user for sending notifications

### Create a GitHub OAuth App

* Follow Steps 1–4 [here](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/) to start creating your GitHub OAuth App
* Under **GitHub App name**, give your app a name, such as "Zebrunner (Community Edition)".
* Add a **Homepage URL** and **Authorization callback URL**. Set this to your instance's base URL. For example, https://your.zebrunner.domain.com/

### AWS S3

**Note:**
Only for case when embedded S3 compatible minio storage not used

#### AWS S3 bucket 

1. Create new bucket in AWS S3 (choose region closer to your location)
2. In bucket “Public Access Settings” uncheck all properties (later security will be configured on other level)
![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/s3.png?raw=true "AWS S3 Bucket")
3. In “Bucket Policy” put below json:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::MYBUCKET/*",
            "Condition": {
                "StringLike": {
                    "aws:UserAgent": "MyStrongPassword"
                }
            }
        }
    ]
}
```
  > replacing _MYBUCKET_ with actual name and putting as strong password instead of _MyStrongPassword_
  
#### Create AWS S3 user
 
1. Create new user with AWS programmatic access:
* Goto IAM -> Policies -> Create New Policy-> Active JSON
* Put below value, replacing MYBUCKET with actual value
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::MYBUCKET",
                "arn:aws:s3:::MYBUCKET/*"
            ]
        }
    ]
}

```

2.  Click Review policy -> specify name like zebrunner-s3-writer-policy -> Create Policy
3.  GOTO IAM -> Users -> Add User
4.  Specify username like zebrunner-s3-user -> Pick “Programmatic access” -> Next Permissions -> Attach existing policies directly
5.  Choose previously created police -> Next: Tags -> Next: Review -> Create User
6.  Remember Access Key ID,  Secret key and UserAgent values

  
