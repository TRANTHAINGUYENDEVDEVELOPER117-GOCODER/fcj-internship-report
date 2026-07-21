---
title : "Logging and Evidence Storage"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.4.2. </b> "
---

#### Logging and Evidence Storage

In this section, you will configure the **Logging and Evidence Storage** layer for the AWS CloudSOC system. This layer is responsible for collecting logs, storing incident evidence, and preparing data for post-incident investigation.

The collected logs and evidence will be stored in Amazon S3 and Amazon CloudWatch. These data sources help the SOC Analyst analyze incidents, review suspicious behavior, and verify the result of the incident response process.

---

#### Objectives

After completing this section, you will have:

+ An S3 bucket for CloudTrail audit logs.
+ An S3 bucket for forensic evidence.
+ AWS CloudTrail enabled to record management events.
+ Amazon CloudWatch Logs prepared for log storage.
+ VPC Flow Logs enabled to capture network traffic metadata.
+ An AWS KMS key prepared for encryption if required.
+ An S3 folder structure for storing evidence by incident.

---

#### Logging and Evidence Storage Architecture

The following diagram illustrates the Logging and Evidence Storage layer in the AWS CloudSOC system.

![Logging and Evidence Storage](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/logging-evidence-architecture.png)

The main logging and evidence flow is:

```text
CloudTrail → S3 Audit Logs
CloudTrail → CloudWatch Logs
VPC Flow Logs → CloudWatch Logs
Systems Manager → S3 Evidence Bucket
Incident Response Lambda → S3 Evidence Bucket
Incident Response Lambda → CloudWatch Logs
KMS → S3 Encryption
```

---

#### Recommended Configuration

You can use the following configuration values for this workshop:

| Component | Recommended Value |
|---|---|
| Audit Log Bucket | `cloudsoc-audit-logs-<account-id>` |
| Evidence Bucket | `cloudsoc-evidence-<account-id>` |
| CloudTrail Name | `cloudsoc-cloudtrail` |
| CloudWatch Log Group for CloudTrail | `/aws/cloudtrail/cloudsoc` |
| VPC Flow Logs Log Group | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| KMS Alias | `alias/cloudsoc-evidence-key` |
| S3 Evidence Prefix | `incidents/` |
| S3 Forensic Prefix | `forensics/` |

> **Note:** S3 bucket names must be globally unique. Therefore, you should add your Account ID or a random string at the end of each bucket name.

---

#### Step 1: Create an S3 Bucket for Audit Logs

Open the **Amazon S3** service and choose:

```text
Buckets → Create bucket
```

Configure the bucket as follows:

| Field | Value |
|---|---|
| Bucket name | `cloudsoc-audit-logs-<account-id>` |
| AWS Region | `ap-southeast-1` |
| Object Ownership | ACLs disabled |
| Block Public Access | Block all public access |
| Bucket Versioning | Enable |
| Default encryption | SSE-S3 or SSE-KMS |

Then choose **Create bucket**.

This bucket is used to store logs from AWS CloudTrail.

Expected result:

```text
The S3 bucket cloudsoc-audit-logs-<account-id> is created successfully.
```

![Create Audit Logs Bucket](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-audit-logs-bucket.png)

---

#### Step 2: Create an S3 Bucket for Evidence

Next, create a second bucket to store incident evidence and forensic output.

In Amazon S3, choose:

```text
Buckets → Create bucket
```

Configure the bucket as follows:

| Field | Value |
|---|---|
| Bucket name | `cloudsoc-evidence-<account-id>` |
| AWS Region | `ap-southeast-1` |
| Object Ownership | ACLs disabled |
| Block Public Access | Block all public access |
| Bucket Versioning | Enable |
| Default encryption | SSE-S3 or SSE-KMS |

This bucket is used to store:

+ Forensic output from Systems Manager.
+ Incident evidence from Lambda.
+ Snapshot metadata.
+ Incident JSON files.

Expected result:

```text
The S3 bucket cloudsoc-evidence-<account-id> is created successfully.
```

![Create Evidence Bucket](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-evidence-bucket.png)

---

#### Step 3: Create Folder Structure in the Evidence Bucket

Open the bucket:

```text
cloudsoc-evidence-<account-id>
```

Create the following folders or prefixes:

```text
incidents/
forensics/
snapshots/
lambda-output/
```

The purpose of each prefix is shown below:

