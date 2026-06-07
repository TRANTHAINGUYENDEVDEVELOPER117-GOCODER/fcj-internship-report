---
title: "Week 3 Worklog"
date: 2026-05-23
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

### Week 3 Overview (05/23 – 05/29/2026)

Week 3 marked the transition from **Module 01 (Foundation)** to **Module 02 (Optimizing the System)**. I started **Lab 19 – Setting up VPC Peering**, focusing on **Infrastructure as Code (IaC)** with **AWS CloudFormation** to provision network infrastructure instead of manual console setup.

### Week 3 Objectives

* Understand the **Optimizing** track: Security, Reliability, Performance, Cost, Operational Excellence.
* Learn and practice **AWS CloudFormation** template-based deployment.
* Complete Lab 19 steps 02.0 (theory) and 02.1 (initialize 2 VPCs via CloudFormation).

### Work Completed

| Day | Detailed Tasks | Start Date | Completion Date | Status | Reference |
| --- | --- | --- | --- | --- | --- |
| 2 (05/23) | Studied **Module 02** on [Cloud Journey – Optimize](https://cloudjourney.awsstudygroup.com/3-optimize/) | 05/23/2026 | 05/23/2026 | ✅ | [FCJ Playlist](https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i) |
| 3 (05/24) | **Lab 19 – 02.0:** VPC Peering overview, NACL, Cross-Peer DNS architecture | 05/24/2026 | 05/24/2026 | ✅ | [Lab 19](https://000019.awsstudygroup.com/) |
| 4 (05/25) | **Lab 19 – 02.1:** Downloaded `VPCTemplate.yaml`; created **My VPC** stack | 05/25/2026 | 05/25/2026 | ✅ | [Initialize CF](https://000019.awsstudygroup.com/2-prerequiste/2.1-launchcloudformation/) |
| 5 (05/26) | **Lab 19 – 02.1:** Created **HG VPC** stack with different CIDR | 05/26/2026 | 05/26/2026 | ✅ | [Initialize CF](https://000019.awsstudygroup.com/2-prerequiste/2.1-launchcloudformation/) |
| 6 (05/27) | Acknowledged IAM capabilities; waited for `CREATE_COMPLETE` (~10 min/stack) | 05/27/2026 | 05/27/2026 | ✅ | [CloudFormation Docs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.Walkthrough.html) |
| 7 (05/28) | Verified stack **Outputs**; confirmed VPC, subnets, EC2 in VPC Console | 05/28/2026 | 05/29/2026 | ✅ | [Lab 19](https://000019.awsstudygroup.com/) |

### Lab 19 – 02.1 Details

**Stack My VPC:** VpcCIDR `172.31.0.0/16`, EnvironmentName `My VPC`
**Stack HG VPC:** VpcCIDR `10.10.0.0/16`, EnvironmentName `HG VPC`

Both stacks deployed via CloudFormation Console → Upload template → Configure parameters → Acknowledge IAM → `CREATE_COMPLETE`.

### IaC Concepts Learned

| Concept | Meaning |
| --- | --- |
| Template | YAML/JSON file describing AWS resources |
| Stack | Managed collection of resources as one unit |
| Parameters | Input values (CIDR, environment name) |
| Resources | Actual AWS resources (VPC, EC2, SG) |
| Outputs | Returned values (IDs, IPs) after deployment |

### Achievements

* Completed **Lab 19 – 02.0** and **02.1**.
* Successfully deployed **2 CloudFormation Stacks**.
* Understood IaC benefits: reusable templates, consistent deployment, easy cleanup.
* Ready for VPC Peering configuration (steps 03–07) in Week 4.

### Challenges & Solutions

* **CREATE_FAILED:** Missing IAM capability acknowledgment → re-submitted with all checkboxes ticked.
* **Long wait time:** Each stack took 5–10 minutes; monitored Events tab for progress.
