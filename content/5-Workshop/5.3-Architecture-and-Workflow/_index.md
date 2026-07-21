---
title : "Architecture and Workflow"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Architecture and Workflow

This section presents the overall architecture and main workflow of the **AWS CloudSOC** system. The architecture is designed to simulate a Security Operations Center (SOC) on AWS that can detect threats, orchestrate incident response, collect evidence, isolate affected resources, and notify the SOC Analyst.

The system follows an **event-driven** and **serverless** architecture. Security findings from Amazon GuardDuty trigger the incident response workflow through Amazon EventBridge and AWS Step Functions.

---

#### Overall Architecture

The following diagram shows the overall architecture of the AWS CloudSOC system.

![AWS CloudSOC Architecture](/images/5-Workshop/5.3-Architecture-and-Workflow/cloudsoc-architecture.png)

The architecture is divided into the following main groups:

+ **Network and Workload**
+ **Logging and Evidence Storage**
+ **Threat Detection and Response**
+ **SOC Dashboard and Access**
+ **Security, Governance, and Notification**

Each group has a specific role in the overall process of threat detection, investigation, response, and notification.

---

#### Network and Workload Group

The Network and Workload group is where the target resource is deployed for security testing.

The main components include:

+ Amazon VPC
+ Public Subnet
+ Internet Gateway
+ Amazon EC2
+ SG-Workload
+ SG-Isolation

In this workshop, an Amazon EC2 instance is deployed in a Public Subnet to simplify attack simulation and GuardDuty finding testing.

The EC2 instance is initially attached to a security group named `SG-Workload`. This security group is used for normal workload operation. When the system determines that the EC2 instance needs to be isolated, AWS Lambda replaces `SG-Workload` with `SG-Isolation`.

`SG-Isolation` is a pre-created security group in the VPC with no inbound or outbound rules. This helps isolate the affected EC2 instance from new network connections.

> **Note:** AWS Security Groups are stateful. Isolation using a security group mainly blocks new connections and reduces the impact scope of the incident.

---

#### Logging and Evidence Storage Group

The Logging and Evidence Storage group is responsible for log collection, evidence storage, and post-incident investigation support.

The main components include:

+ AWS CloudTrail
+ Amazon CloudWatch
+ VPC Flow Logs
+ Amazon S3
+ Amazon EBS Snapshot
+ AWS KMS

The logging and evidence flow in the system is:

```text
CloudTrail â†’ S3
CloudTrail â†’ CloudWatch
VPC Flow Logs â†’ CloudWatch
Systems Manager â†’ S3
Systems Manager â†’ EBS Snapshot
Incident Response Lambda â†’ S3
Incident Response Lambda â†’ CloudWatch
KMS â†’ S3
```

The role of each component:

+ **AWS CloudTrail** records management events in the AWS account.
+ **Amazon CloudWatch** stores logs, metrics, and alarms.
+ **VPC Flow Logs** capture network traffic metadata in the VPC.
+ **Amazon S3** stores audit logs, forensic output, and incident evidence.
+ **Amazon EBS Snapshot** preserves the EC2 disk state for investigation.
+ **AWS KMS** supports encryption for data stored in S3 when configured.

---

#### Threat Detection and Response Group

The Threat Detection and Response group is the core part of the AWS CloudSOC system.

The main components include:

+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ Amazon EventBridge
+ AWS Step Functions
+ AWS Systems Manager
+ AWS Lambda

The incident detection and response flow is:

```text
GuardDuty
â†’ EventBridge
â†’ Step Functions
â†’ Systems Manager / Lambda
â†’ Evidence Storage / Isolation / Notification
```

When GuardDuty detects suspicious activity, it creates a security finding. The finding is sent to EventBridge, which triggers the Step Functions workflow.

Step Functions orchestrates the entire incident response process, including:

+ Checking the affected resource type
+ Checking the Instance ID
+ Checking the severity level
+ Checking the `AutoIsolate=true` tag
+ Determining the response mode
+ Sending an approval request if required
+ Collecting forensic evidence
+ Creating an EBS Snapshot
+ Isolating the EC2 instance
+ Sending the final notification

