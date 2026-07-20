---
title: "Detailed Drawing Specification"
date: 2026-07-17
weight: 6
chapter: false
pre: " <b> 5.3.6. </b> "
---

# Detailed Drawing Specification

This page provides a precise checklist for drawing the AWS CloudSOC diagram in draw.io.

### Main layout

| Area | Position | Style |
| --- | --- | --- |
| AWS Cloud | Outer boundary | Light gray fill, black border |
| AWS Region | Inside AWS Cloud | Teal dashed border |
| VPC / AZ / Public Subnet | Left-middle | Purple VPC, light AZ, yellow subnet |
| SOC Dashboard & Access | Top-right | Teal group |
| Logging & Evidence Storage | Middle-right | Blue group |
| Threat Detection & Response | Bottom-right | Orange group |
| Security, Compliance & Governance | Bottom-left | Light red group |
| SOC Analyst / Slack / Email | Far-right | External actors/channels |

### Required arrows

| From | To | Label | Style |
| --- | --- | --- | --- |
| Threat Actor | EC2 | `Attack Traffic` | Black |
| SOC Analyst | Amplify | `HTTPS Access` | Black |
| Amplify | Cognito | `Sign In` | Black |
| API Gateway | Dashboard API Lambda | `Invoke Lambda` | Black |
| Dashboard API Lambda | Step Functions | `Approval Callback` | Purple |
| GuardDuty | EventBridge | `Security Finding` | Orange |
| EventBridge | Step Functions | `Start Workflow` | Orange |
| Step Functions | SNS | `Request Approval` | Purple |
| SNS | Amazon Q Developer / Slack | `Forward to Slack` | Purple |
| Step Functions | Systems Manager | `Collect Evidence` | Black |
| Systems Manager | S3 / EBS Snapshot | `Store Forensics / Create Snapshot` | Gray dashed |
| Step Functions | Incident Response Lambda | `Invoke Isolation` | Red |
| Incident Response Lambda | EC2 | `Apply Isolation - Replace Security Group` | Red |
| IAM | Lambda / Step Functions / EC2 | `Execution / Workflow / SSM Role` | Gray dashed |
| KMS | S3 | `Encrypt Evidence` | Gray dashed |
| Config | EC2 / Security Group | `Configuration Changes` | Gray dashed |

### Final logic

The diagram must clearly tell this story:

```text
Detect → Investigate → Decide → Collect Evidence → Snapshot → Isolate → Notify
```

Evidence collection must be shown before EC2 isolation.

