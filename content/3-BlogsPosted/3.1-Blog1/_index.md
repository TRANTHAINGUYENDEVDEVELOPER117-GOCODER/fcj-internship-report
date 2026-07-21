---
title: "Completing the AWS CloudSOC Proof of Concept"
date: 2026-07-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

After more than two weeks of continuous work, our team officially completed the **Proof of Concept** for the **AWS CloudSOC – Threat Detection, Investigation, and Incident Response System on AWS** project.

This is not just a paper-based design or a beautiful architecture diagram. It is a working system that can operate from end to end. When a **Threat Actor** performs test attack activities against an EC2 instance, such as **port scanning**, **SSH brute-force attempts**, or access from a suspicious IP address, the system can automatically detect the activity through **Amazon GuardDuty**, orchestrate the response workflow, collect evidence, and isolate the affected server in a controlled way.

---

## System Overview

The AWS CloudSOC project was built to simulate a **Security Operations Center** on AWS. The system focuses on threat detection, incident investigation, automated response, evidence collection, and alert notification for SOC Analysts.

The main processing flow of the system is:

```text
Threat Activity
→ Amazon GuardDuty
→ Amazon EventBridge
→ AWS Step Functions
→ Incident Response Lambda
→ AWS Systems Manager
→ EC2 Isolation
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS Alert
→ Email / Slack Notification
```

Through this workflow, the system can detect security findings, process incidents, collect forensic evidence, isolate a suspected EC2 instance, and notify the security operator.

---

## Architecture Overview

The following diagram shows the overall architecture that our team built:

![AWS CloudSOC Architecture](/images/3-BlogsPosted/3.1-Blog1/blog1-overview-architecture.png)

The architecture includes the main components of the system, such as:

```text
Amazon GuardDuty
AWS Security Hub
Amazon EventBridge
AWS Step Functions
AWS Lambda
AWS Systems Manager
Amazon EC2
Amazon S3
Amazon DynamoDB
Amazon SNS
Amazon CloudWatch
Amazon Detective
AWS Config
AWS CloudTrail
AWS Amplify
Amazon API Gateway
Amazon Cognito
```

These services work together to create a CloudSOC model that can detect, orchestrate, respond, store evidence, and send security alerts.

---

## What I Learned from This Project

Through this project, I gained more practical knowledge about **Cloud Security** and **Incident Response** on AWS.

Some important lessons include:

- I understood more deeply how AWS Security services work together, especially **Amazon GuardDuty**, **AWS Security Hub**, **Amazon Detective**, **Amazon EventBridge**, and **AWS Step Functions**.
- I learned how to design a practical **event-driven architecture** instead of only relying on predefined templates.
- I understood the role of **AWS Lambda** and **AWS Systems Manager** in automating incident response.
- I learned how to store forensic evidence in **Amazon S3** and update incident status in **Amazon DynamoDB**.
- I clearly recognized the difference between a fully serverless model and a **hybrid architecture**, where **Amazon EC2** is still required as a test workload to demonstrate the SOC process more clearly.

---

## Practical Lessons Learned

During the implementation process, our team realized that cloud security is not about automating everything as much as possible. An incident response system needs control mechanisms to avoid affecting production environments.

Some important lessons include:

- A **manual approval mechanism** is necessary for high-severity incidents that are not yet ready for automatic response.
- A **Dry-run mode** should be used to test the workflow before performing real actions.
- Auto isolation should only be applied to EC2 instances with a clear tag, such as `AutoIsolate=true`.
- Forensic evidence should be collected before performing isolation actions.
- Resources should not be terminated immediately after a security finding is detected, because doing so may destroy important investigation evidence.
- All lab resources should be clearly tagged to make management and cleanup easier.

---

## Results Achieved

After completing the Proof of Concept, our team built a system that can operate through the following process:

```text
Detect
→ Investigate
→ Respond
→ Store Evidence
→ Notify
```

The main results include:

- GuardDuty can detect and generate security findings.
- EventBridge can receive findings and trigger the workflow.
- Step Functions can orchestrate the incident response process.
- Lambda can process incident response logic.
- Systems Manager can collect forensic evidence from EC2.
- EBS Snapshots can be created for investigation.
- S3 can store raw events and response summaries.
- DynamoDB can update incident status.
- SNS can send alerts to Email or Slack.
- The SOC Dashboard can display incident response status.

---

## Conclusion

The AWS CloudSOC project helped our team better understand how to build a SOC system on a cloud platform. This is not only an AWS lab, but also an opportunity to understand the practical process of **Cloud Security**, **Incident Response**, and **Security Automation**.

In the next posts, I will continue sharing more details about the incident response workflow and the practical lessons learned while building the CloudSOC system on AWS.