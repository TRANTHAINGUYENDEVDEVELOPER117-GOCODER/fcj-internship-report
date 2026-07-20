---
title: "Bài viết đã đăng"
date: 2026-07-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

# Bài viết đã đăng

Phần này giới thiệu các bài blog đã được chia sẻ trong quá trình thực hiện dự án **AWS CloudSOC – Hệ thống phát hiện, điều tra và phản ứng sự cố an ninh mạng trên nền tảng AWS**.

Các bài viết tập trung trình bày quá trình hoàn thành Proof of Concept, luồng xử lý sự cố, các dịch vụ AWS Security được sử dụng và những bài học thực tế khi xây dựng một mô hình Security Operations Center trên AWS.

Những chủ đề chính bao gồm **Cloud Security**, **Security Operations Center**, **Incident Response**, **Amazon GuardDuty**, **Amazon EventBridge**, **AWS Step Functions**, **AWS Lambda**, **AWS Systems Manager**, **Amazon S3**, **Amazon DynamoDB** và **Amazon SNS**.

---

### [Blog 1 - Hoàn thành Proof of Concept AWS CloudSOC](3.1-Blog1/)

Bài viết này giới thiệu quá trình nhóm hoàn thành **Proof of Concept cho dự án AWS CloudSOC** sau hơn hai tuần triển khai. Nội dung tập trung vào mục tiêu của dự án, kiến trúc tổng quan và cách hệ thống phát hiện các hành vi đáng ngờ như port scanning, SSH brute-force hoặc truy cập từ IP đáng ngờ.

Bài viết cũng trình bày cách các dịch vụ như **Amazon GuardDuty**, **Amazon EventBridge**, **AWS Step Functions**, **AWS Lambda**, **AWS Systems Manager**, **Amazon S3**, **Amazon DynamoDB** và **Amazon SNS** phối hợp với nhau để tạo thành một quy trình phát hiện và phản ứng sự cố từ đầu đến cuối.

---

### [Blog 2 - Quy trình xử lý sự cố thông minh và có kiểm soát trong AWS CloudSOC](3.2-Blog2/)

Bài viết này tập trung vào luồng xử lý sự cố trong hệ thống AWS CloudSOC. Nội dung giải thích cách một security finding từ **Amazon GuardDuty** được đưa vào **Amazon EventBridge**, sau đó kích hoạt **AWS Step Functions** để điều phối quy trình phản ứng sự cố.

Bài viết cũng mô tả cách hệ thống xử lý incident dựa trên mức độ nghiêm trọng, loại tài nguyên bị ảnh hưởng, tag `AutoIsolate=true` và chế độ Dry-run. Các bước quan trọng bao gồm phê duyệt bởi SOC Analyst, thu thập forensic evidence bằng **AWS Systems Manager**, tạo EBS Snapshot, cô lập EC2 bằng `SG-Isolation`, lưu bằng chứng vào **Amazon S3**, cập nhật trạng thái trong **Amazon DynamoDB** và gửi cảnh báo qua **Amazon SNS**, Email hoặc Slack.

---

### [Blog 3 - Kết thúc dự án AWS CloudSOC: Những bài học quý giá nhất](3.3-Blog3/)

Bài viết này tổng kết những bài học quan trọng sau khi hoàn thành dự án AWS CloudSOC. Nội dung đề cập đến sự khác biệt giữa môi trường Lab và Production, tầm quan trọng của controlled automation, thiết kế IAM theo nguyên tắc least privilege, bảo toàn forensic evidence, logging, kiểm soát chi phí và kiểm thử thực tế.

Bài viết cũng chia sẻ giá trị của dự án đối với quá trình học **AWS Security**, **Cloud SOC**, **Incident Response**, **Event-driven Architecture** và **Security Automation**. Đây là bài viết kết thúc chuỗi blog, giúp tổng hợp lại những kinh nghiệm thực tế đã tích lũy được trong quá trình triển khai dự án.

---

## Tổng kết

Thông qua ba bài blog này, dự án AWS CloudSOC được trình bày theo ba góc nhìn chính:

```text
Blog 1: Tổng quan dự án và hoàn thành Proof of Concept
Blog 2: Luồng xử lý sự cố và controlled automation
Blog 3: Bài học kinh nghiệm và giá trị thực tế sau dự án
```

Ba bài viết giúp người đọc hiểu được cách dự án được thiết kế, triển khai, kiểm thử và đánh giá như một bài lab thực tế về Cloud Security trên AWS.