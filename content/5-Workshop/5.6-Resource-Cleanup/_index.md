---
title : "Resource Cleanup"
date : 2026-07-01
weight : 6
chapter : false
pre : " <b> 5.6. </b> "
---

#### Resource Cleanup

In this section, you will clean up the AWS resources created during the **AWS CloudSOC** workshop to avoid unnecessary costs after completing the lab.

During the deployment and testing phases, the system used multiple AWS services such as EC2, S3, Lambda, Step Functions, EventBridge, DynamoDB, SNS, CloudWatch, GuardDuty, Security Hub, Detective, AWS Config, API Gateway, Cognito, and Amplify. Some of these services may continue to generate costs if they keep running or storing data after the workshop.

Therefore, after completing **5.5 Testing and Validation**, you should clean up the resources in the correct order.

---

#### Cleanup Objectives

After completing this section, you will:

+ Disable or delete event triggers to stop automatic processing.
+ Delete Lambda functions that are no longer needed.
+ Delete EventBridge rules and Step Functions state machines.
+ Delete the dashboard, API Gateway, Cognito, and Amplify app.
+ Delete SNS topics, subscriptions, and CloudWatch alarms.
+ Delete S3 buckets used for logs and evidence if they are no longer required.
+ Delete EBS snapshots created during forensic testing.
+ Terminate the EC2 workload instance.
+ Delete Security Groups, Route Tables, Internet Gateway, Subnet, and VPC.
+ Disable GuardDuty, Security Hub, Detective, and AWS Config if they are no longer needed.
+ Delete IAM roles and policies created specifically for this lab.

---

#### Cleanup Process Overview

The following diagram shows the recommended cleanup order for the CloudSOC workshop.

![Resource Cleanup Overview](/images/5-Workshop/5.6-Resource-Cleanup/resource-cleanup-overview.png)

The general cleanup flow is:

```text
Stop Event Triggers
→ Delete Workflow Resources
→ Delete Dashboard Resources
→ Delete Alerting Resources
→ Delete Evidence and Logs
→ Delete Compute and Network
→ Disable Security Services
→ Remove IAM Roles
```

This order helps prevent one service from continuing to invoke another service while resources are being removed.

---

#### Notes Before Deleting Resources

Before deleting resources, make sure all screenshots, logs, and evidence required for the report have already been saved.

The following evidence should be checked before cleanup:

```text
GuardDuty findings screenshots
Step Functions execution screenshots
Lambda execution results
Systems Manager command output
S3 evidence screenshots
EBS snapshot screenshots
DynamoDB incident records
Dashboard screenshots
Email / Slack alert screenshots
CloudWatch Alarm screenshots
```

If you need to keep evidence for the report, download important files from S3 before deleting the bucket.

---

#### Step 1: Disable the EventBridge Rule

First, disable or delete the EventBridge rule so the system does not continue triggering the workflow when new GuardDuty findings are generated.

The rule used in this lab is:

```text
cloudsoc-guardduty-finding-rule
```

Go to:

```text
Amazon EventBridge
→ Rules
→ cloudsoc-guardduty-finding-rule
```

Disable the rule by selecting:

```text
Disable
```

or delete it if it is no longer needed:

```text
Delete
```

![Disable EventBridge Rule](/images/5-Workshop/5.6-Resource-Cleanup/disable-eventbridge-rule.png)

After the rule is disabled or deleted, new GuardDuty findings will no longer automatically trigger the Step Functions workflow.

---

#### Step 2: Delete the Step Functions State Machine

Next, delete the Step Functions state machine used to orchestrate the incident response workflow.

The state machine used in this lab is:

```text
cloudsoc-incident-response-workflow
```

Go to:

```text
AWS Step Functions
→ State machines
→ cloudsoc-incident-response-workflow
```

Select:

```text
Delete
```

![Delete Step Functions Workflow](/images/5-Workshop/5.6-Resource-Cleanup/delete-stepfunctions-workflow.png)

