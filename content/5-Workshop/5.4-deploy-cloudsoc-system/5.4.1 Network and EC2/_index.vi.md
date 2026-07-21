---
title : "Network and EC2 Workload"
date : 2026-07-01
weight : 1
chapter : false
pre : " <b> 5.4.1. </b> "
---

#### Network and EC2 Workload

Trong phần này, chúng ta sẽ triển khai lớp **Network and EC2 Workload** cho hệ thống AWS CloudSOC. Đây là lớp nền tảng dùng để tạo môi trường mạng, triển khai EC2 instance mục tiêu và chuẩn bị security group phục vụ cho quá trình cô lập sự cố.

EC2 instance trong phần này sẽ đóng vai trò là workload thử nghiệm để mô phỏng các hành vi đáng ngờ như port scanning hoặc SSH brute-force. Sau đó, các dịch vụ như GuardDuty, EventBridge, Step Functions và Lambda sẽ sử dụng EC2 này để kiểm thử luồng phát hiện và phản ứng sự cố.

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ Một Amazon VPC dùng cho môi trường CloudSOC Lab.
+ Một Public Subnet để triển khai EC2 workload.
+ Một Internet Gateway để EC2 có thể truy cập internet.
+ Một Route Table cho Public Subnet.
+ Một EC2 instance dùng làm workload mục tiêu.
+ Một security group bình thường tên `SG-Workload`.
+ Một security group cô lập tên `SG-Isolation`.
+ Một IAM Role cho phép EC2 kết nối với AWS Systems Manager.

---

#### Kiến trúc Network and EC2

Sơ đồ sau minh họa phần Network and EC2 Workload trong hệ thống AWS CloudSOC.

![Network and EC2 Workload](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/network-ec2-workload.png)

Luồng triển khai chính:

```text
AWS Region
→ VPC
→ Public Subnet
→ Internet Gateway
→ Route Table
→ EC2 Workload
→ SG-Workload / SG-Isolation
```

Trong workshop này, EC2 được đặt trong Public Subnet để đơn giản hóa quá trình mô phỏng tấn công và kiểm thử GuardDuty finding. Đây là thiết kế dành cho môi trường Lab / Proof of Concept, không phải kiến trúc production hoàn chỉnh.

---

#### Thông tin cấu hình đề xuất

Bạn có thể sử dụng các thông tin cấu hình sau cho workshop:

| Thành phần | Giá trị đề xuất |
|---|---|
| Region | `ap-southeast-1` |
| VPC Name | `cloudsoc-vpc` |
| VPC CIDR | `10.0.0.0/16` |
| Public Subnet Name | `cloudsoc-public-subnet` |
| Public Subnet CIDR | `10.0.1.0/24` |
| Internet Gateway | `cloudsoc-igw` |
| Route Table | `cloudsoc-public-rtb` |
| EC2 Name | `cloudsoc-workload-ec2` |
| Security Group bình thường | `SG-Workload` |
| Security Group cô lập | `SG-Isolation` |
| EC2 IAM Role | `CloudSOC-EC2-SSM-Role` |

---

#### Bước 1: Tạo VPC

Truy cập AWS Management Console và mở dịch vụ **VPC**.

Chọn:

```text
VPC → Your VPCs → Create VPC
```

Cấu hình VPC như sau:

| Mục | Giá trị |
|---|---|
| Name tag | `cloudsoc-vpc` |
| IPv4 CIDR block | `10.0.0.0/16` |
| IPv6 CIDR block | No IPv6 CIDR block |
| Tenancy | Default |

Sau đó chọn **Create VPC**.

Kết quả mong đợi:

```text
VPC cloudsoc-vpc được tạo thành công.
```

![Create VPC](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/create-vpc.png)

---

#### Bước 2: Tạo Public Subnet

Trong VPC Console, chọn:

```text
Subnets → Create subnet
```

Chọn VPC vừa tạo:

```text
cloudsoc-vpc
```

Cấu hình subnet:

| Mục | Giá trị |
|---|---|
| Subnet name | `cloudsoc-public-subnet` |
| Availability Zone | Chọn một AZ trong `ap-southeast-1` |
| IPv4 subnet CIDR block | `10.0.1.0/24` |

Sau đó chọn **Create subnet**.

Kết quả mong đợi:

```text
Public Subnet cloudsoc-public-subnet được tạo trong VPC cloudsoc-vpc.
```

![Create Public Subnet](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/create-public-subnet.png)

---

#### Bước 3: Bật Auto-assign Public IPv4

Để EC2 trong Public Subnet có thể nhận Public IPv4 khi khởi tạo, cần bật tính năng Auto-assign public IPv4.

Chọn subnet vừa tạo:

```text
cloudsoc-public-subnet
```

Sau đó chọn:

```text
Actions → Edit subnet settings
```

Bật tùy chọn:

```text
Enable auto-assign public IPv4 address
```

Chọn **Save**.

Kết quả mong đợi:

```text
Public Subnet đã được bật Auto-assign public IPv4.
```

---

#### Bước 4: Tạo Internet Gateway

Trong VPC Console, chọn:

```text
Internet Gateways → Create internet gateway
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Name tag | `cloudsoc-igw` |

Chọn **Create internet gateway**.

Sau khi tạo xong, chọn Internet Gateway vừa tạo và chọn:

```text
Actions → Attach to VPC
```

Chọn VPC:

```text
cloudsoc-vpc
```

Sau đó chọn **Attach internet gateway**.

Kết quả mong đợi:

```text
Internet Gateway cloudsoc-igw đã được gắn vào VPC cloudsoc-vpc.
```

![Create Internet Gateway](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/create-internet-gateway.png)

---

#### Bước 5: Tạo Route Table cho Public Subnet

Trong VPC Console, chọn:

```text
Route Tables → Create route table
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Name | `cloudsoc-public-rtb` |
| VPC | `cloudsoc-vpc` |

Sau đó chọn **Create route table**.

Tiếp theo, chọn route table vừa tạo và vào tab **Routes**.

Chọn:

```text
Edit routes → Add route
```

Thêm route:

| Destination | Target |
|---|---|
| `0.0.0.0/0` | `cloudsoc-igw` |

Chọn **Save changes**.

Sau đó vào tab **Subnet associations** và chọn:

```text
Edit subnet associations
```

Chọn subnet:

```text
cloudsoc-public-subnet
```

Chọn **Save associations**.

Kết quả mong đợi:

```text
Public Subnet đã có route 0.0.0.0/0 đi qua Internet Gateway.
```

![Public Route Table](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/public-route-table.png)

---

#### Bước 6: Tạo IAM Role cho EC2 Systems Manager

EC2 cần IAM Role để có thể kết nối với AWS Systems Manager. Điều này giúp Systems Manager có thể chạy command để thu thập forensic evidence trong các phần sau.

Mở dịch vụ **IAM**, chọn:

```text
Roles → Create role
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Trusted entity type | AWS service |
| Use case | EC2 |

Ở phần permissions, gắn policy:

```text
AmazonSSMManagedInstanceCore
```

Đặt tên role:

```text
CloudSOC-EC2-SSM-Role
```

Sau đó chọn **Create role**.

Kết quả mong đợi:

```text
IAM Role CloudSOC-EC2-SSM-Role được tạo thành công.
```

![EC2 SSM Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/ec2-ssm-role.png)

---

#### Bước 7: Tạo Security Group SG-Workload

`SG-Workload` là security group ban đầu được gắn cho EC2 instance. Security group này cho phép EC2 hoạt động trong trạng thái bình thường.

Trong EC2 Console, chọn:

```text
Security Groups → Create security group
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Security group name | `SG-Workload` |
| Description | `Security group for CloudSOC workload EC2` |
| VPC | `cloudsoc-vpc` |

Inbound rules đề xuất cho môi trường lab:

| Type | Protocol | Port | Source |
|---|---|---|---|
| SSH | TCP | 22 | My IP |

Outbound rules:

| Type | Protocol | Port | Destination |
|---|---|---|---|
| All traffic | All | All | `0.0.0.0/0` |

> **Lưu ý:** Chỉ nên mở SSH từ **My IP** để giảm rủi ro. Không nên mở SSH `0.0.0.0/0` nếu không cần thiết.

Kết quả mong đợi:

```text
Security Group SG-Workload được tạo thành công.
```

![SG Workload](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/sg-workload.png)

---

#### Bước 8: Tạo Security Group SG-Isolation

`SG-Isolation` là security group dùng để cô lập EC2 khi xảy ra sự cố. Security group này được tạo sẵn trong VPC và không cho phép inbound hoặc outbound traffic.

Trong EC2 Console, chọn:

```text
Security Groups → Create security group
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Security group name | `SG-Isolation` |
| Description | `Isolation security group for compromised EC2 instance` |
| VPC | `cloudsoc-vpc` |

Inbound rules:

```text
Không thêm inbound rule.
```

Outbound rules:

```text
Xóa default outbound rule 0.0.0.0/0.
```

Kết quả mong đợi:

```text
SG-Isolation không có inbound rule và không có outbound rule.
```

![SG Isolation](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/sg-isolation.png)

> **Lưu ý:** Khi tạo security group mới, AWS thường tự tạo outbound rule cho phép tất cả traffic. Bạn cần xóa outbound rule này để `SG-Isolation` thực sự chặn outbound traffic.

---

#### Bước 9: Khởi tạo EC2 Workload

Mở dịch vụ **EC2**, chọn:

```text
Instances → Launch instances
```

Cấu hình EC2:

| Mục | Giá trị |
|---|---|
| Name | `cloudsoc-workload-ec2` |
| AMI | Amazon Linux 2023 |
| Instance type | `t2.micro` hoặc `t3.micro` |
| Key pair | Chọn key pair có sẵn hoặc tạo mới |
| VPC | `cloudsoc-vpc` |
| Subnet | `cloudsoc-public-subnet` |
| Auto-assign public IP | Enable |
| Security Group | `SG-Workload` |
| IAM instance profile | `CloudSOC-EC2-SSM-Role` |

Ở phần **Advanced details**, gắn IAM instance profile:

```text
CloudSOC-EC2-SSM-Role
```

Sau đó chọn **Launch instance**.

Kết quả mong đợi:

```text
EC2 instance cloudsoc-workload-ec2 được khởi tạo thành công.
```

![Launch EC2](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/launch-ec2.png)

---

#### Bước 10: Gắn tag AutoIsolate cho EC2

Tag `AutoIsolate=true` được sử dụng để xác định EC2 instance nào được phép tự động cô lập khi có finding nghiêm trọng.

Chọn EC2 instance:

```text
cloudsoc-workload-ec2
```

Vào tab **Tags**, chọn **Manage tags** và thêm tag:

| Key | Value |
|---|---|
| `AutoIsolate` | `true` |
| `Project` | `AWS-CloudSOC` |
| `Environment` | `Lab` |

Kết quả mong đợi:

```text
EC2 instance đã có tag AutoIsolate=true.
```

![EC2 Tags](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/ec2-tags.png)

---

#### Bước 11: Kiểm tra kết nối Systems Manager

Sau khi EC2 chạy, kiểm tra xem instance đã kết nối được với AWS Systems Manager hay chưa.

Mở dịch vụ **Systems Manager**, chọn:

```text
Fleet Manager
```

Hoặc:

```text
Session Manager → Start session
```

Kiểm tra xem EC2 instance `cloudsoc-workload-ec2` có xuất hiện trong danh sách managed instances hay không.

Kết quả mong đợi:

```text
EC2 instance xuất hiện trong Systems Manager Managed Nodes.
```

![SSM Managed Instance](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.1-Network-and-EC2/ssm-managed-instance.png)

Nếu EC2 chưa xuất hiện trong Systems Manager, hãy kiểm tra:

+ EC2 đã gắn IAM Role `CloudSOC-EC2-SSM-Role`.
+ EC2 có outbound internet access.
+ Security group `SG-Workload` cho phép outbound traffic.
+ Public Subnet có route `0.0.0.0/0` đến Internet Gateway.
+ EC2 đã được gán Public IPv4.
+ SSM Agent đang chạy trên instance.

---

#### Bước 12: Kiểm tra trạng thái Security Group

Kiểm tra EC2 instance đang sử dụng security group ban đầu:

```text
cloudsoc-workload-ec2 → Security → Security groups
```

Kết quả mong đợi:

```text
EC2 đang được gắn SG-Workload.
SG-Isolation đã được tạo sẵn nhưng chưa gắn vào EC2.
```

Trong các phần sau, Lambda sẽ thực hiện hành động cô lập bằng cách thay thế security group:

```text
SG-Workload → SG-Isolation
```

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, bạn đã triển khai xong lớp Network and EC2 Workload cho hệ thống AWS CloudSOC.

Kết quả cần đạt được:

- [ ] VPC `cloudsoc-vpc` đã được tạo.
- [ ] Public Subnet `cloudsoc-public-subnet` đã được tạo.
- [ ] Internet Gateway `cloudsoc-igw` đã được gắn vào VPC.
- [ ] Route Table `cloudsoc-public-rtb` có route ra Internet Gateway.
- [ ] EC2 instance `cloudsoc-workload-ec2` đang chạy.
- [ ] EC2 được gắn security group `SG-Workload`.
- [ ] Security group `SG-Isolation` đã được tạo và không có inbound/outbound rule.
- [ ] EC2 có IAM Role `CloudSOC-EC2-SSM-Role`.
- [ ] EC2 xuất hiện trong AWS Systems Manager.
- [ ] EC2 có tag `AutoIsolate=true`.

---

#### Tóm tắt

Trong phần này, chúng ta đã tạo môi trường mạng cơ bản cho CloudSOC Lab, bao gồm VPC, Public Subnet, Internet Gateway, Route Table, EC2 instance và hai security group quan trọng.

`SG-Workload` được sử dụng cho trạng thái hoạt động bình thường của EC2. `SG-Isolation` được chuẩn bị để cô lập EC2 khi hệ thống phát hiện incident nghiêm trọng và được phép phản ứng.

Ở phần tiếp theo, chúng ta sẽ cấu hình **Logging and Evidence Storage** để thu thập log, lưu bằng chứng và chuẩn bị dữ liệu phục vụ điều tra sự cố.