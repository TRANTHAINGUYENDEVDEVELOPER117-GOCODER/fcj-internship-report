---
title : "Threat Detection Services"
date : 2026-07-01
weight : 3
chapter : false
pre : " <b> 5.4.3. </b> "
---

#### Threat Detection Services

Trong phần này, chúng ta sẽ bật và cấu hình các dịch vụ phát hiện mối đe dọa cho hệ thống **AWS CloudSOC**. Đây là lớp chịu trách nhiệm phát hiện hành vi đáng ngờ, tập trung security findings và hỗ trợ SOC Analyst trong quá trình điều tra sự cố.

Các dịch vụ chính được sử dụng trong phần này gồm:

+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ AWS Config

Trong kiến trúc CloudSOC, Amazon GuardDuty đóng vai trò là dịch vụ phát hiện mối đe dọa chính. Khi GuardDuty phát hiện hành vi bất thường, finding sẽ được gửi đến Security Hub, Detective và EventBridge để phục vụ phân tích và kích hoạt workflow phản ứng sự cố.

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ Amazon GuardDuty được bật trong Region `ap-southeast-1`.
+ AWS Security Hub được bật để tập trung security findings.
+ Amazon Detective được bật để hỗ trợ điều tra finding.
+ AWS Config được bật để theo dõi thay đổi cấu hình tài nguyên.
+ GuardDuty findings sẵn sàng để gửi sang EventBridge trong phần tiếp theo.
+ SOC Analyst có thể xem finding trong GuardDuty, Security Hub và Detective.

---

#### Kiến trúc Threat Detection Services

Sơ đồ sau minh họa lớp Threat Detection Services trong hệ thống AWS CloudSOC.

![Threat Detection Services Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/threat-detection-architecture.png)

Luồng phát hiện mối đe dọa chính:

```text
AWS Telemetry
→ Amazon GuardDuty
→ AWS Security Hub
→ Amazon Detective
→ Amazon EventBridge
→ Step Functions Response Workflow
```

Amazon GuardDuty phân tích các nguồn telemetry do AWS quản lý như CloudTrail management events, VPC Flow Logs và DNS logs. Khi phát hiện hoạt động đáng ngờ, GuardDuty tạo ra security finding. Finding này sẽ được sử dụng ở các phần sau để kích hoạt EventBridge và Step Functions.

---

#### Thông tin cấu hình đề xuất

Bạn có thể sử dụng các thông tin cấu hình sau cho workshop:

| Thành phần | Giá trị đề xuất |
|---|---|
| Region | `ap-southeast-1` |
| GuardDuty | Enabled |
| Security Hub | Enabled |
| Detective | Enabled |
| AWS Config | Enabled |
| Config Recorder | Record all supported resources |
| Config Delivery Channel | S3 bucket hoặc bucket mặc định |
| Main Finding Source | Amazon GuardDuty |
| Finding Target | EventBridge Rule |

---

#### Bước 1: Bật Amazon GuardDuty

Mở dịch vụ **Amazon GuardDuty** trong AWS Management Console.

Chọn:

```text
GuardDuty → Get started
```

Sau đó chọn:

```text
Enable GuardDuty
```

GuardDuty sẽ bắt đầu phân tích các nguồn dữ liệu bảo mật trong AWS account để phát hiện hành vi đáng ngờ.

Kết quả mong đợi:

```text
Amazon GuardDuty được bật thành công trong Region ap-southeast-1.
```

![Enable GuardDuty](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-guardduty.png)

---

#### Bước 2: Kiểm tra trạng thái GuardDuty

Sau khi bật GuardDuty, kiểm tra dashboard của GuardDuty.

Vào:

```text
GuardDuty → Summary
```

Hoặc:

```text
GuardDuty → Findings
```

Ở thời điểm mới bật, có thể chưa có finding thật. Điều này là bình thường vì GuardDuty cần có dữ liệu hoạt động để phân tích.

Kết quả mong đợi:

```text
GuardDuty status đang hoạt động.
GuardDuty Findings page có thể truy cập được.
```

![GuardDuty Dashboard](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/guardduty-dashboard.png)

---

#### Bước 3: Tạo GuardDuty Sample Findings

Để kiểm tra giao diện và chuẩn bị dữ liệu cho phần EventBridge, bạn có thể tạo sample findings trong GuardDuty.

Vào:

```text
GuardDuty → Settings
```

Tìm phần:

```text
Sample findings
```

Chọn:

```text
Generate sample findings
```

Sau khi tạo sample findings, quay lại:

```text
GuardDuty → Findings
```

Kết quả mong đợi:

```text
Các sample findings xuất hiện trong GuardDuty Findings.
```

![GuardDuty Sample Findings](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/guardduty-sample-findings.png)

> **Lưu ý:** Sample findings chỉ dùng để kiểm tra giao diện và luồng xử lý. Trong phần Testing and Validation, chúng ta sẽ kiểm thử workflow với finding phù hợp hơn.

---

#### Bước 4: Bật AWS Security Hub

AWS Security Hub được sử dụng để tập trung security findings từ nhiều dịch vụ AWS. Trong workshop này, Security Hub nhận findings từ GuardDuty và hiển thị chúng ở một nơi tập trung.

Mở dịch vụ **AWS Security Hub**.

Chọn:

```text
Security Hub → Go to Security Hub
```

Nếu lần đầu sử dụng, chọn:

```text
Enable Security Hub
```

Trong quá trình bật Security Hub, bạn có thể giữ cấu hình mặc định cho môi trường lab.

Kết quả mong đợi:

```text
AWS Security Hub được bật thành công.
```

![Enable Security Hub](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-security-hub.png)

---

#### Bước 5: Kiểm tra Findings trong Security Hub

Sau khi bật Security Hub, vào:

```text
Security Hub → Findings
```

Nếu GuardDuty đã tạo sample findings hoặc có finding thật, các finding này có thể xuất hiện trong Security Hub sau một khoảng thời gian ngắn.

Kết quả mong đợi:

```text
Security Hub có thể hiển thị findings từ GuardDuty.
```

![Security Hub Findings](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/security-hub-findings.png)

Security Hub giúp SOC Analyst:

+ Xem security findings tập trung.
+ Lọc findings theo severity.
+ Kiểm tra trạng thái finding.
+ Theo dõi compliance và security posture.
+ Kết hợp findings từ nhiều dịch vụ bảo mật AWS.

---

#### Bước 6: Bật Amazon Detective

Amazon Detective hỗ trợ SOC Analyst điều tra sâu hơn các hoạt động đáng ngờ. Detective giúp phân tích mối quan hệ giữa tài nguyên, API calls, network activity và findings.

Mở dịch vụ **Amazon Detective**.

Chọn:

```text
Detective → Get started
```

Sau đó chọn:

```text
Enable Detective
```

Kết quả mong đợi:

```text
Amazon Detective được bật thành công.
```

![Enable Detective](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-detective.png)

---

#### Bước 7: Kiểm tra Detective Investigation

Sau khi bật Detective, dữ liệu có thể cần một khoảng thời gian để được thu thập và hiển thị.

Vào:

```text
Detective → Search
```

Hoặc:

```text
Detective → Investigations
```

SOC Analyst có thể sử dụng Detective để điều tra các đối tượng như:

+ AWS Account
+ IAM Role
+ EC2 Instance
+ IP address
+ GuardDuty finding

Kết quả mong đợi:

```text
Detective đã sẵn sàng để hỗ trợ điều tra security findings.
```

![Detective Investigation](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/detective-investigation.png)

---

#### Bước 8: Bật AWS Config

AWS Config được sử dụng để theo dõi thay đổi cấu hình của tài nguyên AWS. Trong CloudSOC, AWS Config giúp ghi nhận sự thay đổi của EC2, Security Group và các tài nguyên liên quan.

Mở dịch vụ **AWS Config**.

Chọn:

