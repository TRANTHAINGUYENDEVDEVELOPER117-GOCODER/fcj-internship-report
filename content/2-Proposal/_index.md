---
title: "Proposal"
date: 2026-06-30
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# AWS CloudSOC  
## Automated Threat Detection, Investigation, and Incident Response on AWS

### 1. Executive Summary

**AWS CloudSOC** is a Security Operations Center model built on Amazon Web Services to support threat detection, incident investigation, automated response, evidence collection, and security alerting.

The objective of this project is to design and implement a system that can detect suspicious activities in an AWS environment, such as abnormal access, SSH brute-force attempts, port scanning, or signs of a compromised EC2 instance. When a security finding is generated, the system can automatically receive the event, classify its severity, record the incident, collect evidence, isolate the suspected resource, and notify the SOC Analyst.

This project uses AWS services such as **Amazon GuardDuty**, **AWS Security Hub**, **Amazon EventBridge**, **AWS Step Functions**, **AWS Lambda**, **AWS Systems Manager**, **Amazon EC2**, **Amazon S3**, **Amazon DynamoDB**, **Amazon SNS**, **Amazon CloudWatch**, **AWS CloudTrail**, **AWS Config**, and **Amazon Detective**.

The system is designed using an **event-driven** and **serverless-oriented** architecture. This approach helps reduce manual operations, improve incident response automation, and optimize cost for a lab environment.

---

### 2. Problem Statement

#### Current Problems

In a cloud environment, resources such as EC2 instances, VPCs, IAM roles, Security Groups, and storage services may be exposed to attacks or misconfigurations if they are not continuously monitored.

Common problems include:

- Difficulty in detecting abnormal behaviors on EC2 instances.
- Lack of a centralized system for monitoring security findings.
- Incident response processes that still depend heavily on manual operations.
- SOC Analysts spending too much time reviewing logs, identifying affected resources, and performing isolation manually.
- Incident evidence may be incomplete or not stored properly.
- Security alerts may be delayed without an automated notification system.

In a real-world scenario, if a suspected EC2 instance is not isolated quickly, an attacker may continue scanning, performing lateral movement, or accessing sensitive resources.

#### Proposed Solution

The proposed solution is to build an **AWS CloudSOC** system that automates the detection and incident response process.

The main workflow of the system is:

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

In this system:

- **Amazon GuardDuty** detects suspicious activities.
- **AWS Security Hub** aggregates and normalizes security findings.
- **Amazon EventBridge** receives GuardDuty findings and triggers the workflow.
- **AWS Step Functions** orchestrates the incident response process.
- **AWS Lambda** handles response logic and incident updates.
- **AWS Systems Manager** collects forensic evidence from EC2.
- **Amazon S3** stores raw events and response summaries.
- **Amazon DynamoDB** stores incident status and metadata.
- **Amazon SNS** sends alerts to Email or Slack.
- **Amazon CloudWatch** monitors logs, metrics, and alarms.
- **Amazon Detective** supports investigation and finding correlation.

In addition, the project includes a simple **SOC Dashboard** deployed with **AWS Amplify**. The dashboard helps SOC Analysts monitor incidents, review processing status, and validate the response workflow.

#### Benefits and Value

The project provides the following benefits:

- Automates security finding detection and response.
- Reduces response time during security incidents.
- Isolates suspected EC2 instances using a dedicated Security Group.
- Stores incident evidence in S3 for investigation.
- Tracks incident status in DynamoDB.
- Sends alerts to SOC Analysts through Email or Slack.
- Provides a dashboard for incident monitoring.
- Helps students understand how a SOC workflow can operate in an AWS cloud environment.

This project is suitable for learning **Cloud Security**, **Incident Response**, **AWS Security Services**, and **AWS Solution Architecture**.

---

### 3. Solution Architecture

The AWS CloudSOC system is designed using an event-driven architecture. Security findings are automatically routed through multiple processing layers.

The overall architecture includes the following layers:

```text
Detection Layer
→ Event Routing Layer
→ Workflow Orchestration Layer
→ Response Automation Layer
→ Evidence Storage Layer
→ Monitoring and Alerting Layer
→ SOC Dashboard Layer
```

