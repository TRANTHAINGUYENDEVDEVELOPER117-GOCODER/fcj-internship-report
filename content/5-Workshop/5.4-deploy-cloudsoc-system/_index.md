---
title : "Deploy CloudSOC System"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

#### Deploy CloudSOC System

In this section, you will deploy the complete **AWS CloudSOC** system based on the architecture designed in the previous section. This is the main deployment section of the workshop, where security monitoring, incident response orchestration, evidence storage, dashboard approval, and alerting components are configured into a complete system.

The goal of section 5.4 is to build a **Security Operations Center on AWS** that can detect threats, investigate incidents, perform automated response actions, store forensic evidence, and notify the SOC Analyst.

The overall system process is:

```text
Detect → Investigate → Respond → Store Evidence → Notify
```

The system is implemented using a **serverless** and **event-driven** architecture. The main AWS services include Amazon GuardDuty, AWS Security Hub, Amazon EventBridge, AWS Step Functions, AWS Lambda, AWS Systems Manager, Amazon S3, Amazon DynamoDB, Amazon SNS, and Amazon CloudWatch.

---

#### Deployment Objectives

After completing this section, the CloudSOC system will be able to:

+ Create a basic network environment for the workload EC2 instance.
+ Capture logs and store evidence for investigation.
+ Enable threat detection services such as GuardDuty, Security Hub, Detective, and AWS Config.
+ Use EventBridge to receive security findings.
+ Use Step Functions to orchestrate the incident response workflow.
+ Build a dashboard for SOC Analysts to view incidents and approve response actions.
+ Automatically collect forensic evidence.
+ Create EBS Snapshots for post-incident investigation.
+ Isolate a suspected EC2 instance using `SG-Isolation`.
+ Send alerts through SNS, Email, and optional Slack integration.

---

#### Deployment Overview

The following diagram shows the overall deployment flow of the CloudSOC system.

![CloudSOC Deployment Flow](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/deployment-flow.png)

The overall deployment flow is:

```text
Network and EC2
→ Logging and Evidence Storage
→ Threat Detection Services
→ EventBridge and Step Functions
→ Dashboard and Approval Flow
→ Forensics, Snapshot and Isolation
→ Notification and Alerting
```

Each subsection in 5.4 deploys a specific group of components. When combined, these components form a complete SOC workflow on AWS.

---

#### Deployment Sections in 5.4

Section 5.4 is divided into seven subsections. You should deploy them in the following order to make sure all services are connected correctly.

| Section | Content | Role in the System |
|---|---|---|
| [5.4.1 Network and EC2 Workload](./5.4.1-network-and-ec2/) | Create VPC, subnet, EC2, IAM Role, and Security Groups | Prepare the workload for monitoring and isolation |
| [5.4.2 Logging and Evidence Storage](./5.4.2-logging-and-evidence-storage/) | Create S3 buckets, CloudTrail, and VPC Flow Logs | Store logs and evidence for investigation |
| [5.4.3 Threat Detection Services](./5.4.3-threat-detection-services/) | Enable GuardDuty, Security Hub, Detective, and AWS Config | Detect and investigate threats |
| [5.4.4 EventBridge and Step Functions](./5.4.4-eventbridge-and-step-functions/) | Create EventBridge Rule and Step Functions workflow | Orchestrate the incident response workflow |
| [5.4.5 Dashboard and Approval Flow](./5.4.5-dashboard-and-approval-flow/) | Create DynamoDB, Cognito, API Gateway, Lambda, and Amplify Dashboard | Allow SOC Analysts to view and approve incidents |
| [5.4.6 Forensics, Snapshot and Isolation](./5.4.6-forensics-snapshot-and-isolation/) | Create Incident Response Lambda, SSM, EBS Snapshot, and SG-Isolation | Collect evidence, create snapshots, and isolate EC2 |
| [5.4.7 Notification and Alerting](./5.4.7-notification-and-alerting/) | Create SNS, Email alert, CloudWatch Alarm, and optional Slack integration | Send alerts to SOC Analysts |

---

#### Quick Navigation

