# Kube2iam example
Before running this example, you should answer the following questions:
- *What is **Kube2iam**?*
- *Why use **Kube2iam**?*

**Kube2iam documentation:** https://github.com/jtblin/kube2iam/blob/master/README.md

After that, you need to create a new role and attach policy. In this example I create a role can list objects in a specify bucket. 

Create a policy like bellow
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::YOUR_BUCKET_NAME"
            ]
        }
    ]
}
```

Next, attach the policy you just created above to a role that you have created and the trust relationships for the role:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "WORKER_ROLE_ARN"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**WORKER_ROLE_ARN** has format **arn:aws:iam::YOUR_ACCOUNT_ID:role/CLUSTER_ROLE_NAME**

to get the **CLUSTER_ROLE_NAME** you can run command below:
```shell
# Make sure you already in the "cluster" folder.
terraform output -raw cluster_role_name
```

Finally, in [pod.yaml](pod.yaml) you need to replace **YOUR_ROLE_ARN** as your role you just created above and **YOUR_BUCKET_NAME**.