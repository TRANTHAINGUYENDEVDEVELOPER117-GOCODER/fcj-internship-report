---
title : "Network and EC2 Workload"
date : 2026-07-01
weight : 1
chapter : false
pre : " <b> 5.4.1. </b> "
---

#### Network and EC2 Workload

Trong pháº§n nÃ y, chÃºng ta sáº½ triá»ƒn khai lá»›p **Network and EC2 Workload** cho há»‡ thá»‘ng AWS CloudSOC. ÄÃ¢y lÃ  lá»›p ná»n táº£ng dÃ¹ng Ä‘á»ƒ táº¡o mÃ´i trÆ°á»ng máº¡ng, triá»ƒn khai EC2 instance má»¥c tiÃªu vÃ  chuáº©n bá»‹ security group phá»¥c vá»¥ cho quÃ¡ trÃ¬nh cÃ´ láº­p sá»± cá»‘.

EC2 instance trong pháº§n nÃ y sáº½ Ä‘Ã³ng vai trÃ² lÃ  workload thá»­ nghiá»‡m Ä‘á»ƒ mÃ´ phá»ng cÃ¡c hÃ nh vi Ä‘Ã¡ng ngá» nhÆ° port scanning hoáº·c SSH brute-force. Sau Ä‘Ã³, cÃ¡c dá»‹ch vá»¥ nhÆ° GuardDuty, EventBridge, Step Functions vÃ  Lambda sáº½ sá»­ dá»¥ng EC2 nÃ y Ä‘á»ƒ kiá»ƒm thá»­ luá»“ng phÃ¡t hiá»‡n vÃ  pháº£n á»©ng sá»± cá»‘.

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ Má»™t Amazon VPC dÃ¹ng cho mÃ´i trÆ°á»ng CloudSOC Lab.
+ Má»™t Public Subnet Ä‘á»ƒ triá»ƒn khai EC2 workload.
+ Má»™t Internet Gateway Ä‘á»ƒ EC2 cÃ³ thá»ƒ truy cáº­p internet.
+ Má»™t Route Table cho Public Subnet.
+ Má»™t EC2 instance dÃ¹ng lÃ m workload má»¥c tiÃªu.
+ Má»™t security group bÃ¬nh thÆ°á»ng tÃªn `SG-Workload`.
+ Má»™t security group cÃ´ láº­p tÃªn `SG-Isolation`.
+ Má»™t IAM Role cho phÃ©p EC2 káº¿t ná»‘i vá»›i AWS Systems Manager.

---

#### Kiáº¿n trÃºc Network and EC2

SÆ¡ Ä‘á»“ sau minh há»a pháº§n Network and EC2 Workload trong há»‡ thá»‘ng AWS CloudSOC.

![Network and EC2 Workload](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/network-ec2-workload.png)

Luá»“ng triá»ƒn khai chÃ­nh:

```text
AWS Region
â†’ VPC
â†’ Public Subnet
â†’ Internet Gateway
â†’ Route Table
â†’ EC2 Workload
â†’ SG-Workload / SG-Isolation
```

Trong workshop nÃ y, EC2 Ä‘Æ°á»£c Ä‘áº·t trong Public Subnet Ä‘á»ƒ Ä‘Æ¡n giáº£n hÃ³a quÃ¡ trÃ¬nh mÃ´ phá»ng táº¥n cÃ´ng vÃ  kiá»ƒm thá»­ GuardDuty finding. ÄÃ¢y lÃ  thiáº¿t káº¿ dÃ nh cho mÃ´i trÆ°á»ng Lab / Proof of Concept, khÃ´ng pháº£i kiáº¿n trÃºc production hoÃ n chá»‰nh.

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