| Prefix | Purpose |
|---|---|
| `incidents/` | Stores incident information for each finding |
| `forensics/` | Stores output collected by Systems Manager |
| `snapshots/` | Stores metadata related to EBS Snapshots |
| `lambda-output/` | Stores processing results from Lambda |

Expected result:

```text
The evidence bucket has a folder structure ready for evidence storage.
```

![Evidence Bucket Folders](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/evidence-bucket-folders.png)

---

#### Step 4: Create a KMS Key for Evidence Storage

AWS KMS is used to encrypt sensitive data in S3 if required. In a lab environment, you can use SSE-S3 to simplify the setup. However, to make the security architecture more complete, you should prepare a dedicated KMS key for the evidence bucket.

Open the **AWS KMS** service and choose:

```text
Customer managed keys → Create key
```

Configure the key:

| Field | Value |
|---|---|
| Key type | Symmetric |
| Key usage | Encrypt and decrypt |
| Alias | `alias/cloudsoc-evidence-key` |
| Key administrators | Select the user or role that manages the key |
| Key users | Select the roles that need to use the key |

The roles that may need permission to use the KMS key include:

+ Incident Response Lambda Role
+ Step Functions Workflow Role
+ EC2 SSM Instance Role

Expected result:

```text
The KMS key alias/cloudsoc-evidence-key is created successfully.
```

![Create KMS Key](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-kms-key.png)

---

#### Step 5: Enable CloudTrail

AWS CloudTrail is used to record management events in the AWS account. These events help the SOC Analyst understand who performed an action, what action was performed, which resource was affected, and when it happened.

Open the **AWS CloudTrail** service and choose:

```text
Trails → Create trail
```

Configure the trail:

| Field | Value |
|---|---|
| Trail name | `cloudsoc-cloudtrail` |
| Storage location | Use existing S3 bucket |
| S3 bucket | `cloudsoc-audit-logs-<account-id>` |
| Log file SSE-KMS encryption | Enable if using KMS |
| CloudWatch Logs | Enable |
| Log group | `/aws/cloudtrail/cloudsoc` |

In the **Events** section, choose:

```text
Management events
```

Select:

```text
Read
Write
```

Then choose **Create trail**.

Expected result:

```text
The cloudsoc-cloudtrail trail is enabled and sends logs to S3 and CloudWatch.
```

![Create CloudTrail](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-cloudtrail.png)

---

#### Step 6: Verify CloudTrail Logs in S3

After enabling CloudTrail, wait a few minutes for logs to be delivered to S3.

Open the bucket:

```text
cloudsoc-audit-logs-<account-id>
```

Check the CloudTrail log folder:

```text
AWSLogs/
```

Inside this folder, logs are organized by account, region, and date.

Expected result:

```text
CloudTrail log files appear in the S3 audit logs bucket.
```

![CloudTrail Logs in S3](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/cloudtrail-logs-s3.png)

---

#### Step 7: Create a CloudWatch Log Group for VPC Flow Logs

Open the **Amazon CloudWatch** service and choose:

```text
Logs → Log groups → Create log group
```

Configure the log group:

| Field | Value |
|---|---|
| Log group name | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| Retention setting | 7 days or 14 days |

Choose **Create**.

Expected result:

```text
The CloudWatch Log Group for VPC Flow Logs is created successfully.
```

![Create VPC Flow Logs Log Group](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/vpc-flowlogs-cloudwatch.png)

---

#### Step 8: Enable VPC Flow Logs

VPC Flow Logs are used to capture metadata about network traffic in the VPC. In this workshop, logs are sent to CloudWatch Logs for easy observation.

Open the **VPC** service and choose:

```text
Your VPCs → cloudsoc-vpc → Flow logs
```

Choose:

```text
Create flow log
```

Configure the flow log:

| Field | Value |
|---|---|
| Name | `cloudsoc-vpc-flowlogs` |
| Filter | All |
| Maximum aggregation interval | 1 minute |
| Destination | Send to CloudWatch Logs |
| Destination log group | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| IAM role | Role that allows VPC Flow Logs to write to CloudWatch |

If you do not already have an IAM Role for VPC Flow Logs, create a new role by following the AWS Console instructions.

Expected result:

```text
VPC Flow Logs are enabled for cloudsoc-vpc and sent to CloudWatch Logs.
```

![Create VPC Flow Logs](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-vpc-flowlogs.png)

---

