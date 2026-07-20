---
title : "Prerequisites"
date : 2026-07-01
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

#### Prerequisites

Before starting this workshop, ensure that you have prepared the required AWS environment and permissions. These prerequisites will help you deploy the AWS CloudSOC architecture successfully and avoid configuration issues during the implementation process.

---

#### AWS Account

You need an active AWS account with permission to create and manage AWS resources.

The workshop requires access to services such as:

+ Amazon EC2
+ Amazon VPC
+ AWS IAM
+ Amazon S3
+ Amazon CloudWatch
+ AWS CloudTrail
+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ Amazon EventBridge
+ AWS Step Functions
+ AWS Systems Manager
+ AWS Lambda
+ Amazon DynamoDB
+ Amazon SNS
+ Amazon Cognito
+ Amazon API Gateway
+ AWS Amplify Hosting

> **Note:** It is recommended to use an AWS Academy or personal AWS account with AdministratorAccess permissions during the lab.

---

#### AWS Region

For consistency throughout the workshop, all AWS resources should be deployed in the same Region.

The recommended Region is:

```text
ap-southeast-1 (Singapore)
```

Using a single Region simplifies resource management and avoids cross-region configuration issues.

![AWS Region](/images/5-Workshop/5.2-Prerequisite/aws-region.png)

---

#### Development Environment

Prepare the following tools before starting the deployment:

+ A modern web browser (Google Chrome or Microsoft Edge)
+ AWS Management Console
+ AWS CLI (optional)
+ Visual Studio Code (optional)
+ Draw.io (for architecture diagrams)

---

#### Required IAM Permissions

The account used in this workshop should have permission to create and manage the following resources:

+ VPC
+ EC2
+ IAM Roles
+ Security Groups
+ S3 Buckets
+ CloudTrail
+ CloudWatch
+ GuardDuty
+ Security Hub
+ Detective
+ EventBridge
+ Step Functions
+ Systems Manager
+ Lambda
+ DynamoDB
+ SNS
+ Cognito
+ API Gateway
+ Amplify Hosting

These permissions are required because the workshop provisions multiple AWS services that interact with one another.

---

#### AWS Services Used

The AWS CloudSOC architecture is built using the following service groups.

| Category | AWS Services |
|----------|--------------|
| Network | Amazon VPC, Public Subnet, Internet Gateway, Amazon EC2, Security Groups |
| Logging | AWS CloudTrail, Amazon CloudWatch, Amazon S3, VPC Flow Logs |
| Detection | Amazon GuardDuty, AWS Security Hub, Amazon Detective |
| Response | Amazon EventBridge, AWS Step Functions, AWS Systems Manager, AWS Lambda |
| Evidence | Amazon S3, Amazon EBS Snapshot, Amazon DynamoDB |
| Dashboard | AWS Amplify Hosting, Amazon Cognito, Amazon API Gateway |
| Notification | Amazon SNS, Amazon Q Developer |
| Governance | AWS IAM, AWS Config, AWS KMS |

![AWS Services](/images/5-Workshop/5.2-Prerequisite/aws-services-overview.png)

---

#### Estimated Cost

This workshop is designed as a Lab / Proof of Concept and aims to minimize AWS usage costs.

However, some services may incur charges depending on usage duration, including:

+ Amazon EC2
+ Amazon EBS Snapshot
+ Amazon S3
+ Amazon CloudWatch Logs
+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective

To avoid unexpected charges, remember to complete the **Resource Cleanup** section after finishing the workshop.

---

#### Before You Begin

Before continuing to the deployment section, verify the following checklist:

- [ ] AWS account is ready.
- [ ] Region is set to **ap-southeast-1**.
- [ ] Required IAM permissions are available.
- [ ] AWS services required for the workshop are accessible.
- [ ] You understand the overall architecture of the AWS CloudSOC system.
- [ ] You are ready to begin the deployment.

The environment is now ready for deploying the AWS CloudSOC architecture.