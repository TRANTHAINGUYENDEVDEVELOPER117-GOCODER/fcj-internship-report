---
title: "Bản đề xuất"
date: 2026-06-30
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# AWS CloudSOC  
## Hệ thống phát hiện mối đe dọa, điều tra và phản ứng sự cố tự động trên AWS

### 1. Tóm tắt điều hành

**AWS CloudSOC** là một mô hình Security Operations Center được triển khai trên Amazon Web Services nhằm hỗ trợ phát hiện mối đe dọa, điều tra sự cố, phản ứng tự động và gửi cảnh báo đến người vận hành bảo mật.

Mục tiêu của dự án là xây dựng một hệ thống có khả năng phát hiện các hành vi đáng ngờ trên môi trường AWS, chẳng hạn như truy cập bất thường, SSH brute force, port scan hoặc dấu hiệu EC2 bị xâm nhập. Khi có security finding được tạo ra, hệ thống sẽ tự động tiếp nhận sự kiện, phân loại mức độ nghiêm trọng, ghi nhận incident, thu thập bằng chứng, cô lập tài nguyên bị nghi ngờ và gửi cảnh báo cho SOC Analyst.

Dự án sử dụng các dịch vụ AWS như **Amazon GuardDuty**, **AWS Security Hub**, **Amazon EventBridge**, **AWS Step Functions**, **AWS Lambda**, **AWS Systems Manager**, **Amazon EC2**, **Amazon S3**, **Amazon DynamoDB**, **Amazon SNS**, **Amazon CloudWatch**, **AWS CloudTrail**, **AWS Config** và **Amazon Detective**.

Hệ thống được thiết kế theo hướng **event-driven** và **serverless-oriented**, giúp giảm bớt thao tác thủ công, tăng khả năng tự động hóa trong quy trình phản ứng sự cố và phù hợp với môi trường lab có chi phí thấp.

---

### 2. Tuyên bố vấn đề

#### Vấn đề hiện tại

Trong môi trường cloud, các tài nguyên như EC2, VPC, IAM, Security Group và storage có thể bị tấn công hoặc cấu hình sai nếu không được giám sát liên tục. Một số vấn đề thường gặp bao gồm:

- Khó phát hiện sớm hành vi bất thường trên EC2.
- Thiếu hệ thống tập trung để theo dõi security findings.
- Quy trình phản ứng sự cố còn phụ thuộc nhiều vào thao tác thủ công.
- SOC Analyst mất thời gian kiểm tra log, xác định tài nguyên bị ảnh hưởng và thực hiện cô lập.
- Bằng chứng sự cố có thể bị thiếu hoặc không được lưu trữ đúng cách.
- Cảnh báo bảo mật có thể bị chậm nếu không có hệ thống notification tự động.

Trong thực tế, nếu một EC2 bị nghi ngờ xâm nhập mà không được cô lập kịp thời, attacker có thể tiếp tục dò quét, di chuyển ngang trong hệ thống hoặc truy cập dữ liệu nhạy cảm.

#### Giải pháp đề xuất

Giải pháp được đề xuất là xây dựng một hệ thống **AWS CloudSOC** có khả năng tự động hóa quy trình phát hiện và phản ứng sự cố.

