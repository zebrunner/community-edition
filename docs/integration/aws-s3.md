#  AWS S3 Bucket

For case when embedded S3 compatible minio storage not used

## Create bucket 

* Create new bucket in AWS S3 (choose region closer to your location)
* In bucket “Public Access Settings” uncheck all properties (later security will be configured on other level)
![Alt text](https://github.com/zebrunner/zebrunner/blob/master/docs/img/s3.png?raw=true "AWS S3 Bucket")
* In “Bucket Policy” put below json:
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
> replacing _MYBUCKET_ with actual name and putting password instead of _MyStrongPassword_

* Provide _MYBUCKET_ as `Bucket` and _MyStrongPassword_ as `UserAgent key` during setup procedure
  
## Create user

* Goto IAM -> Policies -> **Create Policy** -> Active **JSON**
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
* Click **Review policy** -> specify name like _zebrunner-s3-writer-policy_ -> **Create Policy**
* Goto IAM -> Users -> **Add User**
* Specify username like zebrunner-s3-user -> Pick “Programmatic access” -> **Next: Permissions:** -> **Attach existing policies directly**
* Choose previously created policy -> **Next: Tags** -> **Next: Review** -> **Create User**
* Provide user keys as `Access key` and `Secret key` during setup procedure
