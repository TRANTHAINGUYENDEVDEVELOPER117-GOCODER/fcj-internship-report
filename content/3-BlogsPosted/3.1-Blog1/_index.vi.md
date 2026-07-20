---
title: "Hoàn thành Proof of Concept AWS CloudSOC"
date: 2026-07-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

Sau hơn hai tuần làm việc miệt mài, nhóm mình đã chính thức hoàn thành **Proof of Concept** cho dự án **AWS CloudSOC – Hệ thống phát hiện, điều tra và phản ứng sự cố an ninh mạng trên nền tảng AWS**.

Đây không chỉ là một bản thiết kế trên giấy hay một diagram đẹp mắt, mà là một hệ thống thực tế có thể vận hành được từ đầu đến cuối. Từ lúc **Threat Actor** thực hiện các cuộc tấn công thử nghiệm lên EC2 instance như **port scanning**, **SSH brute-force** hoặc truy cập từ IP đáng ngờ, hệ thống có thể tự động phát hiện thông qua **Amazon GuardDuty**, điều phối workflow, thu thập bằng chứng và cô lập máy chủ một cách có kiểm soát.

---

## Tổng quan hệ thống

Dự án AWS CloudSOC được xây dựng nhằm mô phỏng một hệ thống **Security Operations Center** trên môi trường AWS. Hệ thống tập trung vào quy trình phát hiện, điều tra, phản ứng sự cố và gửi cảnh báo đến SOC Analyst.

Luồng xử lý chính của hệ thống gồm:

```text
Threat Activity
→ Amazon GuardDuty
→ Amazon EventBridge
→ AWS Step Functions
→ Incident Response Lambda
→ AWS Systems Manager
→ EC2 Isolation
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS Alert
→ Email / Slack Notification
```

Thông qua luồng này, hệ thống có thể phát hiện security finding, xử lý incident, thu thập forensic evidence, cô lập EC2 nghi ngờ bị ảnh hưởng và gửi cảnh báo đến người vận hành.

---

## Kiến trúc tổng quan

Dưới đây là diagram tổng quan kiến trúc hệ thống mà nhóm đã xây dựng:

![AWS CloudSOC Architecture](/images/2-Proposal/cloudsoc-architecture.png)

Sơ đồ thể hiện các thành phần chính của hệ thống như:

```text
Amazon GuardDuty
AWS Security Hub
Amazon EventBridge
AWS Step Functions
AWS Lambda
AWS Systems Manager
Amazon EC2
Amazon S3
Amazon DynamoDB
Amazon SNS
Amazon CloudWatch
Amazon Detective
AWS Config
AWS CloudTrail
AWS Amplify
Amazon API Gateway
Amazon Cognito
```

Các dịch vụ này phối hợp với nhau để tạo thành một mô hình CloudSOC có khả năng phát hiện, điều phối, phản ứng và cảnh báo sự cố bảo mật.

---

## Những gì mình học được từ dự án

Thông qua dự án này, mình học được nhiều kiến thức thực tế về **Cloud Security** và **Incident Response** trên AWS.

Một số điểm quan trọng gồm:

- Hiểu sâu hơn về cách các dịch vụ Security của AWS hoạt động phối hợp với nhau, đặc biệt là **Amazon GuardDuty**, **AWS Security Hub**, **Amazon Detective**, **Amazon EventBridge** và **AWS Step Functions**.
- Biết cách thiết kế một kiến trúc **event-driven** thực tế thay vì chỉ dựa vào template có sẵn.
- Hiểu rõ hơn vai trò của **AWS Lambda** và **AWS Systems Manager** trong việc tự động hóa phản ứng sự cố.
- Biết cách lưu trữ forensic evidence vào **Amazon S3** và cập nhật trạng thái incident trong **Amazon DynamoDB**.
- Nhận ra sự khác biệt giữa mô hình hoàn toàn serverless và **hybrid architecture**, khi vẫn cần giữ **Amazon EC2** làm workload thử nghiệm để dễ minh họa và demo quy trình SOC.

---

## Những kinh nghiệm rút ra

Trong quá trình triển khai, nhóm mình nhận ra rằng an ninh trên Cloud không phải là tự động hóa càng nhiều càng tốt. Một hệ thống phản ứng sự cố cần có cơ chế kiểm soát để tránh ảnh hưởng đến môi trường production.

Một số kinh nghiệm quan trọng:

- Cần có cơ chế **phê duyệt thủ công** đối với các incident có mức độ nghiêm trọng cao nhưng chưa đủ điều kiện tự động xử lý.
- Nên có chế độ **Dry-run** để kiểm thử workflow trước khi thực hiện hành động thật.
- Auto isolation chỉ nên áp dụng với những EC2 có tag rõ ràng, ví dụ `AutoIsolate=true`.
- Cần thu thập forensic evidence trước khi thực hiện các hành động isolation.
- Không nên terminate tài nguyên ngay khi phát hiện sự cố, vì có thể làm mất bằng chứng phục vụ điều tra.
- Cần gắn tag cho toàn bộ tài nguyên lab để dễ quản lý và cleanup.

---

## Kết quả đạt được

Sau khi hoàn thành Proof of Concept, nhóm đã xây dựng được một hệ thống có thể vận hành theo quy trình:

```text
Detect
→ Investigate
→ Respond
→ Store Evidence
→ Notify
```

Các kết quả chính gồm:

- GuardDuty phát hiện và tạo security findings.
- EventBridge nhận finding và kích hoạt workflow.
- Step Functions điều phối quy trình phản ứng sự cố.
- Lambda xử lý logic incident response.
- Systems Manager thu thập forensic evidence từ EC2.
- EBS Snapshot được tạo để phục vụ điều tra.
- S3 lưu raw event và response summary.
- DynamoDB cập nhật trạng thái incident.
- SNS gửi cảnh báo đến Email hoặc Slack.
- SOC Dashboard hiển thị trạng thái xử lý incident.

---

## Kết luận

Dự án AWS CloudSOC giúp nhóm mình hiểu rõ hơn về cách xây dựng một hệ thống SOC trên nền tảng Cloud. Đây không chỉ là một bài lab về AWS, mà còn là cơ hội để hiểu quy trình thực tế của **Cloud Security**, **Incident Response** và **Security Automation**.

Trong các bài viết tiếp theo, mình sẽ tiếp tục chia sẻ chi tiết hơn về luồng xử lý sự cố cũng như những bài học kinh nghiệm thực tế khi xây dựng hệ thống CloudSOC trên AWS.