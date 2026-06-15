---
title: "Week 5 Worklog"
date: 2026-06-06
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Overview (06/06 – 12/06/2026)

In week five, I moved on to **Lab 20 – AWS Transit Gateway** after completing VPC Peering in week 4. Unlike peering (two VPCs only), Transit Gateway connects **multiple VPCs** through a central hub. I also practiced **AWS Systems Manager** and **Session Manager** to manage EC2 without opening SSH port 22.

### Week 5 Objectives

* Complete **Lab 20 – AWS Transit Gateway** (CloudFormation → attachments → route tables → testing).
* Practice **AWS Systems Manager** and **Session Manager**.
* Compare **VPC Peering** vs **Transit Gateway** for network scaling.

### Tasks Completed

| Step | Task | Status | Link |
| --- | --- | --- | --- |
| 02.1 | Launch CloudFormation stack (3 VPCs + Transit Gateway) | ✅ | [Lab 20](https://000020.awsstudygroup.com/) |
| 03 | Create VPC attachments to Transit Gateway | ✅ | [Playlist](https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i) |
| 04 | Configure Transit Gateway route tables | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/3-optimize/) |
| 05 | Test cross-VPC connectivity via TGW | ✅ | [Lab 20](https://000020.awsstudygroup.com/) |
| 06 | Systems Manager: IAM role, Run Command | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 07 | Session Manager: connect without port 22 | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 08 | Cleanup stacks and resources | ✅ | [Lab 20](https://000020.awsstudygroup.com/) |

### Achievements

* Completed **Lab 20** and learned **Systems Manager / Session Manager**.
* Understood Transit Gateway as a multi-VPC hub vs one-to-one VPC Peering.
* Managed EC2 without SSH — reduced attack surface.
* Cleaned up resources in the correct order to avoid extra charges.

### Challenges

* Attachments stayed **pending** — had to wait before testing connectivity.
* Initial ping failures — missing route propagation or Security Group rules.
* Session Manager failed until IAM role `AmazonSSMManagedInstanceCore` was attached.

### Next Week

* Continue **Cloud Journey – Optimize** labs.
* Review VPC, TGW, and SSM before moving to new topics.
