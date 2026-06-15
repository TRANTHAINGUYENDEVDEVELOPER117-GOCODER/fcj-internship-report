---
title: "Worklog Tuần 6"
date: 2026-06-13
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Tổng quan tuần 6 (13/06 – 19/06/2026)

Tuần thứ sáu, em hoàn tất nốt **Lab 20 – bước 06: Add Transit Gateway Routes to VPC Route Tables** ([video hướng dẫn](https://youtu.be/QSXgL2KodQI?si=M1erQf5i0Zrk0PQJ)), sau đó chuyển sang mục **Optimize – Operate** trên [Cloud Journey](https://cloudjourney.awsstudygroup.com/3-optimize/). Tuần này em tập trung vào **tự động hóa serverless**, **giám sát hệ thống** và **quản lý tài nguyên bằng tag** — các kỹ năng vận hành quan trọng khi môi trường AWS ngày càng nhiều EC2 và dịch vụ.

### Mục tiêu tuần 6

* Hoàn thành **Lab 22 – Lambda tự động tắt EC2** và gửi thông báo Slack.
* Triển khai **Lab 29 – CloudWatch + Grafana** để giám sát tài nguyên.
* Thực hành **Lab 27 – Tags & Resource Groups** và **Lab 28 – Tag through IAM**.
* Áp dụng nguyên tắc **least privilege** khi phân quyền theo tag.

### Công việc đã triển khai

| Bước | Nội dung | Trạng thái | Link |
| --- | --- | --- | --- |
| 20-06 | Thêm route Transit Gateway vào VPC Route Tables | ✅ | [Video Lab 20-06](https://youtu.be/QSXgL2KodQI?si=M1erQf5i0Zrk0PQJ) |
| 22 | Lambda `dc-common-lambda-auto-stop` + EventBridge schedule | ✅ | [Lab 22](https://000022.awsstudygroup.com/) |
| 22 | Slack Incoming Webhook, thông báo instance bị stop | ✅ | [Slack Webhook](https://000022.awsstudygroup.com/2-prerequiste/2.4-incomingwebhooksslack/) |
| 29 | Cài Grafana trên EC2, kết nối CloudWatch data source | ✅ | [Lab 29](https://000029.awsstudygroup.com/) |
| 27 | Gắn tag EC2, tạo Resource Group theo tag | ✅ | [Lab 27](https://000027.awsstudygroup.com/) |
| 28 | IAM policy có điều kiện `aws:RequestTag`, `ec2:ResourceTag` | ✅ | [Lab 28](https://000028.awsstudygroup.com/) |
| — | Cleanup Lambda, EventBridge, EC2 lab | ✅ | [Cleanup Lab 22](https://000022.awsstudygroup.com/7-cleanup/) |

### Em đã làm được gì trong tuần

**Lab 20 – Bước 06: VPC Route Tables**
* Sau khi cấu hình Transit Gateway route tables ở tuần 5, em thêm route trỏ về **Transit Gateway** trong **VPC route tables** của từng VPC (destination = CIDR VPC đích).
* Kiểm tra lại: EC2 ở VPC nguồn ping được private IP ở VPC đích — traffic đi qua TGW thay vì Internet.
* Xem lại video [Module 02-Lab20-06](https://youtu.be/QSXgL2KodQI?si=M1erQf5i0Zrk0PQJ) để đối chiếu từng bước trên console.

**Lab 22 – Lambda tự động tắt EC2**
* Tạo EC2 test với tag `environment_auto`, cấu hình **Slack Incoming Webhook** workspace `aws-lambda-labs`.
* Viết Lambda Python dùng `boto3` filter instance theo tag, gọi `instances.stop()`, gửi POST tới Slack bằng `urllib3`.
* Tạo **EventBridge rule** schedule trigger Lambda theo giờ — mô phỏng tắt máy ngoài giờ làm việc, tiết kiệm chi phí.

**Lab 29 – CloudWatch + Grafana**
* Launch EC2, cài **Grafana**, cấu hình data source **CloudWatch** (Access Key + Secret Key IAM user read-only).
* Tạo dashboard theo dõi metric EC2 (`CPUUtilization`, `NetworkIn/Out`).
* Hiểu Grafana là lớp **visualization** trên CloudWatch — không thay thế CloudWatch mà bổ sung giao diện giám sát trực quan hơn.

**Lab 27 – Tags & Resource Groups**
* Gắn tag `Key=Team, Value=Alpha` và `Key=Name` cho EC2.
* Tạo **Resource Group** query theo tag `Team=Alpha` — quản lý hàng loạt instance cùng nhóm thay vì tìm từng cái.
* Tag giúp phân loại theo môi trường (dev/test/prod), owner, dự án.

**Lab 28 – Tag through IAM**
* Tạo policy `ec2-create-tags`, `ec2-manage-instances` với **IAM Condition**:
  * `aws:RequestTag/Team` = `Alpha`
  * `ec2:ResourceTag/Team` = `Alpha`
* User chỉ được tạo/quản lý EC2 khi gắn đúng tag — **ABAC** (Attribute-Based Access Control).
* Verify bằng assume role: user không đúng tag → `Access Denied`.

### Kết quả đạt được

* Hoàn thành **Lab 20 bước 06** và toàn bộ lab tuần 6 (22, 27, 28, 29).
* Tự động hóa vận hành EC2 bằng **Lambda + EventBridge** — không cần cron trên server.
* Giám sát metric qua **Grafana dashboard** kết nối CloudWatch.
* Quản lý tài nguyên theo **tag + Resource Groups**, kiểm soát quyền EC2 bằng **IAM conditions**.
* Cleanup đầy đủ sau mỗi lab, tránh phát sinh chi phí Lambda invocation và EC2 chạy nền.

### Kiến thức liên quan An ninh mạng

| Kỹ năng | Ứng dụng |
| --- | --- |
| Least privilege | IAM policy giới hạn EC2 theo tag Team |
| ABAC | Phân quyền theo thuộc tính resource, không chỉ theo user |
| Audit & monitoring | Grafana + CloudWatch phát hiện bất thường CPU/traffic |
| Secrets handling | Slack webhook URL lưu trong Lambda env, không hardcode public |

### Khó khăn gặp phải

* Lambda không stop được EC2 — thiếu quyền `ec2:StopInstances` trên execution role.
* Slack không nhận thông báo — webhook URL sai hoặc channel chưa add app.
* Grafana không query CloudWatch — IAM user thiếu `cloudwatch:GetMetricData`.
* IAM condition phức tạp — ban đầu tạo EC2 không tag `Team=Alpha` bị deny, phải đọc kỹ `aws:RequestTag` vs `ec2:ResourceTag`.

> **Lưu ý:** Nếu em chưa hoàn thành bước nào, hãy đổi trạng thái trong bảng trên cho đúng thực tế.

### Chuẩn bị cho tuần 7

* Sang mục **Security** trên Cloud Journey: IAM Permission Boundary, IAM Conditions, Security Hub, WAF.
* Ôn lại IAM policy JSON và khái niệm effective permissions trước khi làm lab bảo mật.