Deleting the state machine removes the incident response orchestration workflow after the workshop is completed.

---

#### Step 3: Delete Lambda Functions

Delete the Lambda functions created during the workshop.

The Lambda functions usually include:

```text
cloudsoc-incident-response-lambda
cloudsoc-dashboard-api-lambda
```

Go to:

```text
AWS Lambda
→ Functions
```

Select each function and delete it:

```text
Actions → Delete
```

![Delete Lambda Functions](/images/5-Workshop/5.6-Resource-Cleanup/delete-lambda-functions.png)

These Lambda functions are no longer required after the workflow and dashboard have been removed.

---

#### Step 4: Delete Dashboard Resources

The dashboard layer uses Amplify, API Gateway, Cognito, Dashboard API Lambda, and DynamoDB.

The resources to clean up include:

```text
AWS Amplify App
API Gateway
Cognito User Pool
Dashboard API Lambda
DynamoDB Incident Table
```

##### Delete the Amplify App

Go to:

```text
AWS Amplify
→ cloudsoc-soc-dashboard
→ App settings
→ General settings
→ Delete app
```

![Delete Amplify Dashboard](/images/5-Workshop/5.6-Resource-Cleanup/delete-amplify-dashboard.png)

##### Delete API Gateway

Go to:

```text
Amazon API Gateway
→ APIs
→ CloudSOC Dashboard API
→ Delete
```

![Delete API Gateway](/images/5-Workshop/5.6-Resource-Cleanup/delete-api-gateway.png)

##### Delete the Cognito User Pool

Go to:

```text
Amazon Cognito
→ User pools
→ CloudSOC user pool
→ Delete
```

![Delete Cognito User Pool](/images/5-Workshop/5.6-Resource-Cleanup/delete-cognito-user-pool.png)

##### Delete the DynamoDB Incident Table

Go to:

```text
DynamoDB
→ Tables
→ CloudSOC-IncidentTable
→ Delete table
```

![Delete DynamoDB Incident Table](/images/5-Workshop/5.6-Resource-Cleanup/delete-dynamodb-table.png)

Before deleting DynamoDB, make sure the incident records required for the report have already been captured or exported.

---

#### Step 5: Delete SNS Topic and Subscriptions

Next, delete the notification layer.

The SNS Topic used in this lab is:

```text
cloudsoc-incident-alerts
```

Go to:

```text
Amazon SNS
→ Topics
→ cloudsoc-incident-alerts
```

Delete the subscriptions if needed:

```text
Subscriptions → Delete
```

Then delete the topic:

```text
Delete topic
```

![Delete SNS Topic](/images/5-Workshop/5.6-Resource-Cleanup/delete-sns-topic.png)

If Slack notification was configured through Amazon Q Developer in chat applications, delete the related channel configuration as well.

![Delete Slack Channel Configuration](/images/5-Workshop/5.6-Resource-Cleanup/delete-slack-channel-configuration.png)

---

#### Step 6: Delete CloudWatch Alarms and Log Groups

In this workshop, CloudWatch is used to store logs and monitor Lambda errors.

The resources to check include:

```text
CloudWatch Alarms
Lambda log groups
CloudTrail log group
VPC Flow Logs log group
Step Functions log group
```

Go to:

```text
CloudWatch
→ Alarms
→ All alarms
```

Delete the alarm:

```text
cloudsoc-incident-response-lambda-errors
```

![Delete CloudWatch Alarm](/images/5-Workshop/5.6-Resource-Cleanup/delete-cloudwatch-alarm.png)

Then go to:

```text
CloudWatch
→ Logs
→ Log groups
```

Delete the related log groups if they are no longer needed:

```text
/aws/lambda/cloudsoc-incident-response-lambda
/aws/lambda/cloudsoc-dashboard-api-lambda
/aws/cloudtrail/cloudsoc
/aws/vpc-flowlogs/cloudsoc-vpc
/aws/states/cloudsoc-incident-response-workflow
```