Luồng xử lý chính của hệ thống:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions Workflow
→ Incident Response Lambda
→ Systems Manager Evidence Collection
→ EBS Forensic Snapshot
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS Notification
→ Email / Slack Alert
```

Trong hệ thống này:

- **Amazon GuardDuty** phát hiện hành vi đáng ngờ.
- **AWS Security Hub** tổng hợp và chuẩn hóa security findings.
- **Amazon EventBridge** nhận GuardDuty finding và kích hoạt workflow.
- **AWS Step Functions** điều phối luồng phản ứng sự cố.
- **AWS Lambda** xử lý logic response và cập nhật incident.
- **AWS Systems Manager** thu thập forensic evidence từ EC2.
- **Amazon S3** lưu raw event và response summary.
- **Amazon DynamoDB** lưu trạng thái incident.
- **Amazon SNS** gửi cảnh báo qua Email hoặc Slack.
- **Amazon CloudWatch** giám sát log, metric và alarm.
- **Amazon Detective** hỗ trợ điều tra mối quan hệ giữa các finding.

Ngoài ra, dự án có một **SOC Dashboard** đơn giản được triển khai bằng **AWS Amplify**, giúp SOC Analyst theo dõi incident, kiểm tra trạng thái xử lý và xác thực workflow.

#### Lợi ích và giá trị mang lại

Dự án mang lại các lợi ích chính:

- Tự động phát hiện và phản ứng với security finding.
- Giảm thời gian phản hồi khi có sự cố bảo mật.
- Cô lập EC2 nghi ngờ bằng Security Group riêng.
- Lưu trữ bằng chứng sự cố vào S3 để phục vụ điều tra.
- Theo dõi trạng thái incident trong DynamoDB.
- Gửi cảnh báo đến SOC Analyst qua Email hoặc Slack.
- Cung cấp dashboard để giám sát incident.
- Giúp sinh viên hiểu rõ quy trình vận hành SOC trên môi trường AWS.

Dự án phù hợp với mục tiêu học tập về **Cloud Security**, **Incident Response**, **AWS Security Services** và **AWS Solution Architecture**.

---

### 3. Kiến trúc giải pháp

Hệ thống AWS CloudSOC được thiết kế theo kiến trúc event-driven, trong đó các security findings được tự động chuyển qua nhiều lớp xử lý khác nhau.

Kiến trúc tổng thể gồm các lớp chính:

```text
Detection Layer
→ Event Routing Layer
→ Workflow Orchestration Layer
→ Response Automation Layer
→ Evidence Storage Layer
→ Monitoring and Alerting Layer
→ SOC Dashboard Layer
```

![AWS CloudSOC Architecture](/images/2-Proposal/cloudsoc-architecture.png)


#### Dịch vụ AWS sử dụng

- **Amazon GuardDuty**: Phát hiện hành vi đáng ngờ và tạo security findings.
- **AWS Security Hub**: Tổng hợp findings và hỗ trợ quản lý tình trạng bảo mật.
- **Amazon EventBridge**: Định tuyến GuardDuty findings đến Step Functions.
- **AWS Step Functions**: Điều phối workflow phản ứng sự cố.
- **AWS Lambda**: Xử lý logic incident response.
- **AWS Systems Manager**: Chạy lệnh forensic collection trên EC2.
- **Amazon EC2**: Workload giả lập mục tiêu cần bảo vệ.
- **Amazon VPC**: Mạng lab chứa EC2 workload.
- **Amazon S3**: Lưu trữ evidence, raw event và response summary.
- **Amazon DynamoDB**: Lưu metadata và trạng thái incident.
- **Amazon SNS**: Gửi cảnh báo đến Email hoặc Slack.
- **Amazon CloudWatch**: Lưu log, metric và tạo alarm.
- **AWS CloudTrail**: Ghi nhận hoạt động API trong tài khoản AWS.
- **AWS Config**: Theo dõi thay đổi cấu hình tài nguyên.
- **Amazon Detective**: Hỗ trợ điều tra và phân tích mối quan hệ giữa các finding.
- **AWS IAM**: Quản lý quyền truy cập cho các dịch vụ.
- **AWS KMS**: Hỗ trợ mã hóa dữ liệu nếu được cấu hình.
- **AWS Amplify**: Triển khai SOC Dashboard.
- **Amazon API Gateway**: Cung cấp API cho dashboard.
- **Amazon Cognito**: Quản lý xác thực người dùng dashboard.

#### Thiết kế thành phần

##### Detection Layer

Lớp phát hiện sử dụng GuardDuty, CloudTrail, VPC Flow Logs và Security Hub để giám sát các hành vi bất thường trong tài khoản AWS.

GuardDuty có vai trò chính trong việc phát hiện các dấu hiệu như:

```text
UnauthorizedAccess:EC2/SSHBruteForce
Recon:EC2/Portscan
CryptoCurrency:EC2/BitcoinTool.B
Trojan:EC2/BlackholeTraffic
```

##### Event Routing Layer

EventBridge rule được cấu hình để nhận GuardDuty findings và chuyển sự kiện đến Step Functions workflow.

Rule này giúp hệ thống hoạt động theo mô hình event-driven, nghĩa là workflow chỉ được kích hoạt khi có security event phù hợp.

##### Workflow Orchestration Layer

Step Functions chịu trách nhiệm điều phối luồng xử lý incident.

Workflow có thể chia thành các nhánh:

```text
Alert Only
Approval Required
Auto Response
```

- Finding mức thấp hoặc không đủ điều kiện sẽ chỉ gửi cảnh báo.
- Finding mức cao có thể yêu cầu SOC Analyst phê duyệt.
- Finding nghiêm trọng liên quan đến EC2 có thể kích hoạt auto isolation.

##### Response Automation Layer

Lambda xử lý logic phản ứng sự cố, bao gồm:

- Đọc thông tin finding.
- Xác định EC2 instance bị ảnh hưởng.
- Kiểm tra tag `AutoIsolate=true`.
- Ghi incident vào DynamoDB.
- Gọi Systems Manager để thu thập evidence.
- Tạo EBS Snapshot.
- Thay Security Group của EC2 sang `SG-Isolation`.
- Gửi notification qua SNS.

##### Evidence Storage Layer

S3 được dùng để lưu trữ bằng chứng sự cố, bao gồm:

```text
raw-event.json
response-summary.json
SSM command output
forensic evidence
```

DynamoDB lưu trạng thái xử lý incident, ví dụ:

```text
incidentId
findingId
findingType
severity
resourceId
responseMode
approvalStatus
incidentStatus
evidencePath
snapshotIds
notificationMessageId
```

##### Monitoring and Alerting Layer

CloudWatch được dùng để theo dõi log và lỗi của Lambda, Step Functions và các thành phần liên quan.

SNS được dùng để gửi cảnh báo đến:

```text
Email
Slack Channel
SOC Analyst
```

##### SOC Dashboard Layer

SOC Dashboard được triển khai bằng Amplify. Dashboard giúp hiển thị:

- Tổng số incident.
- Incident đang chờ phê duyệt.
- Finding nghiêm trọng.
- Trạng thái xử lý incident.
- Kết quả auto isolation.
- Trạng thái notification.

---

### 4. Triển khai kỹ thuật

#### Các giai đoạn triển khai

Dự án được triển khai theo các giai đoạn sau:

##### Giai đoạn 1: Nghiên cứu và thiết kế kiến trúc

Trong giai đoạn này, tiến hành nghiên cứu các dịch vụ AWS Security và thiết kế kiến trúc CloudSOC.

Các nội dung chính:

- Tìm hiểu GuardDuty, Security Hub, EventBridge và Step Functions.
- Tìm hiểu Lambda, Systems Manager và DynamoDB.
- Tìm hiểu mô hình incident response trên cloud.
- Thiết kế kiến trúc tổng thể theo chuẩn AWS.
- Xác định luồng detection, investigation, response và notification.

##### Giai đoạn 2: Chuẩn bị môi trường AWS

Giai đoạn này tập trung tạo môi trường lab:

- Tạo VPC.
- Tạo public subnet.
- Tạo route table.
- Tạo Internet Gateway.
- Tạo EC2 workload.
- Tạo Security Group cho workload.
- Tạo Security Group cô lập `SG-Isolation`.
- Gắn IAM Role cho EC2 để sử dụng Systems Manager.

##### Giai đoạn 3: Triển khai logging và security services

Bật và cấu hình các dịch vụ giám sát:

- CloudTrail.
- VPC Flow Logs.
- GuardDuty.
- Security Hub.
- AWS Config.
- Amazon Detective.
- CloudWatch Logs.

Mục tiêu là đảm bảo hệ thống có đủ nguồn dữ liệu để phát hiện và điều tra sự cố.

##### Giai đoạn 4: Xây dựng workflow phản ứng sự cố

Cấu hình các thành phần tự động hóa:

- EventBridge rule nhận GuardDuty findings.
- Step Functions workflow điều phối response.
- Lambda function xử lý incident.
- Systems Manager Run Command thu thập evidence.
- S3 bucket lưu evidence.
- DynamoDB table lưu incident status.
- SNS topic gửi notification.

##### Giai đoạn 5: Xây dựng dashboard và alert

Triển khai SOC Dashboard:

- Amplify Hosting cho giao diện dashboard.
- API Gateway làm endpoint cho dashboard.
- Lambda API xử lý request.
- Cognito hỗ trợ xác thực người dùng nếu cần.
- Dashboard hiển thị trạng thái incident và approval workflow.

##### Giai đoạn 6: Kiểm thử và xác thực

Thực hiện kiểm thử toàn bộ hệ thống:

- Tạo GuardDuty sample findings.
- Kiểm tra EventBridge rule.
- Kiểm tra Step Functions execution.
- Kiểm tra Approval Workflow.
- Kiểm tra Auto Isolation.
- Kiểm tra DynamoDB record.
- Kiểm tra S3 evidence.
- Kiểm tra EBS Snapshot.
- Kiểm tra Email và Slack alert.
- Kiểm tra CloudWatch Alarm.

##### Giai đoạn 7: Dọn dẹp tài nguyên

Sau khi hoàn thành workshop, xóa các tài nguyên không còn sử dụng để tránh phát sinh chi phí.

---

#### Yêu cầu kỹ thuật

Để triển khai dự án, cần chuẩn bị:

- Tài khoản AWS có quyền tạo các dịch vụ cần thiết.
- Kiến thức cơ bản về AWS Console.
- Kiến thức cơ bản về VPC, EC2, IAM và Security Group.
- Kiến thức cơ bản về Cloud Security và Incident Response.
- Trình duyệt web để truy cập AWS Console.
- Email để nhận SNS notification.
- Slack workspace nếu muốn kiểm thử cảnh báo qua Slack.

---

### 5. Lộ trình và mốc triển khai

Dự án được thực hiện trong thời gian thực tập, chia thành các mốc chính:

#### Tuần 1–2: Nghiên cứu và lập kế hoạch

- Tìm hiểu các dịch vụ AWS Security.
- Phân tích yêu cầu đề tài.
- Xây dựng phạm vi dự án.
- Thiết kế kiến trúc ban đầu.

#### Tuần 3–4: Thiết kế kiến trúc và chuẩn bị lab

- Hoàn thiện sơ đồ AWS CloudSOC.
- Tạo VPC, subnet, route table và Internet Gateway.
- Tạo EC2 workload.
- Cấu hình IAM Role và Security Group.

#### Tuần 5–6: Triển khai detection và logging

- Bật CloudTrail.
- Cấu hình VPC Flow Logs.
- Bật GuardDuty.
- Bật Security Hub.
- Cấu hình AWS Config và Detective.

#### Tuần 7–8: Triển khai workflow tự động

- Tạo EventBridge rule.
- Tạo Step Functions workflow.
- Viết Lambda Incident Response.
- Tạo S3 Evidence Bucket.
- Tạo DynamoDB Incident Table.

#### Tuần 9–10: Triển khai dashboard và cảnh báo

- Tạo SOC Dashboard.
- Triển khai bằng Amplify.
- Cấu hình API Gateway và Lambda API.
- Cấu hình SNS Email.
- Cấu hình Slack alert nếu cần.

#### Tuần 11: Kiểm thử hệ thống

- Kiểm thử GuardDuty sample findings.
- Kiểm thử approval workflow.
- Kiểm thử auto isolation.
- Kiểm thử evidence storage.
- Kiểm thử dashboard và alert.

#### Tuần 12: Hoàn thiện báo cáo và cleanup

- Hoàn thiện workshop.
- Chụp ảnh kết quả.
- Viết báo cáo.
- Dọn dẹp tài nguyên AWS.

---

### 6. Ước tính ngân sách

Dự án được thiết kế theo hướng lab, ưu tiên sử dụng tài nguyên nhỏ và thời gian chạy ngắn để tối ưu chi phí.

Các tài nguyên có thể phát sinh chi phí gồm:

| Nhóm dịch vụ | Dịch vụ | Ghi chú chi phí |
|---|---|---|
| Compute | EC2, Lambda | EC2 phát sinh theo thời gian chạy, Lambda tính theo request và thời gian thực thi |
| Storage | S3, EBS Snapshot, DynamoDB | Phát sinh theo dung lượng lưu trữ |
| Security | GuardDuty, Security Hub, Detective, Config | Có thể phát sinh theo lượng log/finding/resource được phân tích |
| Monitoring | CloudWatch Logs, CloudWatch Alarm | Phát sinh theo log lưu trữ và metric/alarm |
| Workflow | Step Functions, EventBridge | Phát sinh theo số lần execution/event |
| Notification | SNS | Phát sinh theo số lượng notification |
| Dashboard | Amplify, API Gateway, Cognito | Phát sinh theo hosting, request và người dùng |

#### Chi phí dự kiến cho môi trường lab

Vì đây là môi trường lab nhỏ, chỉ sử dụng một EC2 workload và số lượng finding/test hạn chế, chi phí có thể được kiểm soát ở mức thấp nếu:

- Chỉ bật tài nguyên trong thời gian thực hành.
- Terminate EC2 sau khi test.
- Xóa EBS Snapshot sau khi hoàn thành.
- Empty và delete S3 bucket sau workshop.
- Xóa CloudWatch log group không còn cần thiết.
- Disable các dịch vụ security nếu không tiếp tục sử dụng.

Ước tính chi phí nên được kiểm tra lại bằng **AWS Pricing Calculator** trước khi triển khai chính thức.

```text
Estimated monthly lab cost: Low, depending on running time and enabled security services.
```

---

### 7. Đánh giá rủi ro

#### Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Xác suất | Mức độ |
|---|---|---|---|
| Phát sinh chi phí do quên xóa tài nguyên | Trung bình | Trung bình | Trung bình |
| Lambda cô lập nhầm EC2 | Cao | Thấp | Trung bình |
| IAM Role cấp quyền quá rộng | Cao | Trung bình | Cao |
| GuardDuty sample finding không kích hoạt đúng workflow | Trung bình | Trung bình | Trung bình |
| Dashboard không đồng bộ trạng thái DynamoDB | Trung bình | Trung bình | Trung bình |
| SNS Email/Slack không nhận được cảnh báo | Thấp | Trung bình | Thấp |
| Xóa nhầm tài nguyên không thuộc lab | Cao | Thấp | Trung bình |

#### Chiến lược giảm thiểu

- Gắn tag cho toàn bộ tài nguyên lab:

```text
Project = AWS-CloudSOC
Environment = Lab
```

- Chỉ cho phép auto isolation với EC2 có tag:

```text
AutoIsolate = true
```

- Sử dụng `SG-Isolation` thay vì xóa tài nguyên trực tiếp.
- Dùng approval workflow cho finding mức High.
- Chỉ auto response với finding Critical hoặc test event có kiểm soát.
- Chụp hình và lưu evidence trước khi cleanup.
- Kiểm tra kỹ tên resource trước khi delete.
- Giới hạn quyền IAM theo nguyên tắc least privilege.
- Tạo AWS Budget để theo dõi chi phí lab.

#### Kế hoạch dự phòng

Nếu auto isolation không hoạt động, có thể thực hiện thủ công:

```text
EC2
→ Instance
→ Security
→ Change security groups
→ Replace SG-Workload with SG-Isolation
```

Nếu SNS không gửi email, có thể kiểm tra lại subscription confirmation.

Nếu dashboard không đọc được DynamoDB, có thể kiểm tra lại API Gateway, Lambda API, CORS và IAM permission.

Nếu Step Functions không chạy, có thể test trực tiếp Lambda bằng sample GuardDuty event.

---

### 8. Kết quả kỳ vọng

Sau khi hoàn thành dự án, hệ thống AWS CloudSOC có thể đạt được các kết quả sau:

#### Cải tiến kỹ thuật

- Tạo được mô hình CloudSOC chạy trên AWS.
- Tự động phát hiện security finding từ GuardDuty.
- Tự động chuyển finding vào workflow bằng EventBridge.
- Điều phối phản ứng sự cố bằng Step Functions.
- Tự động xử lý incident bằng Lambda.
- Thu thập forensic evidence bằng Systems Manager.
- Tạo EBS Snapshot để hỗ trợ điều tra.
- Cô lập EC2 nghi ngờ bằng `SG-Isolation`.
- Lưu evidence vào S3.
- Cập nhật incident status trong DynamoDB.
- Gửi cảnh báo qua SNS, Email và Slack.
- Hiển thị incident trên SOC Dashboard.

#### Giá trị học tập

Dự án giúp người thực hiện hiểu rõ hơn về:

- AWS Security Services.
- Cloud Incident Response.
- Event-driven architecture.
- Serverless automation.
- Security monitoring.
- Forensic evidence collection.
- IAM Role và least privilege.
- Thiết kế kiến trúc theo chuẩn AWS Solution Architecture.

#### Giá trị dài hạn

Mô hình AWS CloudSOC có thể được mở rộng trong tương lai để:

- Tích hợp thêm nhiều nguồn log.
- Kết nối với SIEM bên ngoài.
- Thêm nhiều playbook response.
- Tự động phân loại incident theo mức độ rủi ro.
- Thêm dashboard chuyên nghiệp hơn.
- Tối ưu chi phí và vận hành theo FinOps.
- Áp dụng cho các bài lab Cloud Security nâng cao.