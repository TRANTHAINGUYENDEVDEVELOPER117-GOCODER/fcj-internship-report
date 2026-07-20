---
title: "CloudSOC Architecture Diagram Workshop"
date: 2026-07-11
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

# Drawing the AWS CloudSOC Architecture Diagram

This workshop guides learners through drawing a professional AWS CloudSOC architecture diagram using draw.io / diagrams.net and AWS Architecture Icons.

### Target diagram

Use the following diagram as the reference layout for the workshop.

![AWS CloudSOC Architecture](/images/5-Workshop/cloudsoc-architecture.svg)

### Practice modules

1. [Prepare Drawing Tools](5.3.1-Prepare/)
2. [Build the Canvas Layout](5.3.2-Canvas-Layout/)
3. [Draw AWS Service Groups](5.3.3-Service-Groups/)
4. [Connect Incident Flows](5.3.4-Connect-Flows/)
5. [Export and Review](5.3.5-Export-Review/)
6. [Detailed Drawing Specification](5.3.6-Drawing-Spec/)

### Team members

| Member | Workshop role |
| --- | --- |
| Tran Thai Nguyen | Architecture explanation, SOC workflow presentation, workshop documentation |
| Duong Ba Dat | Diagram review, AWS service validation, checklist review |

### Diagram groups

| Group | Suggested color | Purpose |
| --- | --- | --- |
| Dashboard & Access | Teal | Analyst access, Cognito, API, dashboard |
| Logging & Evidence | Blue | CloudTrail, CloudWatch, S3, EBS Snapshot |
| Threat Detection & Response | Orange | GuardDuty, EventBridge, Step Functions, SSM, Lambda, SNS |
| Security & Governance | Light red | IAM, Config, KMS |
| Workload VPC | Light yellow | EC2 lab workload and security groups |

### Required flows

- Threat Actor → Internet → Internet Gateway → EC2.
- SOC Analyst → Amplify → Cognito → API Gateway → Dashboard API Lambda.
- GuardDuty → EventBridge → Step Functions.
- Step Functions → SNS for approval.
- Step Functions → Systems Manager for forensic collection.
- Systems Manager → S3 and EBS Snapshot.
- Incident Response Lambda → EC2 with `Apply Isolation – Replace Security Group`.

Export the final diagram as PNG 2x or PDF/SVG for reports and presentations.

