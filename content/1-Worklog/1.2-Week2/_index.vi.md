---
title: "Worklog Tuần 2"
date: 2026-05-16
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

### Tổng quan tuần 2 (16/05 – 22/05/2026)

Tuần thứ hai, em tiếp tục **Module 01 – AWS Foundation**, thực hành các dịch vụ cốt lõi: **VPC, EC2, S3, RDS** và một số dịch vụ hỗ trợ (CloudWatch, Route 53, AWS CLI). Đây là giai đoạn em xây dựng kiến thức nền trước khi chuyển sang Module 02.

### Mục tiêu tuần 2

* Thực hành triển khai VPC, EC2, S3, RDS.
* Kết nối các dịch vụ với nhau (EC2 ↔ S3, EC2 ↔ RDS).
* Làm quen AWS CLI và CloudWatch.

### Các lab đã thực hành

| Lab | Nội dung | Trạng thái |
| --- | --- | --- |
| Lab 05 | VPC – subnet, IGW, Route Table, Security Group | ✅ |
| Lab 06–07 | EC2 – launch instance, SSH, EBS, Elastic IP | ✅ |
| Lab 08 | IAM Roles for EC2 | ✅ |
| Lab 09 | AWS Cloud9 | ✅ |
| Lab 10 | S3 – static website hosting | ✅ |
| Lab 11 | RDS – tạo database, kết nối từ EC2 | ✅ |
| Lab 12–13 | Lightsail, EC2 Auto Scaling | ✅ |
| Lab 14 | CloudWatch – metric, alarm | ✅ |
| Lab 15 | Route 53 – hosted zone, record | ✅ |
| Lab 16 | AWS CLI – cài đặt, `aws configure` | ✅ |
| Lab 17–18 | DynamoDB, ElastiCache cơ bản | ✅ |

### Em đã làm được gì trong tuần

**Mạng & Compute (Lab 05–07)**
* Tạo VPC với subnet public/private, gắn Internet Gateway.
* Launch EC2 instance, kết nối SSH bằng key pair (.pem).
* Gắn thêm EBS volume và gán Elastic IP.

**Storage & Database (Lab 08–11)**
* Gán IAM Role cho EC2 để truy cập S3 an toàn.
* Tạo S3 bucket, bật static website hosting.
* Tạo RDS instance và kết nối từ EC2 (cấu hình Security Group port 3306).

**Vận hành (Lab 12–16)**
* Làm quen Lightsail và Auto Scaling cơ bản.
* Tạo CloudWatch alarm giám sát EC2.
* Cấu hình Route 53 record.
* Cài AWS CLI trên Windows, chạy `aws sts get-caller-identity`.

**NoSQL & Cache (Lab 17–18)**
* Tạo bảng DynamoDB và làm quen ElastiCache.

### Kết quả đạt được

* Hoàn thành các lab nền tảng **Lab 05 – Lab 18**.
* Triển khai được luồng cơ bản: **VPC → EC2 → S3/RDS**.
* Biết dùng song song **Console** và **CLI**.
* Sẵn sàng chuyển sang Module 02 (Optimizing).

### Khó khăn gặp phải

* **SSH trên Windows:** Lỗi permission file `.pem` → dùng `icacls` chỉnh quyền.
* **RDS không kết nối được:** Quên mở Security Group port 3306 cho EC2.
* **Chi phí:** Nhớ xóa NAT Gateway, Elastic IP sau mỗi lab.

> **Lưu ý:** Nếu em chưa hoàn thành lab nào ở bảng trên, hãy đổi trạng thái tương ứng trước khi nộp báo cáo chính thức.

### Chuẩn bị cho tuần 3

* Chuyển sang **Module 02**, bắt đầu **Lab 19 – VPC Peering** và CloudFormation.
