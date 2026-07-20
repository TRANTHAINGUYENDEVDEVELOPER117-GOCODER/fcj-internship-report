---
title: "Blogs Posted"
date: 2026-07-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

This section introduces the blog posts shared during the implementation of the **AWS CloudSOC – Threat Detection, Investigation, and Incident Response System on AWS** project.

The blogs summarize the project progress, technical workflow, key AWS services used, and practical lessons learned while building a Cloud Security Operations Center Proof of Concept on AWS.

The main topics include **Cloud Security**, **Security Operations Center**, **Incident Response**, **Amazon GuardDuty**, **Amazon EventBridge**, **AWS Step Functions**, **AWS Lambda**, **AWS Systems Manager**, **Amazon S3**, **Amazon DynamoDB**, and **Amazon SNS**.

---

### [Blog 1 - Completing the AWS CloudSOC Proof of Concept](3.1-Blog1/)

This blog introduces the completion of the **AWS CloudSOC Proof of Concept** after more than two weeks of implementation. It explains the overall goal of the project, the main architecture, and how the system can detect suspicious activities such as port scanning, SSH brute-force attempts, and access from suspicious IP addresses.

The blog also highlights how AWS services such as **Amazon GuardDuty**, **Amazon EventBridge**, **AWS Step Functions**, **AWS Lambda**, **AWS Systems Manager**, **Amazon S3**, **Amazon DynamoDB**, and **Amazon SNS** work together to create an end-to-end incident response workflow.

---

### [Blog 2 - A Smart and Controlled Incident Response Workflow in AWS CloudSOC](3.2-Blog2/)

This blog focuses on the incident response workflow of the AWS CloudSOC system. It explains how a security finding from **Amazon GuardDuty** is processed through **Amazon EventBridge** and **AWS Step Functions**, then handled based on severity, resource type, `AutoIsolate=true` tag, and Dry-run mode.

The blog also describes the controlled response process, including SOC Analyst approval, forensic evidence collection with **AWS Systems Manager**, EBS Snapshot creation, EC2 isolation using `SG-Isolation`, evidence storage in **Amazon S3**, incident status updates in **Amazon DynamoDB**, and alert delivery through **Amazon SNS**, Email, and Slack.

---

### [Blog 3 - Completing the AWS CloudSOC Project: The Most Valuable Lessons Learned](3.3-Blog3/)

This blog summarizes the most valuable lessons learned after completing the AWS CloudSOC project. It discusses the difference between lab and production environments, the importance of controlled automation, least privilege IAM design, forensic evidence preservation, logging, cost control, and real-world testing.

The blog also reflects on the value of the project for learning **AWS Security**, **Cloud SOC**, **Incident Response**, **Event-driven Architecture**, and **Security Automation**. It serves as a conclusion to the blog series and highlights how the project helped strengthen practical cloud security knowledge.

---

## Summary

Through these three blog posts, the AWS CloudSOC project is presented from three perspectives:

```text
Blog 1: Project overview and Proof of Concept completion
Blog 2: Incident response workflow and controlled automation
Blog 3: Lessons learned and practical experience
```

Together, these blogs provide a complete view of how the project was designed, implemented, tested, and evaluated as a practical Cloud Security lab on AWS.