- [5.4.1 Network and EC2 Workload](./5.4.1-network-and-ec2/)
- [5.4.2 Logging and Evidence Storage](./5.4.2-logging-and-evidence-storage/)
- [5.4.3 Threat Detection Services](./5.4.3-threat-detection-services/)
- [5.4.4 EventBridge and Step Functions](./5.4.4-eventbridge-and-step-functions/)
- [5.4.5 Dashboard and Approval Flow](./5.4.5-dashboard-and-approval-flow/)
- [5.4.6 Forensics, Snapshot and Isolation](./5.4.6-forensics-snapshot-and-isolation/)
- [5.4.7 Notification and Alerting](./5.4.7-notification-and-alerting/)

---

#### Recommended Deployment Order

```text
5.4.1 Network and EC2 Workload
        ↓
5.4.2 Logging and Evidence Storage
        ↓
5.4.3 Threat Detection Services
        ↓
5.4.4 EventBridge and Step Functions
        ↓
5.4.5 Dashboard and Approval Flow
        ↓
5.4.6 Forensics, Snapshot and Isolation
        ↓
5.4.7 Notification and Alerting
```

This order helps the system follow the correct deployment flow:

```text
Infrastructure → Logging → Detection → Workflow → Dashboard → Response → Notification
```

---

#### Deployment Architecture in This Section

The CloudSOC system is divided into multiple functional layers. Each layer has a specific role in the threat detection and incident response process.

| Functional Layer | AWS Services | Role |
|---|---|---|
| Network Layer | VPC, Subnet, Internet Gateway, Route Table, EC2, Security Group | Create the workload environment for monitoring |
| Logging Layer | CloudTrail, VPC Flow Logs, CloudWatch Logs, S3 | Capture logs and store evidence |
| Detection Layer | GuardDuty, Security Hub, Detective, AWS Config | Detect, aggregate, and investigate findings |
| Workflow Layer | EventBridge, Step Functions | Orchestrate the incident response workflow |
| Dashboard Layer | Cognito, API Gateway, Lambda, DynamoDB, Amplify | Allow SOC Analysts to view and approve incidents |
| Response Layer | Lambda, Systems Manager, EBS Snapshot, Security Group | Collect evidence, create snapshots, and isolate EC2 |
| Notification Layer | SNS, Email, CloudWatch Alarm, optional Slack | Send alerts to SOC Analysts |

---

#### 5.4.1 Network and EC2 Workload

In this section, you will create the network foundation for the CloudSOC lab.

The deployed components include:

+ VPC `cloudsoc-vpc`.
+ Public subnet `cloudsoc-public-subnet`.
+ Internet Gateway.
+ Public Route Table.
+ EC2 instance `cloudsoc-workload-ec2`.
+ IAM Role for EC2 to use Systems Manager.
+ Normal Security Group `SG-Workload`.
+ Isolation Security Group `SG-Isolation`.

The main goal is to create an EC2 workload that can be managed by Systems Manager and isolated by replacing its Security Group when an incident occurs.

Basic network flow:

```text
Internet
→ Internet Gateway
→ Public Subnet
→ EC2 Workload
```

The workload EC2 instance is tagged with:

```text
AutoIsolate = true
```

This tag helps the Incident Response Lambda determine whether the EC2 instance is eligible for automated isolation.

Expected result after section 5.4.1:

```text
The EC2 workload is running with SG-Workload, has an IAM Role for SSM, and has SG-Isolation ready for isolation.
```

---

#### 5.4.2 Logging and Evidence Storage

In this section, you will create the logging and evidence storage layer.

The main components include:

+ S3 bucket for CloudTrail audit logs.
+ S3 bucket for incident evidence.
+ CloudTrail for capturing management events.
+ VPC Flow Logs for recording network traffic metadata into CloudWatch Logs.
+ Evidence folder structure for forensic investigation.

The goal is to make sure important events and incident response evidence are stored for post-incident investigation.

Main logging flow:

```text
CloudTrail → S3 Audit Logs
VPC Flow Logs → CloudWatch Logs
Incident Response Lambda → S3 Evidence Bucket
Systems Manager → S3 Evidence Bucket
```

Expected result after section 5.4.2:

```text
CloudTrail, VPC Flow Logs, and the S3 Evidence Bucket are ready to store logs and evidence.
```

---

#### 5.4.3 Threat Detection Services

In this section, you will enable threat detection and investigation services.

The services include:

+ Amazon GuardDuty.
+ AWS Security Hub.
+ Amazon Detective.
+ AWS Config.

