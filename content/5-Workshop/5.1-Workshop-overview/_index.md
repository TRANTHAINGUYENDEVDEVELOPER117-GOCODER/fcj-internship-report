---
title : "Workshop Overview"
date : 2026-07-01 
weight : 1 
chapter : false
pre : " <b> 5.1. </b> "
---

#### AWS CloudSOC Workshop Overview

In this workshop, you will build an **AWS CloudSOC – Automated Threat Detection, Investigation, and Incident Response System** on Amazon Web Services (AWS).

The purpose of this workshop is to simulate how a Security Operations Center (SOC) can detect suspicious activities, analyze security findings, collect forensic evidence, isolate affected resources, and notify the SOC Analyst.

This workshop is designed as a **Lab / Proof of Concept** environment. An Amazon EC2 instance is used as the target workload, while multiple AWS security and serverless services are integrated to build a complete incident response workflow.

The main workflow of the system is:

```text
Detect → Investigate → Evaluate → Approve → Collect Evidence → Snapshot → Isolate → Notify
```

---

#### Workshop Scenario

In a cloud environment, public workloads can be exposed to suspicious activities such as port scanning, SSH brute-force attempts, unusual API activity, or traffic from suspicious IP addresses. If these events are not detected and handled quickly, the affected resource may become a security risk.

In this workshop, an **Amazon EC2 instance** is deployed in a Public Subnet to act as a test workload. This design makes it easier to simulate attack traffic and observe how the detection and response workflow operates.

When **Amazon GuardDuty** detects suspicious activity, it generates a security finding. The finding is then sent to **Amazon EventBridge**, which starts an **AWS Step Functions** workflow. The workflow evaluates the finding and decides whether to send an alert, request approval, collect forensic evidence, create a snapshot, or isolate the affected EC2 instance.

The response process is controlled by severity, resource type, instance ID, response mode, and the `AutoIsolate=true` tag.

---

#### Architecture Illustration

The following diagram shows the overall architecture of the AWS CloudSOC system.

![AWS CloudSOC Architecture](/images/5-Workshop/5.1-Workshop-overview/architecture.png)

The architecture is divided into five main groups:

+ **Network and Workload**: Amazon VPC, Public Subnet, Internet Gateway, Amazon EC2, SG-Workload, and SG-Isolation.
+ **Logging and Evidence Storage**: AWS CloudTrail, Amazon CloudWatch, Amazon S3, VPC Flow Logs, and Amazon EBS Snapshot.
+ **Threat Detection and Response**: Amazon GuardDuty, AWS Security Hub, Amazon Detective, Amazon EventBridge, AWS Step Functions, AWS Systems Manager, and AWS Lambda.
+ **SOC Dashboard and Access**: AWS Amplify Hosting, Amazon Cognito, Amazon API Gateway, Dashboard API Lambda, and Amazon DynamoDB.
+ **Security, Governance, and Notification**: AWS IAM, AWS KMS, AWS Config, Amazon SNS, Amazon Q Developer, Slack, Email, and SMS.

---

#### Incident Response Lifecycle

The AWS CloudSOC workflow follows a controlled incident response lifecycle. The system does not isolate every finding immediately. Instead, it evaluates the finding before taking action.

![CloudSOC Incident Response Lifecycle](/images/5-Workshop/5.1-Workshop-overview/incident-response-lifecycle.png)

The lifecycle includes the following steps:

1. **Detect**  
   Amazon GuardDuty analyzes AWS-managed telemetry and detects suspicious activity.

2. **Investigate**  
   AWS Security Hub centralizes findings, while Amazon Detective supports deeper investigation.

3. **Evaluate**  
   AWS Step Functions checks the resource type, instance ID, severity, `AutoIsolate=true` tag, and response mode.

4. **Approve**  
   For High severity findings, the SOC Analyst reviews the incident and approves or rejects the response action.

5. **Collect Evidence**  
   AWS Systems Manager collects forensic information from the affected EC2 instance.

6. **Snapshot**  
   An Amazon EBS Snapshot is created to preserve disk evidence for investigation or recovery.

