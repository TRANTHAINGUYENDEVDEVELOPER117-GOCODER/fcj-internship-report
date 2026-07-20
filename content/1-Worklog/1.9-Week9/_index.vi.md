---
title: "Worklog Tuần 9"
date: 2026-07-04
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# Worklog Tuần 9: AWS Backup, CloudFormation và AWS CDK

### Tổng quan tuần 9 (04/07 – 10/07/2026)

Trong tuần thứ chín, em hoàn thành nhóm nội dung thuộc phần **Optimize on AWS**, tập trung vào **khả năng khôi phục hệ thống** và **Infrastructure as Code (IaC)**. Các chủ đề chính gồm **AWS Backup**, **CloudFormation Basic/Advanced** và làm quen với **AWS CDK**.

Trọng tâm của tuần này là hiểu cách doanh nghiệp giảm rủi ro mất dữ liệu, chuẩn hóa triển khai hạ tầng và kiểm soát thay đổi bằng code thay vì thao tác thủ công trên AWS Console.

### Mục tiêu tuần 9

- Hiểu vai trò của **AWS Backup** trong chiến lược khôi phục sau sự cố.
- Tạo backup vault, backup plan, rule, selection và thiết lập retention.
- Ôn tập CloudFormation template, parameters, resources, outputs.
- Tìm hiểu update stack, rollback, change set và drift detection.
- Làm quen AWS CDK và so sánh CDK với CloudFormation truyền thống.
- Cleanup tài nguyên sau lab để tránh phát sinh chi phí.

### Công việc đã thực hiện

| Bước | Nội dung | Trạng thái | Link |
| --- | --- | --- | --- |
| 01 | AWS Backup: vault, backup plan, schedule/retention | ✅ Hoàn thành | [Cloud Journey – Optimize](https://cloudjourney.awsstudygroup.com/3-optimize/) |
| 02 | CloudFormation Basic: template, parameters, outputs | ✅ Hoàn thành | [CF Lab](https://000037.awsstudygroup.com/3-cloudformationbasic/) |
| 03 | CloudFormation Advanced: change set, rollback, drift detection | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 04 | AWS CDK: app, stack, construct, synth/deploy | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 05 | Cleanup stack, backup plan và tài nguyên lab | ✅ Hoàn thành | — |

### Nội dung chi tiết

#### AWS Backup

Em tìm hiểu cách AWS Backup hỗ trợ quản lý backup tập trung cho nhiều loại tài nguyên. Các khái niệm quan trọng gồm:

- **Backup vault:** nơi lưu trữ recovery points.
- **Backup plan:** định nghĩa lịch backup, retention và lifecycle.
- **Backup rule:** quy định tần suất, thời gian và cách lưu giữ.
- **Backup selection:** xác định tài nguyên nào được đưa vào backup plan.

Qua phần này, em hiểu backup không chỉ là sao lưu dữ liệu mà còn là một phần của chiến lược **business continuity** và **disaster recovery**.

#### CloudFormation

Em ôn lại cấu trúc template YAML/JSON:

- `AWSTemplateFormatVersion`
- `Description`
- `Parameters`
- `Resources`
- `Outputs`

Em cũng tìm hiểu cách CloudFormation giúp triển khai hạ tầng nhất quán, dễ review và giảm lỗi cấu hình thủ công. Các nội dung nâng cao như **change set**, **rollback** và **drift detection** giúp kiểm soát rủi ro khi cập nhật stack.

#### AWS CDK

AWS CDK giúp định nghĩa hạ tầng bằng ngôn ngữ lập trình, sau đó synth ra CloudFormation template. So với viết CloudFormation trực tiếp, CDK dễ tái sử dụng construct, chia module và quản lý logic phức tạp hơn.

Flow cơ bản:

```text
CDK App → Stack → Construct → cdk synth → CloudFormation template → cdk deploy
```

### Kết quả đạt được

- Hiểu vai trò của backup trong vận hành hệ thống cloud.
- Nắm được cách CloudFormation chuẩn hóa hạ tầng và kiểm soát thay đổi.
- Biết vì sao drift detection quan trọng khi có thao tác thủ công ngoài IaC.
- Hiểu điểm khác biệt giữa CloudFormation và AWS CDK.
- Cleanup tài nguyên sau lab để kiểm soát chi phí.

### Liên hệ An ninh mạng

Tuần 9 liên quan trực tiếp đến khả năng phục hồi sau sự cố. Trong an ninh mạng, sau khi phát hiện sự cố như mã độc, thao tác sai hoặc xóa dữ liệu ngoài ý muốn, hệ thống cần có backup đáng tin cậy để khôi phục. IaC cũng giúp giảm rủi ro cấu hình sai vì mọi thay đổi đều có thể review, version control và triển khai lại.

### Khó khăn và bài học

- YAML rất nhạy với indentation, cần kiểm tra kỹ trước khi deploy.
- Update stack có thể thay thế hoặc xóa tài nguyên nếu không đọc change set.
- Backup plan cần được thiết kế theo RPO/RTO, không chỉ tạo cho có.
- IaC giúp chuyên nghiệp hóa vận hành nhưng cần quy trình review rõ ràng.

### Chuẩn bị cho tuần 10

Sau khi hoàn thành tuần 9, em chuyển sang phần **Modernize Application**, tập trung vào serverless, API Gateway, Lambda, Cognito, SQS/SNS và CloudWatch/X-Ray.

