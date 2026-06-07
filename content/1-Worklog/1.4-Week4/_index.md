---
title: "Week 4 Worklog"
date: 2026-05-30
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Week 4 Overview (05/30 – 06/05/2026)

Week 4 completed **Lab 19 – Setting up VPC Peering** (steps 03–07). After initializing 2 VPCs via CloudFormation in Week 3, this week focused on **network connectivity configuration**: Network ACL, VPC Peering Connection, Route Tables, Cross-Peer DNS, and resource cleanup. This lab is particularly relevant to my **Cyber Security** major as it covers network segmentation, traffic control, and subnet-level security.

### Week 4 Objectives

* Configure **Network ACL** to control inter-VPC traffic.
* Create and activate **VPC Peering Connection** between My VPC and HG VPC.
* Configure **Route Tables** for cross-VPC routing.
* Enable **Cross-Peer DNS** for private IP hostname resolution.
* **Cleanup** all resources to avoid unnecessary charges.

### Work Completed

| Day | Detailed Tasks | Start Date | Completion Date | Status | Reference |
| --- | --- | --- | --- | --- | --- |
| 2 (05/30) | **Lab 19 – 03:** Updated HG VPC NACL Rule 100 Source → `172.31.0.0/16` | 05/30/2026 | 05/30/2026 | ✅ | [Step 03](https://000019.awsstudygroup.com/3-updatenetworkacl/) |
| 3 (05/31) | **Lab 19 – 04:** Created VPC Peering; Accepted request; status Active | 05/31/2026 | 05/31/2026 | ✅ | [Step 04](https://000019.awsstudygroup.com/4-vpcpeering/) |
| 4 (06/01) | **Lab 19 – 05:** Added routes `10.10.0.0/16` and `172.31.0.0/16` to both route tables | 06/01/2026 | 06/01/2026 | ✅ | [Step 05](https://000019.awsstudygroup.com/5-routetable/) |
| 5 (06/02) | **Lab 19 – 06:** Enabled Cross-Peer DNS; enabled DNS hostnames on both VPCs | 06/02/2026 | 06/02/2026 | ✅ | [Step 06](https://000019.awsstudygroup.com/6-crosspeerdns/) |
| 6 (06/03) | Verified connectivity: ping private IP and public DNS between EC2 instances | 06/03/2026 | 06/03/2026 | ✅ | [Lab 19](https://000019.awsstudygroup.com/) |
| 7 (06/04) | **Lab 19 – 07:** Cleanup – deleted peering, terminated EC2, deleted CloudFormation stacks | 06/04/2026 | 06/05/2026 | ✅ | [Step 07](https://000019.awsstudygroup.com/7-cleanup/) |

### Step-by-Step Summary

**Step 03 – Network ACL:** Restricted HG VPC inbound traffic to My VPC CIDR only. Verified Internet ping to HG VPC public IP failed.

**Step 04 – VPC Peering:** Created peering between My VPC (`172.31.0.0/16`) and HG VPC (`10.10.0.0/16`); accepted request; status became Active.

**Step 05 – Route Tables:** Added bidirectional routes via peering connection. Private IP ping from My VPC EC2 to HG VPC EC2 succeeded.

**Step 06 – Cross-Peer DNS:** Enabled Requester and Accepter DNS resolution. Public DNS ping resolved to private IP successfully.

**Step 07 – Cleanup:** Deleted peering → terminated EC2 → deleted CloudFormation stacks. Verified Billing Dashboard shows no running resources.

### Achievements

* Completed **Lab 19** steps 03–07 – full VPC Peering lab finished.
* Understood **Security Group** (stateful, instance) vs **Network ACL** (stateless, subnet).
* Configured **VPC Peering** with private connectivity over AWS backbone.
* Enabled **Cross-Peer DNS** for secure cross-VPC hostname resolution.
* Practiced proper **cleanup** procedures to avoid post-lab charges.

### Cyber Security Skills Gained

| Skill | Application |
| --- | --- |
| Network segmentation | VPC isolation, NACL and SG traffic control |
| Defense in depth | Combined NACL + Security Group layers |
| Private connectivity | VPC Peering instead of Internet exposure |
| DNS security | Cross-Peer DNS prevents public IP traffic leak |

### Week 5 Plan

* Start **Lab 20 – AWS Transit Gateway** for multi-VPC connectivity.
* Continue the **Optimizing** track on [Cloud Journey](https://cloudjourney.awsstudygroup.com/3-optimize/).
