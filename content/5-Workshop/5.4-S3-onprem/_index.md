---
title: "Diagram Review Checklist"
date: 2026-07-11
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

# AWS CloudSOC Diagram Review Checklist

Before submitting the workshop, verify that the diagram includes:

- Clear title, author, date, and version.
- AWS Cloud, Region, VPC, and Subnet boundaries.
- Standard AWS icons or consistent shapes.
- Color-coded groups for Dashboard, Logging, Detection/Response, and Governance.
- Labeled arrows such as `Invoke API`, `Start Workflow`, `Collect Evidence`, `Create Snapshot`, `Approval Callback`, and `Apply Isolation`.
- A clear SOC flow: Detect → Investigate → Decide → Collect Evidence → Contain → Notify.
- A note that the current architecture is a Lab / Proof of Concept.
- A production improvement note: Private Subnet, ALB, WAF, NAT Gateway, Multi-AZ, and IaC.

The diagram must show evidence collection before isolation. This is important because security group isolation can break Systems Manager connectivity.

