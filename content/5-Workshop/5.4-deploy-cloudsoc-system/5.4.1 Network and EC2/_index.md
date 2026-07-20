---
title : "Network and EC2 Workload"
date : 2026-07-01
weight : 1
chapter : false
pre : " <b> 5.4.1. </b> "
---

#### Network and EC2 Workload

In this section, you will deploy the **Network and EC2 Workload** layer for the AWS CloudSOC system. This layer provides the basic network environment, the target EC2 instance, and the security groups required for incident isolation.

The EC2 instance in this section acts as the test workload for simulating suspicious activities such as port scanning or SSH brute-force attempts. Later, services such as GuardDuty, EventBridge, Step Functions, and Lambda will use this EC2 instance to test the threat detection and incident response workflow.

---

#### Objectives

After completing this section, you will have:

+ An Amazon VPC for the CloudSOC Lab environment.
+ A Public Subnet for deploying the EC2 workload.
+ An Internet Gateway for internet connectivity.
+ A Route Table for the Public Subnet.
+ An EC2 instance used as the target workload.
+ A normal security group named `SG-Workload`.
+ An isolation security group named `SG-Isolation`.
+ An IAM Role that allows EC2 to connect to AWS Systems Manager.

---

#### Network and EC2 Architecture

The following diagram illustrates the Network and EC2 Workload layer in the AWS CloudSOC system.

![Network and EC2 Workload](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/network-ec2-workload.png)

The main deployment flow is:

```text
AWS Region
→ VPC
→ Public Subnet
→ Internet Gateway
→ Route Table
→ EC2 Workload
→ SG-Workload / SG-Isolation
```

In this workshop, the EC2 instance is placed in a Public Subnet to simplify attack simulation and GuardDuty finding testing. This design is intended for a Lab / Proof of Concept environment and is not a complete production architecture.

---

#### Recommended Configuration

You can use the following configuration values for this workshop:

| Component | Recommended Value |
|---|---|
| Region | `ap-southeast-1` |
| VPC Name | `cloudsoc-vpc` |
| VPC CIDR | `10.0.0.0/16` |
| Public Subnet Name | `cloudsoc-public-subnet` |
| Public Subnet CIDR | `10.0.1.0/24` |
| Internet Gateway | `cloudsoc-igw` |
| Route Table | `cloudsoc-public-rtb` |
| EC2 Name | `cloudsoc-workload-ec2` |
| Normal Security Group | `SG-Workload` |
| Isolation Security Group | `SG-Isolation` |
| EC2 IAM Role | `CloudSOC-EC2-SSM-Role` |

---

#### Step 1: Create a VPC

Open the AWS Management Console and go to the **VPC** service.

Choose:

```text
VPC → Your VPCs → Create VPC
```

Configure the VPC as follows:

| Field | Value |
|---|---|
| Name tag | `cloudsoc-vpc` |
| IPv4 CIDR block | `10.0.0.0/16` |
| IPv6 CIDR block | No IPv6 CIDR block |
| Tenancy | Default |

Then choose **Create VPC**.

Expected result:

```text
The cloudsoc-vpc VPC is created successfully.
```

![Create VPC](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/create-vpc.png)

---

#### Step 2: Create a Public Subnet

In the VPC Console, choose:

```text
Subnets → Create subnet
```

Select the VPC that you created:

```text
cloudsoc-vpc
```

Configure the subnet:

| Field | Value |
|---|---|
| Subnet name | `cloudsoc-public-subnet` |
| Availability Zone | Select one AZ in `ap-southeast-1` |
| IPv4 subnet CIDR block | `10.0.1.0/24` |

Then choose **Create subnet**.

Expected result:

```text
The cloudsoc-public-subnet Public Subnet is created in cloudsoc-vpc.
```

![Create Public Subnet](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/create-public-subnet.png)

---

#### Step 3: Enable Auto-assign Public IPv4

To allow EC2 instances in the Public Subnet to automatically receive a Public IPv4 address, enable Auto-assign public IPv4.

Select the subnet:

```text
cloudsoc-public-subnet
```

Then choose:

```text
Actions → Edit subnet settings
```

Enable the option:

```text
Enable auto-assign public IPv4 address
```

Choose **Save**.

Expected result:

```text
Auto-assign public IPv4 is enabled for the Public Subnet.
```

