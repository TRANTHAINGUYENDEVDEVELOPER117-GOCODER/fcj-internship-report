---
title: "Completing the AWS CloudSOC Project – The Most Valuable Lessons Learned"
date: 2026-07-03
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---


After completing the **AWS CloudSOC – Threat Detection, Investigation, and Incident Response System on AWS** project, I would like to share the most valuable knowledge, skills, and practical lessons that I gained throughout the implementation process.

This project helped me better understand how to build a **Security Operations Center model on the cloud**, not only from an architecture perspective, but also from an operational, testing, risk control, and evidence preservation perspective.

---

## Project Overview

AWS CloudSOC was designed to simulate a SOC system on AWS that can support the main security operation phases:

```text
Detect
→ Investigate
→ Respond
→ Recover
```

The system combines AWS Security and serverless-oriented services to detect security findings, orchestrate workflows, collect forensic evidence, isolate suspected EC2 instances, store evidence, and notify SOC Analysts.

The following diagram shows the complete architecture of the system:

![AWS CloudSOC Full Architecture](/images/2-Proposal/cloudsoc-architecture.png)

---

## Skills and Knowledge Gained

During the project, I learned many practical skills that go beyond simply reading documentation or reviewing sample architecture diagrams.

Some of the most important skills I gained include:

- Designing an end-to-end architecture for a Security Operations Center on AWS, covering the **Detect, Investigate, Respond, and Recover** phases.
- Using **Amazon EventBridge** with **AWS Step Functions** to build intelligent, flexible, and maintainable workflows.
- Understanding how to collect forensic evidence in a cloud environment using **AWS Systems Manager**, **EBS Snapshots**, **VPC Flow Logs**, and **AWS CloudTrail**.
- Applying the **least privilege** principle when designing IAM Roles for Lambda, Step Functions, EC2, and other components.
- Combining multiple AWS Security services in a logical and effective way.
- Using **Amazon GuardDuty** to detect suspicious activities.
- Understanding the role of **AWS Security Hub** in aggregating and managing findings.
- Using **Amazon Detective** to support investigation and analyze relationships between findings.
- Storing evidence in **Amazon S3** and incident status in **Amazon DynamoDB**.
- Sending alerts through **Amazon SNS**, Email, and Slack.
- Building a simple dashboard to monitor incident status.

---

## Lesson 1: Lab and Production Environments Are Very Different

One of the biggest lessons I learned is that a **lab environment** and a **production environment** are very different.

In a lab, the system can use one EC2 instance, one public subnet, and a simplified workflow to prove the concept. However, in production, the architecture must be designed more carefully across many areas:

```text
High Availability
Private Subnet
Multi-AZ Deployment
Backup Strategy
Disaster Recovery
Cost Optimization
Access Control
Change Management
```

This helped me understand that a Proof of Concept is only the first step. To make the solution production-ready, the architecture must be expanded, secured, and designed with better resilience.

---

## Lesson 2: Automation Must Be Controlled

Automation provides many benefits in incident response, especially by reducing response time and manual operations. However, not every alert should trigger an immediate automated action.

In the CloudSOC project, our team realized that the key is not only automation, but **Controlled Automation**.

This means the system should include control mechanisms such as:

```text
Alert Only
Approval Required
Auto Response
Dry-run Mode
AutoIsolate=true Tag
Severity-based Response
```

For sensitive actions such as isolating an EC2 instance, changing Security Groups, or affecting a workload, manual approval should be required in certain cases.

This allows the system to respond quickly while reducing the risk of incorrectly impacting a running environment.

---

## Lesson 3: Logging and Evidence Are Critical

In incident response, detection and response are only part of the process. It is also important to preserve enough evidence for post-incident investigation.

Important evidence sources in this project include:

```text
GuardDuty finding
CloudTrail logs
VPC Flow Logs
Systems Manager command output
EBS Snapshot
Raw event
Response summary
DynamoDB incident record
CloudWatch logs
```