GuardDuty is responsible for detecting suspicious behavior. Security Hub aggregates security findings. Detective supports investigation by showing relationships between AWS resources, while AWS Config tracks resource configuration changes.

Main detection flow:

```text
CloudTrail / VPC Flow Logs / DNS Logs
→ GuardDuty
→ Security Hub
→ EventBridge
```

Detective supports investigation after findings are generated:

```text
GuardDuty Finding
→ Amazon Detective
→ Investigation
```

Expected result after section 5.4.3:

```text
GuardDuty, Security Hub, Detective, and AWS Config are enabled for threat detection and investigation.
```

---

#### 5.4.4 EventBridge and Step Functions

In this section, you will deploy the incident response orchestration layer.

The main components include:

+ EventBridge Rule for receiving GuardDuty Findings.
+ Step Functions State Machine for workflow orchestration.
+ `Alert Only` branch.
+ `Approval Required` branch.
+ `Auto Response` branch.

The workflow helps the system decide how to respond based on severity, resource type, and response policy.

Main workflow:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions
→ Evaluate Finding
→ Alert Only / Approval Required / Auto Response
```

Response branches:

| Branch | Condition | Action |
|---|---|---|
| Alert Only | Finding is low severity or not eligible for automated action | Send alert only, do not isolate EC2 |
| Approval Required | Finding is high severity but requires SOC Analyst approval | Create incident and wait for approval |
| Auto Response | Finding is critical and EC2 has `AutoIsolate=true` | Automatically respond and isolate EC2 |

Expected result after section 5.4.4:

```text
GuardDuty findings can trigger the Step Functions workflow through EventBridge.
```

---

#### 5.4.5 Dashboard and Approval Flow

In this section, you will deploy the dashboard for SOC Analysts.

The components include:

+ DynamoDB Incident Table.
+ Cognito User Pool.
+ Dashboard API Lambda.
+ API Gateway.
+ Amplify Hosting.
+ Web dashboard interface.
+ Approval action: Approve or Reject.

The dashboard allows SOC Analysts to view incidents, inspect finding details, and approve response actions when required.

Dashboard flow:

```text
SOC Analyst
→ Amplify Dashboard
→ Cognito Authentication
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

Approval flow:

