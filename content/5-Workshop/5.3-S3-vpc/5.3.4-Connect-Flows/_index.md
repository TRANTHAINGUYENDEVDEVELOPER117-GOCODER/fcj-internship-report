---
title: "Connect Incident Flows"
date: 2026-07-17
weight: 4
chapter: false
pre: " <b> 5.3.4. </b> "
---

# Connect Incident Flows

The diagram must show these main flows:

- SOC Analyst → Amplify → Cognito → API Gateway → Dashboard API Lambda.
- GuardDuty → EventBridge → Step Functions.
- Step Functions → SNS → Amazon Q Developer → Slack Channel.
- Step Functions → Systems Manager → S3 / EBS Snapshot.
- Step Functions → Incident Response Lambda → EC2.
- Incident Response Lambda → S3 / DynamoDB / SNS.
- IAM/KMS/Config relationships as dashed governance lines.

Always collect forensic evidence before applying EC2 isolation.