These pieces of evidence help SOC Analysts understand what happened, which resource was affected, and how the system responded.

In a real environment, evidence data should also be properly protected. This may include:

```text
AWS KMS encryption
S3 bucket policy
S3 lifecycle policy
Access logging
Retention policy
```

This helps ensure that evidence is protected from unauthorized access, accidental deletion, and improper retention.

---

## Lesson 4: A Diagram Is Only the Beginning

During the project, our team realized that drawing a diagram is only the beginning. A beautiful architecture diagram does not guarantee that the system actually works.

The most important part is real testing.

The components that need to be tested include:

```text
GuardDuty sample findings
EventBridge rule
Step Functions execution
Lambda response logic
Systems Manager Run Command
EBS Snapshot creation
S3 evidence storage
DynamoDB incident update
SNS Email / Slack notification
Dashboard incident status
CloudWatch Alarm
```

By testing each component step by step, we discovered small issues such as missing IAM permissions, wrong region selection, incorrect Security Group IDs, missing SNS Topic ARN, and dashboard status synchronization problems.

From this, I learned that a good architecture must always be supported by real validation.

---

## Lesson 5: Cloud Security Is a Continuous Process

Cloud security is not something that can be configured once and then forgotten. It is a continuous process that requires regular improvement of architecture, processes, and threat intelligence.

A real CloudSOC system should continuously improve areas such as:

```text
Detection rules
Incident response playbooks
IAM permissions
Logging coverage
Alert prioritization
Dashboard visibility
Cost monitoring
Evidence retention
Threat intelligence updates
```

This helped me understand that Cloud Security is not only about technical configuration, but also about long-term operation and continuous improvement.

---

## Practical Experiences Gained

After completing the project, I gained several practical lessons:

1. Do not design the system to be too complex at the beginning. Start with a small workflow that can be tested, then expand it.
2. Tag all resources clearly to make management and cleanup easier.
3. Do not grant overly broad IAM permissions just to make the system work quickly.
4. Always verify the AWS Region before creating or testing resources.
5. Prioritize forensic evidence collection before performing isolation.
6. Use approval mechanisms for high-risk actions.
7. Prepare a cleanup plan to avoid unnecessary costs.
8. The dashboard does not need to be complex, but it must clearly show incident status.
9. CloudWatch logs are very important when debugging Lambda and workflow issues.
10. In AWS architecture, the main flow should be clearer than the number of services used.

---

## Personal Value of the Project

The AWS CloudSOC project became an important milestone in my learning journey with **Cloud Security**.

Through this project, I did not only learn how to use individual AWS services, but also how to combine them into a system with a clear security objective.

This project helped me become more confident in topics such as:

```text
AWS Security
Security Operations Center
Incident Response
Event-driven Architecture
Serverless Automation
Forensic Evidence Collection
Cloud Monitoring
Security Dashboard
```

It also provides a strong foundation for continuing to study **AWS Security Specialty**, SOC Automation, and Cloud Incident Response.

---

## Acknowledgement

I would like to sincerely thank the mentors, admins, and all community members who supported, reviewed, and shared feedback throughout the project.

The feedback on architecture design, workflow logic, diagram structure, testing strategy, and system optimization helped our team improve the project significantly.

This was truly a memorable experience and an important step forward in my Cloud Security learning journey.

---

## Conclusion

At the end of the AWS CloudSOC project, what I gained was not only a working Proof of Concept, but also the mindset required to design a controlled security system on the cloud.

A good CloudSOC system should not only detect threats, but also:

```text
Respond properly
Preserve evidence
Notify quickly
Control risk
Scale easily
Operate clearly
Clean up safely
```

For anyone learning **AWS Security**, working with **Cloud SOC**, or preparing for the **AWS Security Specialty** certification, this project can be a useful foundation for understanding cloud-based incident response in practice.