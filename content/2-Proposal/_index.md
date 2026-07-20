---
title: "Proposal"
date: 2026-07-19
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Project Proposal: AWS CloudSOC

## Controlled Threat Detection, Investigation, and Incident Response on AWS

### 1. Executive Summary

Our team proposes **AWS CloudSOC**, a Lab / Proof of Concept project that simulates a Security Operations Center workflow on AWS. The system is designed to collect logs, detect suspicious behavior, support investigation, request approval when needed, collect forensic evidence, create EBS snapshots, and isolate affected EC2 instances through Security Group Isolation.

The key value of this proposal is controlled automation. AWS CloudSOC does not isolate every GuardDuty finding automatically. Instead, the response decision is based on finding type, severity, instance identity, the `AutoIsolate=true` tag, Dry-run/Enforce mode, and SOC Analyst approval.

![AWS CloudSOC Architecture](/images/2-Proposal/aws-cloudsoc-architecture.png)

*Figure 1. AWS CloudSOC reference architecture – a Lab / Proof of Concept model for controlled detection, investigation, evidence collection, and EC2 isolation on AWS.*

### 2. Team Members

| Member | Main role |
| --- | --- |
| Tran Thai Nguyen | Requirements analysis, CloudSOC architecture design, report writing, Hugo website completion |
| Duong Ba Dat | AWS service research support, SOC workflow review, diagram validation, submission checklist review |

### 3. Problem Statement

Cloud security incidents often involve multiple telemetry sources: CloudTrail, VPC Flow Logs, GuardDuty findings, EC2 state, Security Group changes, and IAM activity. Without a coordinated workflow, SOC analysts may struggle to prioritize findings, identify impacted resources, preserve evidence, avoid false-positive containment, and maintain an audit trail.

AWS CloudSOC addresses this problem by combining detection, investigation, orchestration, approval, forensic collection, containment, and notification in one controlled workflow.

### 4. Objectives

- Design an event-driven CloudSOC architecture.
- Demonstrate a SOC workflow: Detect → Investigate → Decide → Collect Evidence → Snapshot → Contain → Notify.
- Use AWS managed and serverless services to reduce manual operations.
- Add an approval gate to prevent unsafe automatic isolation.
- Store forensic evidence in S3 and EBS Snapshots.
- Build a professional architecture diagram workshop.
- Deliver the report as a bilingual Hugo website.

### 5. Scope

In scope:

- One AWS Region: `ap-southeast-1`.
- One lab VPC with a Public Subnet.
- One EC2 workload for controlled testing.
- GuardDuty, Security Hub, Detective, EventBridge, Step Functions.
- Systems Manager forensic collection.
- Lambda-based EC2 isolation.
- DynamoDB, S3, CloudWatch, IAM, Config, and KMS.
- SNS, Amazon Q Developer, Slack/Email/SMS for approval and alerting.

Out of scope for this PoC:

- Multi-account SOC.
- Centralized enterprise SIEM.
- Full Multi-AZ production deployment.
- Automated restore after containment.
- Ticketing integrations such as Jira or ServiceNow.

### 6. Proposed Architecture

| Function | AWS services | Role |
| --- | --- | --- |
| Dashboard & Access | Amplify, Cognito, API Gateway, Lambda | SOC portal and authenticated API access |
| Incident Data | DynamoDB | Incident metadata and status |
| Logging & Evidence | CloudTrail, CloudWatch, S3, EBS Snapshot | Audit logs, forensic output, snapshots |
| Detection & Investigation | GuardDuty, Security Hub, Detective | Threat detection and investigation |
| Response Orchestration | EventBridge, Step Functions | Event routing and workflow control |
| Forensic & Containment | Systems Manager, Lambda, Security Groups | Evidence collection and EC2 isolation |
| Notification | SNS, Amazon Q Developer, Slack/Email/SMS | Approval requests and alerts |
| Governance | IAM, Config, KMS | Least privilege, configuration audit, encryption |