#### Step 9: Verify VPC Flow Logs in CloudWatch

After enabling VPC Flow Logs, wait a few minutes and open:

```text
CloudWatch → Logs → Log groups
```

Select the log group:

```text
/aws/vpc-flowlogs/cloudsoc-vpc
```

Check whether log streams have been created.

Expected result:

```text
VPC Flow Logs appear in CloudWatch Logs.
```

![VPC Flow Logs in CloudWatch](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/vpc-flowlogs-cloudwatch.png)

---

#### Step 10: Prepare Storage for Forensic Output from Systems Manager

In later sections, Systems Manager will run commands on the EC2 instance to collect forensic evidence. The command output can be stored in the S3 evidence bucket.

Recommended path for forensic output:

```text
s3://cloudsoc-evidence-<account-id>/forensics/
```

When using Systems Manager Run Command, configure the output as follows:

| Field | Value |
|---|---|
| S3 bucket name | `cloudsoc-evidence-<account-id>` |
| S3 key prefix | `forensics/` |
| CloudWatch output | Enable if required |

Expected result:

```text
The S3 evidence bucket is ready to store forensic output from Systems Manager.
```

---

#### Step 11: Prepare Storage for Incident Evidence from Lambda

The Incident Response Lambda function will store incident processing results in the S3 evidence bucket.

Recommended path for incident evidence:

```text
s3://cloudsoc-evidence-<account-id>/incidents/
```

Example incident-based evidence structure:

```text
incidents/
└── finding-id/
    ├── finding.json
    ├── response-result.json
    ├── isolation-status.json
    └── snapshot-metadata.json
```

Expected result:

```text
The S3 evidence bucket is ready to store incident evidence from Lambda.
```

---

#### Step 12: Prepare CloudWatch Logs for Lambda

In later sections, when Lambda functions are created and executed, CloudWatch will automatically create the corresponding log groups.

Lambda log groups usually follow this format:

```text
/aws/lambda/<lambda-function-name>
```

Examples:

```text
/aws/lambda/cloudsoc-incident-response-lambda
/aws/lambda/cloudsoc-dashboard-api-lambda
```

These logs are used to check:

+ Whether Lambda was invoked.
+ Whether Lambda processed the finding successfully.
+ Whether Lambda has permission errors.
+ Whether Lambda updated DynamoDB or S3 successfully.

Expected result:

```text
CloudWatch Logs are ready to store Lambda execution logs.
```

---

#### Completion Checklist

After completing this section, verify the following items:

- [ ] S3 bucket `cloudsoc-audit-logs-<account-id>` is created.
- [ ] S3 bucket `cloudsoc-evidence-<account-id>` is created.
- [ ] Block Public Access is enabled for both buckets.
- [ ] Bucket Versioning is enabled for important buckets.
- [ ] The evidence bucket has the prefixes `incidents/`, `forensics/`, `snapshots/`, and `lambda-output/`.
- [ ] KMS key `alias/cloudsoc-evidence-key` is created if SSE-KMS is used.
- [ ] CloudTrail `cloudsoc-cloudtrail` is enabled.
- [ ] CloudTrail writes logs to the S3 audit logs bucket.
- [ ] CloudTrail can send logs to CloudWatch Logs.
- [ ] VPC Flow Logs are enabled for `cloudsoc-vpc`.
- [ ] VPC Flow Logs send logs to CloudWatch Logs.
- [ ] The evidence bucket is ready to receive forensic output from Systems Manager.
- [ ] The evidence bucket is ready to receive incident evidence from Lambda.

---

#### Completion Result

After completing this section, the AWS CloudSOC system has a logging and evidence storage foundation.

The following components are now ready:

```text
CloudTrail
Amazon S3
Amazon CloudWatch Logs
VPC Flow Logs
AWS KMS
Evidence folder structure
```

This layer allows the system to store audit logs, network flow logs, and incident evidence. These data sources are important for SOC Analysts to investigate, verify, and report incidents.

---

#### Summary

In this section, you configured the components required for logging and evidence storage in AWS CloudSOC. CloudTrail records management events, VPC Flow Logs capture network traffic metadata, CloudWatch Logs supports log monitoring, and Amazon S3 stores audit logs and forensic evidence.

In the next section, you will enable **Threat Detection Services** such as Amazon GuardDuty, AWS Security Hub, Amazon Detective, and AWS Config to detect and analyze threats in the AWS environment.