```text
AWS Config → Get started
```

Cấu hình cơ bản:

| Mục | Giá trị |
|---|---|
| Resource types to record | Record all supported resources |
| AWS Config role | Create AWS Config service-linked role |
| Delivery method | Amazon S3 bucket |
| S3 bucket | Tạo mới hoặc chọn bucket có sẵn |
| Frequency | Continuous recording |

Sau đó chọn:

```text
Confirm
```

Kết quả mong đợi:

```text
AWS Config được bật và bắt đầu ghi nhận thay đổi cấu hình tài nguyên.
```

![Enable AWS Config](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-aws-config.png)

---

#### Bước 9: Kiểm tra Resource Inventory trong AWS Config

Sau khi bật AWS Config, vào:

```text
AWS Config → Resources
```

Tìm các tài nguyên liên quan đến CloudSOC, ví dụ:

+ EC2 instance `cloudsoc-workload-ec2`
+ Security Group `SG-Workload`
+ Security Group `SG-Isolation`
+ VPC `cloudsoc-vpc`

Kết quả mong đợi:

```text
AWS Config ghi nhận các tài nguyên chính của CloudSOC Lab.
```

![AWS Config Resources](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/aws-config-resources.png)

AWS Config sẽ hữu ích trong các phần sau khi Lambda thay đổi security group của EC2 từ:

```text
SG-Workload → SG-Isolation
```

Thay đổi này có thể được ghi nhận như một configuration change.

---

#### Bước 10: Kiểm tra liên kết GuardDuty với EventBridge

GuardDuty findings có thể được gửi đến Amazon EventBridge dưới dạng events. Trong phần tiếp theo, chúng ta sẽ tạo EventBridge rule để bắt GuardDuty finding và kích hoạt Step Functions workflow.

Ở phần này, bạn chỉ cần đảm bảo GuardDuty đã được bật và có thể tạo finding.

Luồng chuẩn bị cho phần sau:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions
→ Incident Response Workflow
```

Kết quả mong đợi:

```text
GuardDuty đã sẵn sàng làm nguồn sự kiện cho EventBridge.
```

---

#### Kiểm tra sau khi hoàn thành

Sau khi hoàn thành phần này, kiểm tra lại các mục sau:

- [ ] Amazon GuardDuty đã được bật.
- [ ] GuardDuty Findings page có thể truy cập được.
- [ ] GuardDuty sample findings đã được tạo nếu cần.
- [ ] AWS Security Hub đã được bật.
- [ ] Security Hub có thể nhận findings từ GuardDuty.
- [ ] Amazon Detective đã được bật.
- [ ] Detective sẵn sàng hỗ trợ điều tra finding.
- [ ] AWS Config đã được bật.
- [ ] AWS Config có thể ghi nhận tài nguyên EC2 và Security Group.
- [ ] GuardDuty findings sẵn sàng để sử dụng với EventBridge.

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, hệ thống AWS CloudSOC đã có lớp phát hiện mối đe dọa và hỗ trợ điều tra sự cố.

Các thành phần đã sẵn sàng gồm:

```text
Amazon GuardDuty
AWS Security Hub
Amazon Detective
AWS Config
```

Khi một hoạt động đáng ngờ xảy ra, GuardDuty sẽ tạo security finding. Finding này có thể được Security Hub tập trung, Detective hỗ trợ điều tra và EventBridge sử dụng để kích hoạt workflow phản ứng sự cố.

---

#### Tóm tắt

Trong phần này, chúng ta đã bật các dịch vụ phát hiện và điều tra mối đe dọa cho AWS CloudSOC. GuardDuty đóng vai trò phát hiện chính, Security Hub tập trung findings, Detective hỗ trợ điều tra chuyên sâu, còn AWS Config theo dõi thay đổi cấu hình tài nguyên.

Ở phần tiếp theo, chúng ta sẽ cấu hình **EventBridge and Step Functions Workflow** để tự động xử lý GuardDuty findings và bắt đầu quy trình phản ứng sự cố.