---

#### Step 4: Create an Internet Gateway

In the VPC Console, choose:

```text
Internet Gateways → Create internet gateway
```

Configure the Internet Gateway:

| Field | Value |
|---|---|
| Name tag | `cloudsoc-igw` |

Choose **Create internet gateway**.

After the Internet Gateway is created, select it and choose:

```text
Actions → Attach to VPC
```

Select the VPC:

```text
cloudsoc-vpc
```

Then choose **Attach internet gateway**.

Expected result:

```text
The cloudsoc-igw Internet Gateway is attached to cloudsoc-vpc.
```

![Create Internet Gateway](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/create-internet-gateway.png)

---

#### Step 5: Create a Route Table for the Public Subnet

In the VPC Console, choose:

```text
Route Tables → Create route table
```

Configure the route table:

| Field | Value |
|---|---|
| Name | `cloudsoc-public-rtb` |
| VPC | `cloudsoc-vpc` |

Then choose **Create route table**.

Next, select the route table and open the **Routes** tab.

Choose:

```text
Edit routes → Add route
```

Add the following route:

| Destination | Target |
|---|---|
| `0.0.0.0/0` | `cloudsoc-igw` |

Choose **Save changes**.

Then open the **Subnet associations** tab and choose:

```text
Edit subnet associations
```

Select the subnet:

```text
cloudsoc-public-subnet
```

Choose **Save associations**.

Expected result:

```text
The Public Subnet has a 0.0.0.0/0 route to the Internet Gateway.
```

![Public Route Table](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/public-route-table.png)

---

#### Step 6: Create an IAM Role for EC2 Systems Manager

The EC2 instance needs an IAM Role to connect to AWS Systems Manager. This allows Systems Manager to run commands and collect forensic evidence in later sections.

Open the **IAM** service and choose:

```text
Roles → Create role
```

Configure the role:

| Field | Value |
|---|---|
| Trusted entity type | AWS service |
| Use case | EC2 |

In the permissions section, attach the following policy:

```text
AmazonSSMManagedInstanceCore
```

Set the role name:

```text
CloudSOC-EC2-SSM-Role
```

Then choose **Create role**.

Expected result:

```text
The CloudSOC-EC2-SSM-Role IAM Role is created successfully.
```

![EC2 SSM Role](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/ec2-ssm-role.png)

---

#### Step 7: Create the SG-Workload Security Group

`SG-Workload` is the initial security group attached to the EC2 instance. This security group allows the EC2 instance to operate in its normal state.

In the EC2 Console, choose:

```text
Security Groups → Create security group
```

Configure the security group:

| Field | Value |
|---|---|
| Security group name | `SG-Workload` |
| Description | `Security group for CloudSOC workload EC2` |
| VPC | `cloudsoc-vpc` |

Recommended inbound rules for the lab environment:

| Type | Protocol | Port | Source |
|---|---|---|---|
| SSH | TCP | 22 | My IP |

Outbound rules:

| Type | Protocol | Port | Destination |
|---|---|---|---|
| All traffic | All | All | `0.0.0.0/0` |

> **Note:** SSH should only be opened from **My IP** to reduce risk. Avoid opening SSH to `0.0.0.0/0` unless it is required for testing.

Expected result:

```text
The SG-Workload security group is created successfully.
```

![SG Workload](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/sg-workload.png)

---

#### Step 8: Create the SG-Isolation Security Group

`SG-Isolation` is the security group used to isolate the EC2 instance during an incident. This security group is created in advance in the VPC and does not allow inbound or outbound traffic.

In the EC2 Console, choose:

```text
Security Groups → Create security group
```

Configure the security group:

| Field | Value |
|---|---|
| Security group name | `SG-Isolation` |
| Description | `Isolation security group for compromised EC2 instance` |
| VPC | `cloudsoc-vpc` |

Inbound rules:

```text
Do not add any inbound rule.
```

Outbound rules:

```text
Remove the default outbound rule 0.0.0.0/0.
```

Expected result:

```text
SG-Isolation has no inbound rules and no outbound rules.
```

![SG Isolation](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/sg-isolation.png)

> **Note:** When a new security group is created, AWS usually creates a default outbound rule that allows all traffic. Remove this outbound rule so that `SG-Isolation` can block outbound traffic.

---