![Delete CloudWatch Log Groups](/images/5-Workshop/5.6-Resource-Cleanup/delete-cloudwatch-log-groups.png)

---

#### Step 7: Delete S3 Buckets and Evidence

S3 is used in this workshop to store audit logs and incident evidence.

The buckets usually include:

```text
cloudsoc-audit-logs-<account-id>
cloudsoc-evidence-<account-id>
```

Go to:

```text
Amazon S3
→ Buckets
```

Before deleting a bucket, empty it first:

```text
Empty bucket
→ Delete bucket
```

![Delete S3 Evidence Bucket](/images/5-Workshop/5.6-Resource-Cleanup/delete-s3-evidence-bucket.png)

The objects to check before deletion include:

```text
CloudTrail logs
raw-event.json
response-summary.json
SSM command output
forensic evidence
```

If the evidence is required for the report, download the important files before deleting the bucket.

---

#### Step 8: Delete EBS Forensic Snapshots

During auto isolation testing, Lambda created EBS snapshots for forensic investigation.

Go to:

```text
EC2
→ Elastic Block Store
→ Snapshots
```

Find snapshots with tags or descriptions related to:

```text
Project = AWS-CloudSOC
Purpose = Forensics
IncidentId = INC-sample-finding-001
```

Select the snapshot and delete it:

```text
Actions → Delete snapshot
```

![Delete EBS Forensic Snapshot](/images/5-Workshop/5.6-Resource-Cleanup/delete-ebs-forensic-snapshot.png)

EBS snapshots may generate storage costs, so they should be deleted if they are no longer needed.

---

#### Step 9: Terminate the EC2 Workload

After saving evidence and deleting unnecessary snapshots, terminate the EC2 workload instance.

The EC2 instance used in this lab is:

```text
cloudsoc-workload-ec2
```

Go to:

```text
EC2
→ Instances
→ cloudsoc-workload-ec2
```

Select:

```text
Instance state
→ Terminate instance
```

![Terminate EC2 Workload](/images/5-Workshop/5.6-Resource-Cleanup/terminate-ec2-workload.png)

After termination, confirm that the instance state changes to:

```text
Terminated
```

---

#### Step 10: Delete Security Groups

After the EC2 instance has been terminated, delete the Security Groups created for the lab.

The Security Groups usually include:

```text
SG-Workload
SG-Isolation
```

Go to:

```text
EC2
→ Security Groups
```

Select each security group and delete it:

```text
Actions → Delete security groups
```

![Delete Security Groups](/images/5-Workshop/5.6-Resource-Cleanup/delete-security-groups.png)

Note: A Security Group cannot be deleted if it is still attached to a resource. If deletion fails, check whether any EC2 instance, network interface, or related resource is still using it.

---

#### Step 11: Delete Network Resources

After EC2 and Security Groups have been removed, delete the network resources.

The resources to delete include:

```text
Public Route Table
Public Subnet
Internet Gateway
VPC
```

The recommended order is:

```text
Detach Internet Gateway
Delete Internet Gateway
Delete Subnet
Delete Route Table
Delete VPC
```

![Delete Network Resources](/images/5-Workshop/5.6-Resource-Cleanup/delete-network-resources.png)

The network resources in this lab may include:

```text
cloudsoc-vpc
cloudsoc-public-subnet
cloudsoc-public-rtb
cloudsoc-igw
```

---

#### Step 12: Disable Security Services If They Are No Longer Needed

Security services such as GuardDuty, Security Hub, Detective, and AWS Config may continue to generate costs depending on the configuration and amount of data processed.

The services to check include:

```text
Amazon GuardDuty
AWS Security Hub
Amazon Detective
AWS Config
```

Go to each service and disable it if it is no longer needed for the lab.

![Disable Security Services](/images/5-Workshop/5.6-Resource-Cleanup/disable-security-services.png)

Note: Only disable these services if the AWS account is used for the lab only. If the account is also used for other security monitoring purposes, review carefully before disabling them.