![AWS CloudSOC Architecture](/images/2-Proposal/cloudsoc-architecture.png)


#### AWS Services Used

- **Amazon GuardDuty**: Detects suspicious activities and generates security findings.
- **AWS Security Hub**: Aggregates findings and supports security posture management.
- **Amazon EventBridge**: Routes GuardDuty findings to Step Functions.
- **AWS Step Functions**: Orchestrates the incident response workflow.
- **AWS Lambda**: Processes incident response logic.
- **AWS Systems Manager**: Runs forensic collection commands on EC2.
- **Amazon EC2**: Represents the protected workload in the lab.
- **Amazon VPC**: Provides the network environment for the EC2 workload.
- **Amazon S3**: Stores evidence, raw events, and response summaries.
- **Amazon DynamoDB**: Stores incident metadata and response status.
- **Amazon SNS**: Sends alerts to Email or Slack.
- **Amazon CloudWatch**: Stores logs, monitors metrics, and creates alarms.
- **AWS CloudTrail**: Records AWS API activities in the account.
- **AWS Config**: Tracks resource configuration changes.
- **Amazon Detective**: Supports investigation and finding relationship analysis.
- **AWS IAM**: Manages service permissions and access control.
- **AWS KMS**: Supports encryption when configured.
- **AWS Amplify**: Hosts the SOC Dashboard.
- **Amazon API Gateway**: Provides API endpoints for the dashboard.
- **Amazon Cognito**: Manages dashboard user authentication.


#### Component Design

##### Detection Layer

The detection layer uses GuardDuty, CloudTrail, VPC Flow Logs, and Security Hub to monitor suspicious activities in the AWS account.

GuardDuty plays the main role in detecting findings such as:

```text
UnauthorizedAccess:EC2/SSHBruteForce
Recon:EC2/Portscan
CryptoCurrency:EC2/BitcoinTool.B
Trojan:EC2/BlackholeTraffic
```

##### Event Routing Layer

An EventBridge rule is configured to receive GuardDuty findings and forward them to the Step Functions workflow.

This allows the system to operate using an event-driven model, where the workflow is triggered only when a matching security event occurs.

##### Workflow Orchestration Layer

Step Functions is responsible for controlling the incident response workflow.

The workflow can be divided into three branches:

```text
Alert Only
Approval Required
Auto Response
```

- Low-risk findings or findings that do not meet response conditions will only generate alerts.
- High-severity findings may require SOC Analyst approval.
- Critical findings related to EC2 can trigger auto isolation.

##### Response Automation Layer

Lambda handles the incident response logic, including:

- Reading the GuardDuty finding.
- Identifying the affected EC2 instance.
- Checking the `AutoIsolate=true` tag.
- Writing incident records to DynamoDB.
- Calling Systems Manager to collect evidence.
- Creating an EBS Snapshot.
- Replacing the EC2 Security Group with `SG-Isolation`.
- Sending notifications through SNS.

##### Evidence Storage Layer

S3 is used to store incident evidence, including:

```text
raw-event.json
response-summary.json
SSM command output
forensic evidence
```

DynamoDB stores incident processing information such as:

```text
incidentId
findingId
findingType
severity
resourceId
responseMode
approvalStatus
incidentStatus
evidencePath
snapshotIds
notificationMessageId
```

##### Monitoring and Alerting Layer

CloudWatch is used to monitor logs and errors from Lambda, Step Functions, and related components.

SNS is used to send alerts to:

```text
Email
Slack Channel
SOC Analyst
```

##### SOC Dashboard Layer

The SOC Dashboard is deployed using Amplify. The dashboard displays:

- Total incidents.
- Pending approval incidents.
- Critical findings.
- Incident response status.
- Auto isolation result.
- Notification status.

---

### 4. Technical Implementation

#### Implementation Phases

The project is implemented through the following phases.

##### Phase 1: Research and Architecture Design

In this phase, AWS Security services and cloud incident response concepts are researched.

Main tasks include:

- Study GuardDuty, Security Hub, EventBridge, and Step Functions.
- Study Lambda, Systems Manager, and DynamoDB.
- Study the cloud incident response model.
- Design the overall architecture according to AWS best practices.
- Define the detection, investigation, response, and notification workflow.