Amazon Detective and AWS Security Hub support the SOC Analyst during the finding analysis and investigation process.

---

#### SOC Dashboard and Access Group

The SOC Dashboard and Access group provides an interface for the SOC Analyst to monitor incidents and approve response actions.

The main components include:

+ AWS Amplify Hosting
+ Amazon Cognito
+ Amazon API Gateway
+ Dashboard API Lambda
+ Amazon DynamoDB
+ Amazon S3
+ AWS Step Functions

The dashboard flow is:

```text
SOC Analyst
â†’ AWS Amplify Hosting
â†’ Amazon Cognito
â†’ Amazon API Gateway
â†’ Dashboard API Lambda
â†’ Amazon DynamoDB / Amazon S3
â†’ AWS Step Functions Approval Callback
```

The role of each component:

+ **AWS Amplify Hosting** hosts the SOC Dashboard frontend.
+ **Amazon Cognito** authenticates the SOC Analyst before accessing the dashboard.
+ **Amazon API Gateway** provides the HTTPS API for the dashboard.
+ **Dashboard API Lambda** processes requests from the dashboard.
+ **Amazon DynamoDB** stores incident information and response status.
+ **Amazon S3** stores evidence and forensic output.
+ **AWS Step Functions** receives the approval callback from the dashboard.

The SOC Dashboard does not access DynamoDB or S3 directly. All actions such as reading incidents, viewing evidence, or submitting approval decisions go through API Gateway and Lambda.

---

#### Security, Governance, and Notification Group

This group is responsible for access control, configuration tracking, encryption, and alert delivery.

The main components include:

+ AWS IAM
+ AWS Config
+ AWS KMS
+ Amazon SNS
+ Amazon Q Developer
+ Slack
+ Email / SMS

The role of each component:

+ **AWS IAM** manages permissions and execution roles for AWS services.
+ **AWS Config** tracks configuration changes of EC2, Security Groups, and related resources.
+ **AWS KMS** supports encryption for sensitive data.
+ **Amazon SNS** sends alerts and incident response results.
+ **Amazon Q Developer** can be used to forward notifications to Slack.
+ **Email / SMS** allows the SOC Analyst to receive alerts quickly.

The main IAM roles in the system include:

+ Dashboard Lambda Role
+ Incident Response Lambda Role
+ Step Functions Workflow Role
+ EC2 SSM Instance Role

These roles ensure that each service only has the required permissions to perform its specific function.

---

#### Main Workflow

The following diagram illustrates the main workflow of the AWS CloudSOC system.

![AWS CloudSOC Main Workflow](/images/5-Workshop/5.3-Architecture-and-Workflow/cloudsoc-main-workflow.png)

The main workflow includes the following steps:

```text
1. Threat activity occurs on EC2
2. GuardDuty detects suspicious behavior
3. GuardDuty generates a finding
4. EventBridge receives the finding
5. EventBridge starts Step Functions workflow
6. Step Functions evaluates the finding
7. Step Functions requests approval or starts response
8. Systems Manager collects forensic evidence
9. EBS Snapshot is created
10. Lambda replaces EC2 security group with SG-Isolation
11. Incident status is updated in DynamoDB
12. Evidence is stored in S3
13. SNS sends notification to SOC Analyst
```

---

#### Workflow Details

##### Step 1: Suspicious Activity Occurs

Suspicious activity occurs on the EC2 instance, for example:

+ Port scanning
+ SSH brute-force
+ Suspicious IP communication
+ Abnormal API activity

The EC2 instance in this workshop is used as the target workload to simulate these security scenarios.

---

##### Step 2: GuardDuty Detects the Threat

Amazon GuardDuty analyzes AWS-managed telemetry sources such as:

+ CloudTrail management events
+ VPC Flow Logs
+ DNS logs

When abnormal behavior is detected, GuardDuty generates a security finding.

