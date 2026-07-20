---
title: "Worklog Tuần 12"
date: 2026-07-25
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

# Worklog Tuần 12: Tổng kết, Cleanup và Hoàn thiện báo cáo

### Tổng quan tuần 12 (25/07 – 31/07/2026)

Tuần 12 là giai đoạn tổng kết cuối cùng của chương trình **First Cloud Journey Workforce Bootcamp**. Trọng tâm tuần này không còn là học thêm dịch vụ mới mà là rà soát toàn bộ lộ trình, hoàn thiện website báo cáo Hugo, kiểm tra nội dung song ngữ, chuẩn hóa Proposal/Workshop/Blogs, viết Self-evaluation và Feedback cuối kỳ, đồng thời cleanup các tài nguyên AWS còn lại.

Đây là bước quan trọng để biến toàn bộ quá trình học từ tuần 1 đến tuần 11 thành một báo cáo hoàn chỉnh, có cấu trúc rõ ràng và sẵn sàng nộp cho công ty/mentor.

### Mục tiêu tuần 12

- Rà soát toàn bộ Worklog từ tuần 1 đến tuần 12.
- Kiểm tra tính nhất quán giữa Home, Proposal, Blogs, Workshop, Self-evaluation và Feedback.
- Hoàn thiện Workshop AWS CloudSOC và hướng dẫn vẽ sơ đồ kiến trúc.
- Hoàn thiện 3 bài Blogs Posted dựa trên các bài AWS Blog.
- Viết bản tự đánh giá cuối kỳ và feedback chương trình.
- Cleanup tài nguyên AWS để tránh phát sinh chi phí.
- Build Hugo và kiểm tra website trước khi nộp.

### Công việc đã thực hiện

| Hạng mục | Nội dung | Trạng thái |
| --- | --- | --- |
| Worklog | Rà soát và hoàn thiện tuần 1–12 | ✅ Hoàn thành |
| Proposal | Viết lại Proposal AWS CloudSOC học thuật, thuyết phục hơn | ✅ Hoàn thành |
| Workshop | Hoàn thiện báo cáo CloudSOC, sơ đồ, module hướng dẫn vẽ và checklist | ✅ Hoàn thành |
| Blogs Posted | Viết lại 3 bài blog về Bedrock Guardrails, Apache Iceberg/MV và Redshift Patch Testing | ✅ Hoàn thành |
| Self-evaluation | Cập nhật đánh giá cuối kỳ | ✅ Hoàn thành |
| Feedback | Cập nhật phản hồi cuối chương trình | ✅ Hoàn thành |
| Cleanup | Chuẩn bị checklist cleanup tài nguyên AWS | ✅ Hoàn thành |
| Hugo Build | Chạy build và kiểm tra website | ✅ Hoàn thành |

### Nội dung hoàn thiện trong tuần

#### Hoàn thiện Worklog

Em kiểm tra lại toàn bộ lộ trình 12 tuần:

- Tuần 1–2: Explore AWS Services.
- Tuần 3–9: Optimize on AWS.
- Tuần 10–11: Modernize Application.
- Tuần 12: Tổng kết, cleanup và hoàn thiện báo cáo.

Các tuần 9, 10 và 11 được cập nhật từ trạng thái kế hoạch/đang làm sang hoàn thành, có đầy đủ mục tiêu, nội dung thực hiện, kết quả, liên hệ An ninh mạng và bài học rút ra.

#### Hoàn thiện Proposal

Proposal được viết lại theo hướng chuyên nghiệp hơn, có cấu trúc như một tài liệu đề xuất dự án:

- Lời mở đầu.
- Tóm tắt điều hành.
- Vấn đề cần giải quyết.
- Mục tiêu và phạm vi.
- Kiến trúc AWS CloudSOC.
- Luồng xử lý SOC.
- Giá trị kỹ thuật, bảo mật và học thuật.
- Kế hoạch triển khai.
- Rủi ro và biện pháp kiểm soát.
- Tiêu chí nghiệm thu và đề xuất chấp thuận.

#### Hoàn thiện Workshop

Phần Workshop được chuyển thành dự án **AWS CloudSOC**, gồm:

- Báo cáo chi tiết kiến trúc.
- Luồng phát hiện, điều tra, approval, forensic, snapshot và isolation.
- Sơ đồ kiến trúc CloudSOC.
- Hướng dẫn vẽ sơ đồ bằng draw.io theo từng module.
- Checklist review trước khi nộp.
- Hướng phát triển production.
- Cleanup checklist.

#### Hoàn thiện Blogs Posted

Ba bài blog đã được viết lại theo nội dung AWS Blog:

1. Bảo vệ ứng dụng Generative AI bằng Amazon Bedrock Guardrails.
2. Ứng dụng Apache Iceberg và Materialized Views để truy vấn log siêu tốc.
3. Tự động hóa Patch Testing trên Amazon Redshift.

Các bài viết đều có ảnh minh họa, phần tóm tắt, phân tích kiến trúc, bài học rút ra và tài liệu tham khảo.

#### Cleanup tài nguyên AWS

Checklist cleanup gồm:

- Kiểm tra EC2, EBS volume/snapshot và Elastic IP.
- Xóa CloudFormation stack không dùng.
- Xóa Lambda/API Gateway/SQS/SNS lab nếu còn tồn tại.
- Kiểm tra S3 bucket và log object.
- Xóa ECR image/ECS service/pipeline nếu đã tạo trong lab.
- Tắt hoặc kiểm tra các dịch vụ có thể phát sinh phí như GuardDuty, Security Hub, Detective, CloudWatch Logs.

### Kết quả cuối kỳ

- Website báo cáo Hugo hoàn chỉnh, song ngữ Việt/Anh.
- Worklog 12 tuần được cập nhật đầy đủ.
- Proposal và Workshop bám sát dự án AWS CloudSOC.
- Blogs Posted được thay bằng 3 bài kỹ thuật thực tế.
- Self-evaluation và Feedback được cập nhật theo trạng thái cuối chương trình.
- Website build thành công và sẵn sàng để nộp.

### Bài học rút ra

Qua 12 tuần, em hiểu rõ hơn cách các dịch vụ AWS kết nối với nhau trong một hệ thống thực tế. Điểm quan trọng nhất không chỉ là biết từng dịch vụ riêng lẻ, mà là biết cách kết hợp chúng thành một kiến trúc có mục tiêu: vận hành ổn định, bảo mật, có khả năng giám sát và có quy trình cleanup rõ ràng.

Với chuyên ngành An ninh mạng, chương trình giúp em liên hệ kiến thức lý thuyết với thực tế cloud security: IAM least privilege, logging, monitoring, incident response, WAF, GuardDuty, KMS, backup, IaC và CI/CD security.

### Kết luận tuần 12

Tuần 12 hoàn tất quá trình học và tổng hợp báo cáo. Sau khi hoàn thiện tuần này, website có thể được xem là bản báo cáo cuối cùng cho chương trình FCAJ, sẵn sàng để gửi cho công ty, mentor hoặc dùng làm tài liệu trình bày.