##### Phase 2: Prepare the AWS Lab Environment

This phase focuses on creating the lab environment:

- Create a VPC.
- Create a public subnet.
- Create a route table.
- Create an Internet Gateway.
- Create an EC2 workload instance.
- Create a Security Group for the workload.
- Create an isolation Security Group named `SG-Isolation`.
- Attach an IAM Role to EC2 for Systems Manager access.

##### Phase 3: Deploy Logging and Security Services

Enable and configure the monitoring and security services:

- CloudTrail.
- VPC Flow Logs.
- GuardDuty.
- Security Hub.
- AWS Config.
- Amazon Detective.
- CloudWatch Logs.

The goal is to make sure the system has enough data sources for detection and investigation.

##### Phase 4: Build the Incident Response Workflow

Configure the automation components:

- EventBridge rule for GuardDuty findings.
- Step Functions workflow for response orchestration.
- Lambda function for incident processing.
- Systems Manager Run Command for evidence collection.
- S3 bucket for evidence storage.
- DynamoDB table for incident status.
- SNS topic for notifications.

##### Phase 5: Build the Dashboard and Alerting Layer

Deploy the SOC Dashboard:

- Amplify Hosting for the dashboard frontend.
- API Gateway as the dashboard API endpoint.
- Lambda API for handling dashboard requests.
- Cognito for user authentication if required.
- Dashboard display for incident status and approval validation.

##### Phase 6: Testing and Validation

Test the full system workflow:

- Generate GuardDuty sample findings.
- Check the EventBridge rule.
- Check Step Functions execution.
- Test the Approval Workflow.
- Test Auto Isolation.
- Check DynamoDB records.
- Check S3 evidence.
- Check EBS Snapshots.
- Check Email and Slack alerts.
- Check CloudWatch Alarms.

##### Phase 7: Resource Cleanup

After completing the workshop, delete unused resources to avoid unnecessary costs.

---

#### Technical Requirements

To implement this project, the following requirements are needed:

- An AWS account with permissions to create the required services.
- Basic knowledge of the AWS Management Console.
- Basic knowledge of VPC, EC2, IAM, and Security Groups.
- Basic knowledge of Cloud Security and Incident Response.
- A web browser to access the AWS Console.
- An email address to receive SNS notifications.
- A Slack workspace if Slack alert testing is required.

---

### 5. Roadmap and Milestones

The project is carried out during the internship period and divided into the following milestones.

#### Week 1–2: Research and Planning

- Study AWS Security services.
- Analyze project requirements.
- Define project scope.
- Design the initial architecture.

#### Week 3–4: Architecture Design and Lab Preparation

- Finalize the AWS CloudSOC architecture diagram.
- Create VPC, subnet, route table, and Internet Gateway.
- Create the EC2 workload instance.
- Configure IAM Role and Security Groups.

#### Week 5–6: Detection and Logging Deployment

- Enable CloudTrail.
- Configure VPC Flow Logs.
- Enable GuardDuty.
- Enable Security Hub.
- Configure AWS Config and Detective.

#### Week 7–8: Response Workflow Deployment

- Create the EventBridge rule.
- Create the Step Functions workflow.
- Develop the Incident Response Lambda.
- Create the S3 Evidence Bucket.
- Create the DynamoDB Incident Table.

#### Week 9–10: Dashboard and Alerting Deployment

- Create the SOC Dashboard.
- Deploy the dashboard using Amplify.
- Configure API Gateway and Lambda API.
- Configure SNS Email notification.
- Configure Slack alerting if required.

#### Week 11: System Testing

- Test GuardDuty sample findings.
- Test the approval workflow.
- Test auto isolation.
- Test evidence storage.
- Test dashboard and alerting.

#### Week 12: Report Completion and Cleanup

- Complete the workshop documentation.
- Capture result screenshots.
- Complete the internship report.
- Clean up AWS resources.

---

### 6. Budget Estimation

The project is designed as a lab environment, so it prioritizes small resources and short running time to optimize cost.

The services that may generate costs include:

| Service Group | Services | Cost Notes |
|---|---|---|
| Compute | EC2, Lambda | EC2 is charged based on running time; Lambda is charged by requests and execution time |
| Storage | S3, EBS Snapshot, DynamoDB | Charged based on storage usage |
| Security | GuardDuty, Security Hub, Detective, Config | May generate costs based on logs, findings, and monitored resources |
| Monitoring | CloudWatch Logs, CloudWatch Alarm | Charged based on log storage, metrics, and alarms |
| Workflow | Step Functions, EventBridge | Charged based on executions and events |
| Notification | SNS | Charged based on notification usage |
| Dashboard | Amplify, API Gateway, Cognito | Charged based on hosting, requests, and users |

#### Estimated Cost for the Lab Environment

Because this is a small lab environment using only one EC2 workload and a limited number of findings and tests, the cost can be kept low by following these practices:

- Run resources only during testing.
- Terminate EC2 after testing.
- Delete EBS Snapshots after the lab.
- Empty and delete S3 buckets after the workshop.
- Delete unnecessary CloudWatch log groups.
- Disable security services if they are no longer used.

The estimated cost should be checked again using **AWS Pricing Calculator** before the official deployment.

```text
Estimated monthly lab cost: Low, depending on running time and enabled security services.
```

---

### 7. Risk Assessment

#### Risk Matrix

| Risk | Impact | Probability | Level |
|---|---|---|---|
| Unexpected cost due to forgotten resources | Medium | Medium | Medium |
| Lambda isolates the wrong EC2 instance | High | Low | Medium |
| IAM Role has overly broad permissions | High | Medium | High |
| GuardDuty sample finding does not trigger the workflow | Medium | Medium | Medium |
| Dashboard does not sync with DynamoDB status | Medium | Medium | Medium |
| SNS Email or Slack alert is not received | Low | Medium | Low |
| Accidentally deleting non-lab resources | High | Low | Medium |

#### Mitigation Strategies

- Tag all lab resources:

```text
Project = AWS-CloudSOC
Environment = Lab
```

- Allow auto isolation only for EC2 instances with the tag:

```text
AutoIsolate = true
```

- Use `SG-Isolation` instead of deleting resources directly.
- Use the approval workflow for High-severity findings.
- Enable auto response only for Critical findings or controlled test events.
- Capture screenshots and save evidence before cleanup.
- Carefully verify resource names before deleting them.
- Apply the principle of least privilege for IAM permissions.
- Create an AWS Budget to monitor lab cost.

#### Contingency Plan

If auto isolation does not work, manual isolation can be performed:

```text
EC2
→ Instance
→ Security
→ Change security groups
→ Replace SG-Workload with SG-Isolation
```

If SNS does not send email, the subscription confirmation should be checked.

If the dashboard cannot read DynamoDB, API Gateway, Lambda API, CORS, and IAM permissions should be checked.

If Step Functions does not run, Lambda can be tested directly using a sample GuardDuty event.

---

### 8. Expected Results

After completing the project, the AWS CloudSOC system is expected to achieve the following results.

#### Technical Improvements

- A working CloudSOC model is built on AWS.
- GuardDuty can generate security findings.
- Findings can be routed automatically through EventBridge.
- Incident response can be orchestrated by Step Functions.
- Incidents can be processed automatically by Lambda.
- Forensic evidence can be collected using Systems Manager.
- EBS Snapshots can be created for investigation.
- Suspected EC2 instances can be isolated using `SG-Isolation`.
- Evidence can be stored in S3.
- Incident status can be updated in DynamoDB.
- Alerts can be sent through SNS, Email, and Slack.
- Incidents can be displayed on the SOC Dashboard.

#### Learning Value

This project helps the implementer understand:

- AWS Security Services.
- Cloud Incident Response.
- Event-driven architecture.
- Serverless automation.
- Security monitoring.
- Forensic evidence collection.
- IAM Roles and least privilege.
- AWS Solution Architecture design principles.

#### Long-Term Value

The AWS CloudSOC model can be extended in the future to:

- Integrate more log sources.
- Connect to an external SIEM.
- Add more incident response playbooks.
- Automatically classify incidents based on risk level.
- Build a more advanced SOC Dashboard.
- Optimize cost and operations using FinOps practices.
- Support advanced Cloud Security lab scenarios.