```text
SOC Analyst
→ Approve / Reject
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

Expected result after section 5.4.5:

```text
The SOC Analyst can view incidents on the dashboard and change the approval status from Pending to Approved or Rejected.
```

---

#### 5.4.6 Forensics, Snapshot and Isolation

In this section, you will implement the actual incident response actions.

The components include:

+ Incident Response Lambda.
+ Systems Manager Run Command.
+ S3 Evidence Bucket.
+ EBS Forensic Snapshot.
+ Security Group Isolation.
+ DynamoDB incident update.

When Lambda is triggered, the system performs the following actions:

```text
Collect Evidence
→ Create EBS Snapshot
→ Store Evidence in S3
→ Replace SG-Workload with SG-Isolation
→ Update DynamoDB Incident Status
```

Incident Response Lambda performs the following actions:

| Action | Purpose |
|---|---|
| Read GuardDuty event | Identify the finding and affected EC2 instance |
| Check `AutoIsolate=true` tag | Ensure only approved workloads are isolated |
| Run SSM Run Command | Collect basic forensic information |
| Create EBS Snapshot | Preserve volume state for investigation |
| Write evidence to S3 | Store event and response summary |
| Replace Security Group | Isolate EC2 with `SG-Isolation` |
| Update DynamoDB | Record incident status |

Expected result after section 5.4.6:

```text
Lambda can collect evidence, create snapshots, write data to S3/DynamoDB, and replace the EC2 Security Group with SG-Isolation.
```

---

#### 5.4.7 Notification and Alerting

In this section, you will deploy the alerting layer.

The components include:

+ SNS Topic `cloudsoc-incident-alerts`.
+ Email subscription.
+ Lambda publish notification.
+ CloudWatch Alarm for Lambda Errors.
+ Optional Slack notification through Amazon Q Developer in chat applications.

Main notification flow:

```text
Incident Response Lambda
→ Amazon SNS
→ Email / Slack
→ SOC Analyst
```

Error alert flow:

```text
CloudWatch Metrics
→ CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
```

The goal is to help SOC Analysts receive timely notifications when incidents are processed or when the incident response workflow fails.

Expected result after section 5.4.7:

```text
SNS successfully sends notifications to Email and optional Slack after an incident is processed.
```

---

#### Deployment Checklist

The following table summarizes the components that should be completed during the deployment section.

![CloudSOC Deployment Checklist](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/deployment-checklist.png)

| Item | Expected Status |
|---|---|
| VPC and EC2 workload | Created |
| SG-Workload and SG-Isolation | Configured |
| EC2 tag `AutoIsolate=true` | Added |
| IAM Role for EC2 SSM | Created |
| CloudTrail | Enabled |
| VPC Flow Logs | Enabled |
| S3 Audit Logs Bucket | Created |
| S3 Evidence Bucket | Created |
| GuardDuty | Enabled |
| Security Hub | Enabled |
| Detective | Enabled |
| AWS Config | Enabled |
| EventBridge Rule | Created |
| Step Functions Workflow | Created |
| DynamoDB Incident Table | Created |
| Cognito User Pool | Created |
| Dashboard API Lambda | Created |
| API Gateway | Created |
| Amplify Dashboard | Deployed |
| Incident Response Lambda | Deployed |
| Systems Manager Run Command | Runs successfully during testing |
| EBS Snapshot | Created successfully during testing |
| EC2 Isolation | Changed to SG-Isolation during testing |
| SNS Topic | Created |
| Email Notification | Sent successfully |
| CloudWatch Alarm | Created |
| Slack Notification | Optional |

---

#### Expected Result After Each Subsection

| Section | Expected Result |
|---|---|
| 5.4.1 | EC2 workload runs in the VPC and can be managed by Systems Manager |
| 5.4.2 | CloudTrail, VPC Flow Logs, and S3 Evidence Bucket are working |
| 5.4.3 | GuardDuty, Security Hub, Detective, and AWS Config are enabled |
| 5.4.4 | GuardDuty findings can trigger Step Functions through EventBridge |
| 5.4.5 | SOC Analyst has a dashboard to view incidents and approve responses |
| 5.4.6 | Lambda can collect evidence, create snapshots, and isolate EC2 |
| 5.4.7 | SNS can send alerts through Email and optional Slack |

---

#### System Workflow After Deployment

After completing section 5.4, the AWS CloudSOC system can operate using the following flow:

```text
1. GuardDuty detects a suspicious finding.
2. Security Hub aggregates the security finding.
3. EventBridge receives the GuardDuty Finding.
4. Step Functions evaluates severity and resource type.
5. The dashboard displays the incident for the SOC Analyst.
6. Incident Response Lambda is triggered when the finding is eligible.
7. Systems Manager collects forensic evidence from EC2.
8. Lambda creates an EBS Snapshot for investigation.
9. Lambda writes the event and response summary to the S3 Evidence Bucket.
10. Lambda replaces the EC2 Security Group from SG-Workload to SG-Isolation.
11. DynamoDB updates the incident status.
12. SNS sends a notification to Email or Slack.
```

---

#### Completion Result of Section 5.4

After completing all of section 5.4, the AWS CloudSOC system has the core components of an automated SOC model on AWS.

The system can perform the following workflow:

```text
GuardDuty detects a finding
→ EventBridge routes the finding
→ Step Functions evaluates the response path
→ Lambda performs response actions
→ Systems Manager collects evidence
→ EBS Snapshot preserves forensic state
→ EC2 is isolated with SG-Isolation
→ DynamoDB records incident status
→ SNS sends notification to SOC Analyst
```

The main completed components include:

```text
VPC
EC2
Security Groups
CloudTrail
VPC Flow Logs
S3
GuardDuty
Security Hub
Detective
AWS Config
EventBridge
Step Functions
Lambda
Systems Manager
EBS Snapshot
DynamoDB
Cognito
API Gateway
Amplify
SNS
CloudWatch Alarm
Optional Slack
```

---

#### Summary

Section 5.4 completed the deployment of the CloudSOC system, from network infrastructure, logging, detection, workflow orchestration, dashboard, forensic response, to alerting.

This is the main deployment section of the workshop and serves as the foundation for the next section:

```text
5.5 Testing and Validation
```

In the next section, you will validate the complete system flow, including finding detection, workflow execution, EC2 isolation, evidence storage, and notification delivery.