---

#### Step 13: Delete IAM Roles and Policies

Finally, delete the IAM roles and policies created specifically for the workshop.

The roles may include:

```text
CloudSOC-EC2-SSM-Role
CloudSOC-Incident-Response-Lambda-Role
CloudSOC-Dashboard-API-Lambda-Role
CloudSOC-EventBridge-StepFunctions-Role
CloudSOC-CloudTrail-CloudWatch-Role
CloudSOC-VPCFlowLogs-Role
CloudSOC-QDeveloper-ChatOps-Role
```

Go to:

```text
IAM
→ Roles
```

Select the roles that are no longer used and delete them.

![Delete IAM Roles](/images/5-Workshop/5.6-Resource-Cleanup/delete-iam-roles.png)

Before deleting a role, make sure it is no longer attached to EC2, Lambda, EventBridge, or any other AWS service.

---

#### Cleanup Checklist

The following table summarizes the resources that should be cleaned up after the workshop.

| Resource Group | Resources to Delete or Disable | Status |
|---|---|---|
| Event Routing | EventBridge Rule | Deleted / Disabled |
| Workflow | Step Functions State Machine | Deleted |
| Compute | Lambda Functions, EC2 Instance | Deleted / Terminated |
| Dashboard | Amplify, API Gateway, Cognito | Deleted |
| Database | DynamoDB Incident Table | Deleted |
| Notification | SNS Topic, Email Subscription, Slack Configuration | Deleted |
| Monitoring | CloudWatch Alarm, Log Groups | Deleted |
| Storage | S3 Audit Logs, S3 Evidence Bucket | Deleted |
| Forensics | EBS Snapshots | Deleted |
| Network | Security Groups, Subnet, Route Table, IGW, VPC | Deleted |
| Security Services | GuardDuty, Security Hub, Detective, AWS Config | Disabled if not needed |
| IAM | CloudSOC Roles and Policies | Deleted |

---

#### Post-Cleanup Verification

After deleting the resources, check the main AWS Console areas again:

```text
EC2 Instances
EBS Snapshots
S3 Buckets
Lambda Functions
Step Functions
EventBridge Rules
DynamoDB Tables
SNS Topics
CloudWatch Alarms
Amplify Apps
API Gateway APIs
Cognito User Pools
IAM Roles
```

The goal is to confirm that no lab resources are still running or generating costs.

![Final Cleanup Check](/images/5-Workshop/5.6-Resource-Cleanup/final-cleanup-check.png)

---

#### Expected Result

After completing the cleanup section, the expected results are:

| Item | Expected Result |
|---|---|
| EventBridge | Rule has been disabled or deleted |
| Step Functions | State machine has been deleted |
| Lambda | Lab functions have been deleted |
| EC2 | Workload instance has been terminated |
| EBS Snapshot | Forensic snapshot has been deleted |
| S3 | Log and evidence buckets have been emptied and deleted |
| DynamoDB | Incident table has been deleted |
| SNS | Topic and subscriptions have been deleted |
| CloudWatch | Unnecessary alarms and log groups have been deleted |
| Dashboard | Amplify app, API Gateway, and Cognito have been deleted |
| Network | VPC, subnet, IGW, route table, and security groups have been deleted |
| Security Services | Security services have been disabled if no longer used |
| IAM | Lab-specific roles and policies have been deleted |

---

#### Summary

Section 5.6 completed the resource cleanup process for the **AWS CloudSOC** workshop.

Cleaning up resources helps avoid unnecessary costs and keeps the AWS account organized after finishing the lab.

After completing this section, the full workshop has covered the complete lifecycle:

```text
Design Architecture
→ Deploy CloudSOC System
→ Test and Validate
→ Resource Cleanup
```

The final result is a complete AWS CloudSOC lab model that can detect findings, orchestrate workflows, support approval, automatically isolate EC2, store evidence, send alerts, and clean up resources after use.