7. **Isolate**  
   AWS Lambda replaces the original security group with `SG-Isolation` to contain the affected EC2 instance.

8. **Notify**  
   Amazon SNS sends the result to Slack, Email, or SMS.

---

#### Response Policy

The workflow uses a response policy to reduce false positives and prevent unnecessary isolation.

![Response Policy](/images/5-Workshop/5.1-Workshop-overview/response-policy.png)

The response policy is defined as follows:

```text
Non-EC2 Finding        → Alert Only
Low / Medium Severity  → Dry Run
High Severity          → Request Approval
Critical Severity      → Auto Response
Reject / Timeout       → End Workflow
```

This policy allows the system to respond automatically to critical incidents while requiring human approval for High severity findings.

---

#### SOC Dashboard Overview

The SOC Dashboard allows the SOC Analyst to view incidents, review evidence, and approve or reject response actions.

![SOC Dashboard Flow](/images/5-Workshop/5.1-Workshop-overview/soc-dashboard-flow.png)

The dashboard flow is:

```text
SOC Analyst
→ AWS Amplify Hosting
→ Amazon Cognito
→ Amazon API Gateway
→ Dashboard API Lambda
→ Amazon DynamoDB / Amazon S3
→ AWS Step Functions Approval Callback
```

The dashboard displays important incident information, including:

+ Incident ID
+ Finding type
+ Severity
+ EC2 Instance ID
+ Approval status
+ Containment status
+ Evidence location
+ Snapshot ID
+ Notification result

---

#### Main AWS Services Used

The workshop uses the following AWS services:

+ **Amazon EC2** is used as the target workload for security testing.
+ **Amazon VPC** provides the network environment for the EC2 instance.
+ **Internet Gateway** allows internet traffic to reach the Public Subnet.
+ **Security Groups** control inbound and outbound traffic for the EC2 instance.
+ **AWS CloudTrail** records AWS account activity and management events.
+ **Amazon CloudWatch** stores logs, metrics, and alarms.
+ **VPC Flow Logs** capture network traffic metadata.
+ **Amazon S3** stores audit logs, forensic output, and incident evidence.
+ **Amazon GuardDuty** detects suspicious activities and generates security findings.
+ **AWS Security Hub** centralizes security findings.
+ **Amazon Detective** supports investigation and analysis.
+ **Amazon EventBridge** routes GuardDuty findings to the response workflow.
+ **AWS Step Functions** orchestrates the incident response process.
+ **AWS Systems Manager** collects forensic data from the EC2 instance.
+ **Amazon EBS Snapshot** preserves disk evidence before isolation.
+ **AWS Lambda** performs response actions such as updating incident records and replacing the security group.
+ **Amazon DynamoDB** stores incident metadata and response status.
+ **Amazon SNS** sends approval requests and incident alerts.
+ **Amazon Q Developer** forwards SNS notifications to Slack.
+ **AWS Amplify Hosting** hosts the SOC Dashboard frontend.
+ **Amazon Cognito** provides authentication for the SOC Analyst.
+ **Amazon API Gateway** exposes APIs for the SOC Dashboard.
+ **AWS IAM** manages permissions and execution roles.
+ **AWS KMS** supports encryption for sensitive data.
+ **AWS Config** tracks configuration changes of AWS resources.

---

#### Workshop Scope

This workshop focuses on building a CloudSOC Lab environment. It is designed for learning, demonstration, and security architecture practice.

In this workshop:

+ The EC2 instance is placed in a Public Subnet to simplify attack simulation.
+ Amazon GuardDuty is used as the main threat detection service.
+ AWS Step Functions controls the response workflow.
+ AWS Systems Manager collects forensic data before isolation.
+ AWS Lambda isolates the EC2 instance by replacing its security group.
+ Amazon S3 and Amazon DynamoDB store evidence and incident metadata.
+ Amazon SNS sends notifications to the SOC Analyst.
+ The SOC Dashboard provides visibility and approval capability.

This workshop is not a full production architecture. In a production environment, the workload should usually be placed in a Private Subnet and protected by additional layers such as Application Load Balancer, AWS WAF, multi-AZ design, centralized logging, and stricter network controls.