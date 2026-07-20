---
title: "Worklog Tuần 8"
date: 2026-06-27
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Tổng quan tuần 8 (27/06 – 03/07/2026)

Tuần thứ tám, em tiếp tục security track với các nội dung thiên về **bảo vệ dữ liệu** và **phát hiện mối đe dọa**: mã hóa bằng **AWS KMS**, truy cập private đến S3 bằng **VPC Endpoints**, rà soát best practices của **S3 Security**, bật **GuardDuty** và chuẩn hóa quản lý secrets bằng **Secrets Manager**.

### Mục tiêu tuần 8

* Thực hành **KMS** để hiểu nguyên lý mã hóa/giải mã và quản lý key.
* Tạo **VPC Endpoint** để truy cập S3 private (giảm phụ thuộc Internet).
* Áp dụng **S3 Security Best Practices**: policy, block public access, encryption.
* Bật **GuardDuty** và hiểu pipeline phát hiện threat.
* Quản lý credentials bằng **Secrets Manager** thay vì hardcode.

### Công việc đã triển khai

| Bước | Nội dung | Trạng thái | Link |
| --- | --- | --- | --- |
| 01 | AWS KMS: tạo key, mã hóa/giải mã thử nghiệm | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 02 | VPC Endpoint (Gateway) cho S3, test truy cập private | ✅ | [S3 Endpoint Lab](https://000069.awsstudygroup.com/) |
| 03 | S3 Security: Block Public Access, bucket policy, encryption | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 04 | GuardDuty: enable + xem findings + hiểu severity | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 05 | Secrets Manager: tạo secret, rotate/permission cơ bản | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 06 | Cleanup: xóa tài nguyên lab, kiểm tra phát sinh phí | ✅ | — |

### Em đã làm được gì trong tuần

**AWS KMS**
* Tạo customer managed key (CMK) và phân biệt key policy vs IAM policy.
* Thực hành encrypt/decrypt (dữ liệu mẫu) để hiểu “data key” và quyền sử dụng key.

**VPC Endpoint cho S3**
* Tạo **Gateway VPC Endpoint** cho S3 và gắn vào route table.
* Test truy cập S3 theo hướng “private path” (giảm exposure ra Internet).
* Ghi chú: endpoint policy là lớp kiểm soát bổ sung, nên dùng để giới hạn bucket/action.

**S3 Security Best Practices**
* Bật Block Public Access.
* Rà soát bucket policy theo hướng least privilege.
* Bật default encryption và kiểm tra object encryption khi upload.

**GuardDuty**
* Enable GuardDuty và theo dõi findings.
* Hiểu cách phân loại severity và luồng xử lý: triage → xác minh → khắc phục.

**Secrets Manager**
* Tạo secret (thông tin demo) và cấp quyền truy cập theo principle of least privilege.
* Ghi chú thói quen an toàn: không hardcode key/webhook vào source code.

### Kết quả đạt được

* Nắm được baseline về **encryption, private connectivity, threat detection, secrets hygiene**.
* Biết cách “đóng” bề mặt tấn công: S3 public access + Internet path.
* Có checklist thực hành để áp dụng lại trong dự án thực tế.

### Khó khăn gặp phải

* Nhầm lẫn key policy và IAM policy khi cấp quyền KMS — phải kiểm tra cả 2 lớp.
* Endpoint hoạt động nhưng vẫn bị deny do bucket policy chưa cho phép — cần kết hợp endpoint policy + bucket policy hợp lý.
* GuardDuty cần thời gian sync findings; không thấy ngay lập tức.

### Chuẩn bị cho tuần 9

* Chuyển sang IaC/Operations: **AWS Backup**, **CloudFormation**, giới thiệu **AWS CDK**.