#### Step 9: Launch the EC2 Workload

Open the **EC2** service and choose:

```text
Instances → Launch instances
```

Configure the EC2 instance:

| Field | Value |
|---|---|
| Name | `cloudsoc-workload-ec2` |
| AMI | Amazon Linux 2023 |
| Instance type | `t2.micro` or `t3.micro` |
| Key pair | Select an existing key pair or create a new one |
| VPC | `cloudsoc-vpc` |
| Subnet | `cloudsoc-public-subnet` |
| Auto-assign public IP | Enable |
| Security Group | `SG-Workload` |
| IAM instance profile | `CloudSOC-EC2-SSM-Role` |

In **Advanced details**, attach the IAM instance profile:

```text
CloudSOC-EC2-SSM-Role
```

Then choose **Launch instance**.

Expected result:

```text
The cloudsoc-workload-ec2 EC2 instance is launched successfully.
```

![Launch EC2](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/launch-ec2.png)

---

#### Step 10: Add the AutoIsolate Tag to EC2

The `AutoIsolate=true` tag is used to identify which EC2 instance is allowed to be isolated automatically when a serious finding occurs.

Select the EC2 instance:

```text
cloudsoc-workload-ec2
```

Open the **Tags** tab, choose **Manage tags**, and add the following tags:

| Key | Value |
|---|---|
| `AutoIsolate` | `true` |
| `Project` | `AWS-CloudSOC` |
| `Environment` | `Lab` |

Expected result:

```text
The EC2 instance has the AutoIsolate=true tag.
```

![EC2 Tags](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/ec2-tags.png)

---

#### Step 11: Check Systems Manager Connectivity

After the EC2 instance is running, verify that it can connect to AWS Systems Manager.

Open **Systems Manager** and choose:

```text
Fleet Manager
```

Or:

```text
Session Manager → Start session
```

Check whether the `cloudsoc-workload-ec2` instance appears in the list of managed instances.

Expected result:

```text
The EC2 instance appears in Systems Manager Managed Nodes.
```

![SSM Managed Instance](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.1-network-and-ec2/ssm-managed-instance.png)

If the EC2 instance does not appear in Systems Manager, check the following:

+ The EC2 instance has the `CloudSOC-EC2-SSM-Role` IAM Role attached.
+ The EC2 instance has outbound internet access.
+ `SG-Workload` allows outbound traffic.
+ The Public Subnet has a `0.0.0.0/0` route to the Internet Gateway.
+ The EC2 instance has a Public IPv4 address.
+ The SSM Agent is running on the instance.

---

#### Step 12: Check the Security Group Status

Verify that the EC2 instance is currently using the normal workload security group:

```text
cloudsoc-workload-ec2 → Security → Security groups
```

Expected result:

```text
The EC2 instance is attached to SG-Workload.
SG-Isolation has been created but is not attached to the EC2 instance yet.
```

In later sections, Lambda will perform the isolation action by replacing the security group:

```text
SG-Workload → SG-Isolation
```

---

#### Completion Result

After completing this section, you have deployed the Network and EC2 Workload layer for the AWS CloudSOC system.

Expected results:

- [ ] VPC `cloudsoc-vpc` is created.
- [ ] Public Subnet `cloudsoc-public-subnet` is created.
- [ ] Internet Gateway `cloudsoc-igw` is attached to the VPC.
- [ ] Route Table `cloudsoc-public-rtb` has a route to the Internet Gateway.
- [ ] EC2 instance `cloudsoc-workload-ec2` is running.
- [ ] EC2 is attached to `SG-Workload`.
- [ ] Security group `SG-Isolation` is created with no inbound or outbound rules.
- [ ] EC2 has the IAM Role `CloudSOC-EC2-SSM-Role`.
- [ ] EC2 appears in AWS Systems Manager.
- [ ] EC2 has the tag `AutoIsolate=true`.

---

#### Summary

In this section, you created the basic network environment for the CloudSOC Lab, including VPC, Public Subnet, Internet Gateway, Route Table, EC2 instance, and two important security groups.

`SG-Workload` is used when the EC2 instance is operating normally. `SG-Isolation` is prepared for isolating the EC2 instance when the system detects a serious incident and response is allowed.

In the next section, you will configure **Logging and Evidence Storage** to collect logs, store evidence, and prepare data for incident investigation.