Báº¡n cÃ³ thá»ƒ sá»­ dá»¥ng cÃ¡c thÃ´ng tin cáº¥u hÃ¬nh sau cho workshop:

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
|---|---|
| Region | `ap-southeast-1` |
| VPC Name | `cloudsoc-vpc` |
| VPC CIDR | `10.0.0.0/16` |
| Public Subnet Name | `cloudsoc-public-subnet` |
| Public Subnet CIDR | `10.0.1.0/24` |
| Internet Gateway | `cloudsoc-igw` |
| Route Table | `cloudsoc-public-rtb` |
| EC2 Name | `cloudsoc-workload-ec2` |
| Security Group bÃ¬nh thÆ°á»ng | `SG-Workload` |
| Security Group cÃ´ láº­p | `SG-Isolation` |
| EC2 IAM Role | `CloudSOC-EC2-SSM-Role` |

---

#### BÆ°á»›c 1: Táº¡o VPC

Truy cáº­p AWS Management Console vÃ  má»Ÿ dá»‹ch vá»¥ **VPC**.

Chá»n:

```text
VPC â†’ Your VPCs â†’ Create VPC
```

Cáº¥u hÃ¬nh VPC nhÆ° sau:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Name tag | `cloudsoc-vpc` |
| IPv4 CIDR block | `10.0.0.0/16` |
| IPv6 CIDR block | No IPv6 CIDR block |
| Tenancy | Default |

Sau Ä‘Ã³ chá»n **Create VPC**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
VPC cloudsoc-vpc Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create VPC](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/create-vpc.png)

---

#### BÆ°á»›c 2: Táº¡o Public Subnet

Trong VPC Console, chá»n:

```text
Subnets â†’ Create subnet
```

Chá»n VPC vá»«a táº¡o:

```text
cloudsoc-vpc
```

Cáº¥u hÃ¬nh subnet:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Subnet name | `cloudsoc-public-subnet` |
| Availability Zone | Chá»n má»™t AZ trong `ap-southeast-1` |
| IPv4 subnet CIDR block | `10.0.1.0/24` |

Sau Ä‘Ã³ chá»n **Create subnet**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Public Subnet cloudsoc-public-subnet Ä‘Æ°á»£c táº¡o trong VPC cloudsoc-vpc.
```

![Create Public Subnet](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/create-public-subnet.png)

---

#### BÆ°á»›c 3: Báº­t Auto-assign Public IPv4

Äá»ƒ EC2 trong Public Subnet cÃ³ thá»ƒ nháº­n Public IPv4 khi khá»Ÿi táº¡o, cáº§n báº­t tÃ­nh nÄƒng Auto-assign public IPv4.

Chá»n subnet vá»«a táº¡o:

```text
cloudsoc-public-subnet
```

Sau Ä‘Ã³ chá»n:

```text
Actions â†’ Edit subnet settings
```

Báº­t tÃ¹y chá»n:

```text
Enable auto-assign public IPv4 address
```

Chá»n **Save**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Public Subnet Ä‘Ã£ Ä‘Æ°á»£c báº­t Auto-assign public IPv4.
```

---

#### BÆ°á»›c 4: Táº¡o Internet Gateway

Trong VPC Console, chá»n:

```text
Internet Gateways â†’ Create internet gateway
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Name tag | `cloudsoc-igw` |

Chá»n **Create internet gateway**.

Sau khi táº¡o xong, chá»n Internet Gateway vá»«a táº¡o vÃ  chá»n:

```text
Actions â†’ Attach to VPC
```

Chá»n VPC:

```text
cloudsoc-vpc
```

Sau Ä‘Ã³ chá»n **Attach internet gateway**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Internet Gateway cloudsoc-igw Ä‘Ã£ Ä‘Æ°á»£c gáº¯n vÃ o VPC cloudsoc-vpc.
```

![Create Internet Gateway](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/create-internet-gateway.png)

---

#### BÆ°á»›c 5: Táº¡o Route Table cho Public Subnet

Trong VPC Console, chá»n:

```text
Route Tables â†’ Create route table
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Name | `cloudsoc-public-rtb` |
| VPC | `cloudsoc-vpc` |

Sau Ä‘Ã³ chá»n **Create route table**.

Tiáº¿p theo, chá»n route table vá»«a táº¡o vÃ  vÃ o tab **Routes**.

Chá»n:

```text
Edit routes â†’ Add route
```

ThÃªm route:

| Destination | Target |
|---|---|
| `0.0.0.0/0` | `cloudsoc-igw` |

Chá»n **Save changes**.

Sau Ä‘Ã³ vÃ o tab **Subnet associations** vÃ  chá»n:

```text
Edit subnet associations
```

Chá»n subnet:

```text
cloudsoc-public-subnet
```

Chá»n **Save associations**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Public Subnet Ä‘Ã£ cÃ³ route 0.0.0.0/0 Ä‘i qua Internet Gateway.
```

![Public Route Table](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/public-route-table.png)

---

#### BÆ°á»›c 6: Táº¡o IAM Role cho EC2 Systems Manager

EC2 cáº§n IAM Role Ä‘á»ƒ cÃ³ thá»ƒ káº¿t ná»‘i vá»›i AWS Systems Manager. Äiá»u nÃ y giÃºp Systems Manager cÃ³ thá»ƒ cháº¡y command Ä‘á»ƒ thu tháº­p forensic evidence trong cÃ¡c pháº§n sau.

Má»Ÿ dá»‹ch vá»¥ **IAM**, chá»n:

```text
Roles â†’ Create role
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Trusted entity type | AWS service |
| Use case | EC2 |

á»ž pháº§n permissions, gáº¯n policy:

```text
AmazonSSMManagedInstanceCore
```

Äáº·t tÃªn role:

```text
CloudSOC-EC2-SSM-Role
```

Sau Ä‘Ã³ chá»n **Create role**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
IAM Role CloudSOC-EC2-SSM-Role Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![EC2 SSM Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/ec2-ssm-role.png)

---

#### BÆ°á»›c 7: Táº¡o Security Group SG-Workload

`SG-Workload` lÃ  security group ban Ä‘áº§u Ä‘Æ°á»£c gáº¯n cho EC2 instance. Security group nÃ y cho phÃ©p EC2 hoáº¡t Ä‘á»™ng trong tráº¡ng thÃ¡i bÃ¬nh thÆ°á»ng.

Trong EC2 Console, chá»n:

```text
Security Groups â†’ Create security group
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Security group name | `SG-Workload` |
| Description | `Security group for CloudSOC workload EC2` |
| VPC | `cloudsoc-vpc` |

Inbound rules Ä‘á» xuáº¥t cho mÃ´i trÆ°á»ng lab:

| Type | Protocol | Port | Source |
|---|---|---|---|
| SSH | TCP | 22 | My IP |

Outbound rules:

| Type | Protocol | Port | Destination |
|---|---|---|---|
| All traffic | All | All | `0.0.0.0/0` |

> **LÆ°u Ã½:** Chá»‰ nÃªn má»Ÿ SSH tá»« **My IP** Ä‘á»ƒ giáº£m rá»§i ro. KhÃ´ng nÃªn má»Ÿ SSH `0.0.0.0/0` náº¿u khÃ´ng cáº§n thiáº¿t.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Security Group SG-Workload Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![SG Workload](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/sg-workload.png)

---

#### BÆ°á»›c 8: Táº¡o Security Group SG-Isolation

`SG-Isolation` lÃ  security group dÃ¹ng Ä‘á»ƒ cÃ´ láº­p EC2 khi xáº£y ra sá»± cá»‘. Security group nÃ y Ä‘Æ°á»£c táº¡o sáºµn trong VPC vÃ  khÃ´ng cho phÃ©p inbound hoáº·c outbound traffic.

Trong EC2 Console, chá»n:

```text
Security Groups â†’ Create security group
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Security group name | `SG-Isolation` |
| Description | `Isolation security group for compromised EC2 instance` |
| VPC | `cloudsoc-vpc` |

Inbound rules:

```text
KhÃ´ng thÃªm inbound rule.
```

Outbound rules:

```text
XÃ³a default outbound rule 0.0.0.0/0.
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SG-Isolation khÃ´ng cÃ³ inbound rule vÃ  khÃ´ng cÃ³ outbound rule.
```

![SG Isolation](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/sg-isolation.png)

> **LÆ°u Ã½:** Khi táº¡o security group má»›i, AWS thÆ°á»ng tá»± táº¡o outbound rule cho phÃ©p táº¥t cáº£ traffic. Báº¡n cáº§n xÃ³a outbound rule nÃ y Ä‘á»ƒ `SG-Isolation` thá»±c sá»± cháº·n outbound traffic.

---

#### BÆ°á»›c 9: Khá»Ÿi táº¡o EC2 Workload

Má»Ÿ dá»‹ch vá»¥ **EC2**, chá»n:

```text
Instances â†’ Launch instances
```

Cáº¥u hÃ¬nh EC2:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Name | `cloudsoc-workload-ec2` |
| AMI | Amazon Linux 2023 |
| Instance type | `t2.micro` hoáº·c `t3.micro` |
| Key pair | Chá»n key pair cÃ³ sáºµn hoáº·c táº¡o má»›i |
| VPC | `cloudsoc-vpc` |
| Subnet | `cloudsoc-public-subnet` |
| Auto-assign public IP | Enable |
| Security Group | `SG-Workload` |
| IAM instance profile | `CloudSOC-EC2-SSM-Role` |

á»ž pháº§n **Advanced details**, gáº¯n IAM instance profile:

```text
CloudSOC-EC2-SSM-Role
```

Sau Ä‘Ã³ chá»n **Launch instance**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 instance cloudsoc-workload-ec2 Ä‘Æ°á»£c khá»Ÿi táº¡o thÃ nh cÃ´ng.
```

![Launch EC2](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/launch-ec2.png)

---

#### BÆ°á»›c 10: Gáº¯n tag AutoIsolate cho EC2

Tag `AutoIsolate=true` Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ xÃ¡c Ä‘á»‹nh EC2 instance nÃ o Ä‘Æ°á»£c phÃ©p tá»± Ä‘á»™ng cÃ´ láº­p khi cÃ³ finding nghiÃªm trá»ng.

Chá»n EC2 instance:

```text
cloudsoc-workload-ec2
```

VÃ o tab **Tags**, chá»n **Manage tags** vÃ  thÃªm tag:

| Key | Value |
|---|---|
| `AutoIsolate` | `true` |
| `Project` | `AWS-CloudSOC` |
| `Environment` | `Lab` |

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 instance Ä‘Ã£ cÃ³ tag AutoIsolate=true.
```

![EC2 Tags](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/ec2-tags.png)

---

#### BÆ°á»›c 11: Kiá»ƒm tra káº¿t ná»‘i Systems Manager

Sau khi EC2 cháº¡y, kiá»ƒm tra xem instance Ä‘Ã£ káº¿t ná»‘i Ä‘Æ°á»£c vá»›i AWS Systems Manager hay chÆ°a.

Má»Ÿ dá»‹ch vá»¥ **Systems Manager**, chá»n:

```text
Fleet Manager
```

Hoáº·c:

```text
Session Manager â†’ Start session
```

Kiá»ƒm tra xem EC2 instance `cloudsoc-workload-ec2` cÃ³ xuáº¥t hiá»‡n trong danh sÃ¡ch managed instances hay khÃ´ng.

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 instance xuáº¥t hiá»‡n trong Systems Manager Managed Nodes.
```

![SSM Managed Instance](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/ssm-managed-instance.png)

Náº¿u EC2 chÆ°a xuáº¥t hiá»‡n trong Systems Manager, hÃ£y kiá»ƒm tra:

+ EC2 Ä‘Ã£ gáº¯n IAM Role `CloudSOC-EC2-SSM-Role`.
+ EC2 cÃ³ outbound internet access.
+ Security group `SG-Workload` cho phÃ©p outbound traffic.
+ Public Subnet cÃ³ route `0.0.0.0/0` Ä‘áº¿n Internet Gateway.
+ EC2 Ä‘Ã£ Ä‘Æ°á»£c gÃ¡n Public IPv4.
+ SSM Agent Ä‘ang cháº¡y trÃªn instance.

---

#### BÆ°á»›c 12: Kiá»ƒm tra tráº¡ng thÃ¡i Security Group

Kiá»ƒm tra EC2 instance Ä‘ang sá»­ dá»¥ng security group ban Ä‘áº§u:

```text
cloudsoc-workload-ec2 â†’ Security â†’ Security groups
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 Ä‘ang Ä‘Æ°á»£c gáº¯n SG-Workload.
SG-Isolation Ä‘Ã£ Ä‘Æ°á»£c táº¡o sáºµn nhÆ°ng chÆ°a gáº¯n vÃ o EC2.
```

Trong cÃ¡c pháº§n sau, Lambda sáº½ thá»±c hiá»‡n hÃ nh Ä‘á»™ng cÃ´ láº­p báº±ng cÃ¡ch thay tháº¿ security group:

```text
SG-Workload â†’ SG-Isolation
```

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n Ä‘Ã£ triá»ƒn khai xong lá»›p Network and EC2 Workload cho há»‡ thá»‘ng AWS CloudSOC.

Káº¿t quáº£ cáº§n Ä‘áº¡t Ä‘Æ°á»£c:

- [ ] VPC `cloudsoc-vpc` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Public Subnet `cloudsoc-public-subnet` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Internet Gateway `cloudsoc-igw` Ä‘Ã£ Ä‘Æ°á»£c gáº¯n vÃ o VPC.
- [ ] Route Table `cloudsoc-public-rtb` cÃ³ route ra Internet Gateway.
- [ ] EC2 instance `cloudsoc-workload-ec2` Ä‘ang cháº¡y.
- [ ] EC2 Ä‘Æ°á»£c gáº¯n security group `SG-Workload`.
- [ ] Security group `SG-Isolation` Ä‘Ã£ Ä‘Æ°á»£c táº¡o vÃ  khÃ´ng cÃ³ inbound/outbound rule.
- [ ] EC2 cÃ³ IAM Role `CloudSOC-EC2-SSM-Role`.
- [ ] EC2 xuáº¥t hiá»‡n trong AWS Systems Manager.
- [ ] EC2 cÃ³ tag `AutoIsolate=true`.

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ táº¡o mÃ´i trÆ°á»ng máº¡ng cÆ¡ báº£n cho CloudSOC Lab, bao gá»“m VPC, Public Subnet, Internet Gateway, Route Table, EC2 instance vÃ  hai security group quan trá»ng.

`SG-Workload` Ä‘Æ°á»£c sá»­ dá»¥ng cho tráº¡ng thÃ¡i hoáº¡t Ä‘á»™ng bÃ¬nh thÆ°á»ng cá»§a EC2. `SG-Isolation` Ä‘Æ°á»£c chuáº©n bá»‹ Ä‘á»ƒ cÃ´ láº­p EC2 khi há»‡ thá»‘ng phÃ¡t hiá»‡n incident nghiÃªm trá»ng vÃ  Ä‘Æ°á»£c phÃ©p pháº£n á»©ng.

á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ cáº¥u hÃ¬nh **Logging and Evidence Storage** Ä‘á»ƒ thu tháº­p log, lÆ°u báº±ng chá»©ng vÃ  chuáº©n bá»‹ dá»¯ liá»‡u phá»¥c vá»¥ Ä‘iá»u tra sá»± cá»‘.