---

##### Step 3: EventBridge Triggers the Workflow

The GuardDuty finding is sent to Amazon EventBridge. EventBridge uses a configured rule to filter matching findings and trigger AWS Step Functions.

```text
GuardDuty Finding â†’ EventBridge Rule â†’ Step Functions
```

---

##### Step 4: Step Functions Evaluates the Finding

AWS Step Functions checks important information from the finding:

+ Resource Type
+ Instance ID
+ Severity
+ AutoIsolate Tag
+ Response Mode

Based on the evaluation result, the workflow selects one of the following response branches:

```text
Alert Only
Approval Required
Auto Response
```

---

##### Step 5: Apply the Response Policy

The system response policy is:

```text
Non-EC2 Finding        â†’ Alert Only
Low / Medium Severity  â†’ Dry Run
High Severity          â†’ Request Approval
Critical Severity      â†’ Auto Response
Reject / Timeout       â†’ End Workflow
```

For High severity findings, the system requires SOC Analyst approval before isolating the EC2 instance.

For Critical severity findings with the `AutoIsolate=true` tag, the system can automatically execute the response action.

---

##### Step 6: Collect Forensic Evidence

AWS Systems Manager is used to run commands on the EC2 instance to collect information for investigation.

Forensic information may include:

+ Running processes
+ Network connections
+ Logged-in users
+ System logs
+ Security logs
+ Instance metadata

The collected output is stored in Amazon S3.

---

##### Step 7: Create an EBS Snapshot

Before isolation or further response actions, the system creates an Amazon EBS Snapshot to preserve the disk state of the EC2 instance.

This snapshot can be used for:

+ Forensic investigation
+ Data recovery
+ Post-incident analysis
+ Evidence preservation

---

##### Step 8: Isolate the EC2 Instance

AWS Lambda performs the isolation action by replacing the current security group of the EC2 instance.

```text
SG-Workload â†’ SG-Isolation
```

`SG-Isolation` does not allow inbound or outbound traffic. This helps prevent the EC2 instance from continuing to communicate with other systems.

---

##### Step 9: Update the Incident Record

After the response action is completed, Lambda updates the incident status in Amazon DynamoDB.

The stored information may include:

+ Incident ID
+ Finding ID
+ Instance ID
+ Severity
+ Response action
+ Approval status
+ Isolation status
+ Snapshot ID
+ Evidence S3 path
+ Timestamp

---

##### Step 10: Send Notification

Amazon SNS sends notifications to the SOC Analyst when the workflow is completed or when approval is required.

Notifications can be sent through:

+ Email
+ SMS
+ Slack through Amazon Q Developer

The notification content includes incident details, severity level, affected resource, and response result.

---

#### SOC Analyst Approval Flow

For High severity findings, the system does not isolate the EC2 instance immediately. Instead, the SOC Analyst reviews the incident information on the dashboard.

The approval flow is:

```text
SOC Analyst
â†’ SOC Dashboard
â†’ Review Incident
â†’ Approve / Reject
â†’ Step Functions Callback
â†’ Continue or End Workflow
```

If the SOC Analyst approves the action, the workflow continues to collect evidence, create a snapshot, and isolate the EC2 instance.

If the SOC Analyst rejects the action or the approval times out, the workflow ends and records the incident status.

---

#### Architecture Workflow Summary

The following table summarizes the role of each group in the AWS CloudSOC architecture.

| Group | Function |
|------|-----------|
| Network and Workload | Deploys the target EC2 instance and security groups for isolation |
| Logging and Evidence Storage | Collects logs, stores evidence, and creates snapshots for investigation |
| Threat Detection and Response | Detects findings and orchestrates incident response |
| SOC Dashboard and Access | Provides incident visibility and approval capability |
| Security, Governance, and Notification | Manages permissions, tracks configuration changes, and sends alerts |

This architecture simulates a basic SOC workflow on AWS, where detection, investigation, response, and notification are automated in a controlled manner.