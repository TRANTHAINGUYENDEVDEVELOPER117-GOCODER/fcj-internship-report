---
title: "System Architecture and SOC Workflow"
date: 2026-07-11
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

# AWS CloudSOC Architecture

### Architecture principles

- Event-driven incident response with GuardDuty, EventBridge, and Step Functions.
- Controlled response with policy checks and manual approval.
- Evidence-first handling: collect forensics and create an EBS snapshot before isolation.
- Least-privilege IAM roles for Lambda, Step Functions, and EC2 Systems Manager access.
- Auditability through CloudWatch, S3, DynamoDB, CloudTrail, and AWS Config.

### Main workflow

```text
GuardDuty finding
→ EventBridge
→ Step Functions
→ Policy decision
→ Approval if needed
→ Systems Manager forensic collection
→ EBS Snapshot
→ Incident Response Lambda
→ Security Group Isolation
→ SNS notification
```

### Response policy

| Condition | Proposed action |
| --- | --- |
| Non-EC2 finding | Alert only |
| Missing Instance ID | Needs review |
| Low/Medium severity | Alert only |
| High + `AutoIsolate=true` | Manual approval |
| Critical + `AutoIsolate=true` | Auto/approval depending on policy |
| Missing `AutoIsolate=true` | Dry-run or manual review |

### Important note

Do not isolate the EC2 instance before evidence collection. Replacing the workload security group with an isolation security group can break Systems Manager connectivity and reduce forensic visibility.