Main flow:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Policy Check / Approval
→ Systems Manager Forensics
→ EBS Snapshot
→ Lambda Isolation
→ SNS / Slack / Email Notification
```

### 7. Response Policy

| Condition | Proposed action |
| --- | --- |
| Non-EC2 finding | Store incident and send alert |
| Missing Instance ID | Mark as `NEEDS_REVIEW` |
| Low/Medium severity | Alert only |
| High + `AutoIsolate=true` | Require SOC Analyst approval |
| Critical + `AutoIsolate=true` | Continue automatically depending on policy |
| Missing `AutoIsolate=true` tag | Dry-run or manual review |

### 8. Expected Value

Technical value:

- Demonstrates a realistic SOC workflow on AWS.
- Combines detection, investigation, orchestration, evidence collection, and containment.
- Uses managed/serverless services to reduce infrastructure operations.

Security value:

- Reduces unsafe automation through approval gates.
- Preserves evidence before isolation.
- Applies IAM least privilege and audit-oriented design.
- Supports future extension into production incident response playbooks.

Academic and presentation value:

- Aligns with the Cybersecurity major.
- Provides clear architecture, diagram, checklist, and production roadmap.
- Can be presented to mentors, company reviewers, or technical stakeholders.

### 9. Implementation Plan

| Phase | Work item | Output |
| --- | --- | --- |
| 1 | SOC requirement and scenario analysis | Use cases and response policy |
| 2 | Architecture design | Diagram and AWS service mapping |
| 3 | Dashboard/API design | Amplify, Cognito, API Gateway, Lambda, DynamoDB |
| 4 | Logging and evidence storage | CloudTrail, CloudWatch, S3, KMS |
| 5 | Detection and orchestration | GuardDuty, Security Hub, Detective, EventBridge, Step Functions |
| 6 | Forensic and containment flow | Systems Manager, EBS Snapshot, Lambda, SG-Isolation |
| 7 | Testing and review | Test cases, evidence, checklist |
| 8 | Final report and workshop | Hugo website, proposal, workshop, drawing guide |

### 10. Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| False-positive findings | Wrong resource isolation | Use severity, `AutoIsolate` tag, Dry-run and approval gate |
| Forensic collection failure | Loss of evidence | Collect evidence before isolation; validate SSM Agent and role |
| Over-permissive IAM | Privilege escalation risk | Least privilege roles and scoped permissions |
| Sensitive evidence in S3 | Data exposure | SSE-KMS, bucket policy, block public access |
| Public subnet lab workload | Larger attack surface | Clearly mark as Lab/PoC; move to Private Subnet in production |
| Unexpected cost | Lab account impact | Cleanup checklist and lifecycle policies |

### 11. Production Roadmap

Future production improvements include:

- Move workloads into Private Subnets.
- Add Application Load Balancer and AWS WAF.
- Deploy across multiple Availability Zones.
- Separate Lab/Staging/Production environments.
- Add rollback approval for Security Group restoration.
- Apply lifecycle policies for S3 evidence and EBS snapshots.
- Use AWS CDK, Terraform, or CloudFormation for repeatable deployment.
- Integrate ticketing/SIEM systems for enterprise operation.

### 12. Deliverables

- Bilingual Hugo report website.
- Formal AWS CloudSOC proposal.
- Detailed architecture and SOC workflow report.
- Architecture diagram workshop.
- CloudSOC diagram displayed directly on the website.
- Review checklist and production roadmap.

### 13. Acceptance Criteria

The project is considered successful when:

- The architecture clearly shows Dashboard, Logging, Detection/Response, Governance, and VPC Workload areas.
- The workflow follows: Detect → Investigate → Decide → Collect Evidence → Snapshot → Contain → Notify.
- The approval gate is clearly justified.
- Forensic collection happens before isolation.
- The response policy for GuardDuty findings is documented.
- The Lab/PoC limitation and production roadmap are clearly stated.
- The documentation is clear enough for another reader to reproduce the diagram and explain the system.

### 14. Approval Request

Our team respectfully proposes AWS CloudSOC as a suitable project for FCAJ evaluation and company-facing presentation. The project demonstrates cloud security thinking, incident response design, AWS service integration, and controlled automation.

AWS CloudSOC is not only a collection of AWS services; it is an integrated model for SOC operations on AWS:

```text
Collect Logs
→ Detect Threats
→ Aggregate Findings
→ Investigate
→ Classify
→ Approve if needed
→ Collect Forensics
→ Snapshot
→ Isolate EC2
→ Store Evidence
→ Update Dashboard
→ Notify SOC Analyst
```

