---
title: "Workshop"
date: 2026-06-30
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# AWS CloudSOC: Automated Threat Detection and Incident Response on AWS

#### Overview

In this workshop, we will build an **AWS CloudSOC** system for automated threat detection, investigation, incident response, evidence collection, and alerting on Amazon Web Services (AWS).

The system is designed as a cloud-based Security Operations Center lab that can detect suspicious activities, process security findings, support SOC Analyst approval, automatically isolate a suspected EC2 instance, collect forensic evidence, store incident records, and send notifications to security operators.

The main detection source in this workshop is **Amazon GuardDuty**. When a security finding is generated, **Amazon EventBridge** routes the event to **AWS Step Functions**, which controls the incident response workflow. Depending on the severity and response mode, the workflow can trigger **AWS Lambda** and **AWS Systems Manager** to collect evidence, create forensic snapshots, update incident status in **Amazon DynamoDB**, store evidence in **Amazon S3**, and send alerts through **Amazon SNS** to Email or Slack.

This workshop also includes a simple **SOC Dashboard** hosted with **AWS Amplify**. The dashboard helps SOC Analysts monitor incident status, review pending incidents, and validate the response workflow.

The architecture follows an event-driven and serverless-oriented approach to reduce operational complexity, improve automation, and support cost optimization for a lab environment.

#### Main AWS Services

The main AWS services used in this workshop include:

```text
Amazon GuardDuty
AWS Security Hub
Amazon EventBridge
AWS Step Functions
AWS Lambda
AWS Systems Manager
Amazon EC2
Amazon VPC
Amazon S3
Amazon DynamoDB
Amazon SNS
Amazon CloudWatch
Amazon Detective
AWS Config
AWS CloudTrail
AWS IAM
AWS KMS
AWS Amplify
Amazon API Gateway
Amazon Cognito
```

#### Workshop Goals

After completing this workshop, you will be able to:

+ Design a CloudSOC architecture on AWS.
+ Deploy a lab VPC, public subnet, route table, Internet Gateway, and EC2 workload.
+ Enable security monitoring services such as GuardDuty, Security Hub, CloudTrail, VPC Flow Logs, AWS Config, and Detective.
+ Build an event-driven incident response workflow using EventBridge and Step Functions.
+ Implement an Incident Response Lambda function to process findings.
+ Use Systems Manager to collect forensic evidence from EC2.
+ Create an EBS snapshot for forensic investigation.
+ Store incident evidence in S3.
+ Store incident metadata and response status in DynamoDB.
+ Build a simple SOC Dashboard for monitoring and approval validation.
+ Send incident notifications through SNS, Email, and Slack.
+ Validate the full detection and response workflow.
+ Clean up all lab resources to avoid unnecessary costs.

#### Workshop Flow

The overall workflow of this workshop is:

```text
Design Architecture
→ Prepare AWS Environment
→ Deploy CloudSOC System
→ Test and Validate Incident Response
→ Monitor Dashboard and Alerts
→ Clean Up Resources
```

The main incident response flow is:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions Workflow
→ Incident Response Lambda
→ Systems Manager Evidence Collection
→ EBS Forensic Snapshot
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS Notification
→ Email / Slack Alert
```

#### Content

1. [Workshop Overview](5.1-workshop-overview/)
2. [Prerequisites](5.2-prerequiste/)
3. [Architecture and Workflow](5.3-architecture-and-workflow/)
4. [Deploy CloudSOC System](5.4-deploy-cloudsoc-system/)
5. [Testing and Validation](5.5-testing-and-validation/)
6. [Resource Cleanup](5.6-resource-cleanup/)

#### Expected Final Result

At the end of this workshop, you will have a working AWS CloudSOC lab that can:

+ Detect simulated security findings from GuardDuty.
+ Route findings automatically through EventBridge.
+ Process incidents using Step Functions and Lambda.
+ Support SOC Analyst approval for selected incidents.
+ Automatically isolate an EC2 instance using `SG-Isolation`.
+ Collect forensic evidence using Systems Manager.
+ Create EBS snapshots for investigation.
+ Store raw events and response summaries in S3.
+ Track incident status in DynamoDB.
+ Display incident status on the SOC Dashboard.
+ Send alerts to Email and Slack through SNS.
+ Clean up all deployed resources after the lab.