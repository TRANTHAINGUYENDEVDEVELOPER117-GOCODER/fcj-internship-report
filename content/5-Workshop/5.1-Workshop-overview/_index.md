---
title: "Detailed AWS CloudSOC Project Report"
date: 2026-07-11
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

# AWS CloudSOC Project Report

**Project:** Design and implement AWS CloudSOC – controlled incident detection, investigation, and response on AWS  
**Team:** Tran Thai Nguyen, Duong Ba Dat  
**University/Class:** HUTECH – 22DTHB1  
**Major:** Cybersecurity  
**Program:** AWS Vietnam FCJ Workforce Bootcamp 2026  
**Date:** July 2026

### Team roles

| Member | Main responsibility |
| --- | --- |
| Tran Thai Nguyen | Overall architecture, report writing, workshop documentation, Hugo website completion |
| Duong Ba Dat | AWS service review, SOC workflow validation, architecture diagram review, final checklist support |

### Objective

AWS CloudSOC simulates a Security Operations Center workflow on AWS. It detects suspicious activity, investigates findings, requests analyst approval when needed, collects forensic evidence, and isolates an affected EC2 instance in a controlled way.

### Scope

This is a **Lab / Proof of Concept** architecture. It uses one AWS Region, one lab VPC, one EC2 workload, GuardDuty findings, EventBridge, Step Functions, Systems Manager, Lambda, SNS, DynamoDB, S3, CloudWatch, IAM, Config, and KMS.

### Main value

The project demonstrates a complete SOC flow:

```text
Detect → Investigate → Decide → Collect Evidence → Create Snapshot → Contain → Notify → Review
```

The most important design choice is the approval gate. The system does not isolate every finding automatically; it checks severity, instance ID, the `AutoIsolate=true` tag, and the configured response policy first.

