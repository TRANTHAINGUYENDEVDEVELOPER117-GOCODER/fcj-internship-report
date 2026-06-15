---
title: "Worklog Tuần 7"
date: 2026-06-20
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Tổng quan tuần 7 (20/06 – 26/06/2026)

Tuần thứ bảy, em chuyển sang mục **Security** trên [Cloud Journey – Optimize](https://cloudjourney.awsstudygroup.com/3-optimize/) — phù hợp với ngành **An ninh mạng** em đang theo học tại HUTECH. Tuần này em thực hành **IAM Permission Boundary**, **IAM Conditions giới hạn assume role**, **AWS Security Hub** và **AWS WAF** — các lớp bảo vệ từ identity đến ứng dụng web.

### Mục tiêu tuần 7 — Security Track

* Triển khai **Lab 30 – IAM Permission Boundary** để giới hạn quyền tối đa.
* Cấu hình **Lab 44 – IAM Role & Condition** (giới hạn IP, thời gian khi assume role).
* Bật và xem findings trên **Lab 18 – AWS Security Hub**.
* Bảo vệ ứng dụng web với **Lab 26 – AWS WAF** (OWASP Juice Shop).

### Công việc đã triển khai

| Bước | Nội dung | Trạng thái | Link |
| --- | --- | --- | --- |
| 30 | Tạo policy `ec2-admin-restrict-region`, gắn Permission Boundary | ✅ | [Lab 30](https://000030.awsstudygroup.com/) |
| 30 | Verify effective permissions = intersection boundary ∩ identity policy | ✅ | [Create Policy](https://000030.awsstudygroup.com/3-createpolicy/) |
| 44 | Tạo role EC2/RDS admin, restrict assume role theo IP | ✅ | [Lab 44](https://000044.awsstudygroup.com/) |
| 44 | Giới hạn thời gian được phép switch role | ✅ | [IAM Condition](https://000044.awsstudygroup.com/4-configure-iam-role-with-condition/3-condition/) |
| 18 | Enable Security Hub, xem CIS/AWS Foundational benchmarks | ✅ | [Lab 18](https://000018.awsstudygroup.com/) |
| 26 | Deploy OWASP Juice Shop qua CloudFormation | ✅ | [Lab 26](https://000026.awsstudygroup.com/2-prepare/2.2-deploythesamplewebapp/) |
| 26 | Tạo Web ACL + AWS Managed Rules (Core, SQLi) | ✅ | [Web ACL](https://000026.awsstudygroup.com/3-useawswaf/3.1-createswebacl/) |
| 26 | Test rule Count, custom rule JSON, cleanup | ✅ | [Test WAF](https://000026.awsstudygroup.com/3-useawswaf/3.4-testingnewrule/) |

### Em đã làm được gì trong tuần

**Lab 30 – IAM Permission Boundary**
* Tạo policy JSON giới hạn user chỉ thao tác `ec2:*` trong region `ap-southeast-1`:
  ```json
  "Condition": { "StringEquals": { "aws:RequestedRegion": ["ap-southeast-1"] } }
  ```
* Gắn policy này làm **Permissions boundary** cho user EC2 Admin.
* Dù gắn thêm policy `AdministratorAccess`, effective permissions vẫn bị **cắt** bởi boundary — ngăn privilege escalation.
* Hiểu: boundary **không grant** quyền, chỉ đặt **trần** tối đa; effective = boundary ∩ identity policies.

**Lab 44 – IAM Role & Condition**
* Tạo IAM user/group admin riêng cho EC2 và RDS (least privilege thay vì full admin).
* Cấu hình **trust policy** trên role với condition:
  * `aws:SourceIp` — chỉ assume role từ IP văn phòng/lab.
  * `DateGreaterThan` / `DateLessThan` — chỉ trong khung giờ làm việc.
* Test assume role ngoài IP/giờ cho phép → `Access Denied`.

**Lab 18 – AWS Security Hub**
* Enable Security Hub trên account, bật tiêu chuẩn **AWS Foundational Security Best Practices** và **CIS AWS Foundations**.
* Xem dashboard tổng hợp findings từ GuardDuty, Inspector, Macie (nếu bật).
* Phân loại finding theo severity (CRITICAL, HIGH, MEDIUM) — ưu tiên xử lý trước.
* Chi phí lab thấp (~$1/tháng) nếu chỉ test, không simulate attack liên tục.

**Lab 26 – AWS WAF**
* Deploy **OWASP Juice Shop** (app cố ý insecure) qua CloudFormation → CloudFront URL.
* Tạo **Web ACL** `waf-workshop-juice-shop`, gắn **AWS Managed Rule groups**:
  * `AWSManagedRulesCommonRuleSet` — chặn XSS, LFI...
  * `AWSManagedRulesSQLiRuleSet` — chặn SQL injection.
* Test bằng `curl`:
  * XSS payload `<script>alert</script>` → **blocked (403)**.
  * SQLi `' AND 1=1;` → **blocked**.
* Tạo rule **Count** (non-terminating) để đo traffic trước khi chuyển sang Block — tránh chặn nhầm request hợp lệ.
* Cleanup: xóa CloudFormation stack, Web ACL, Kinesis delivery stream, S3 log bucket.

### Kết quả đạt được

* Hoàn thành **4 nhóm lab bảo mật** (Permission Boundary, IAM Condition, Security Hub, WAF).
* Hiểu mô hình **defense in depth**: IAM (identity) → Security Hub (compliance) → WAF (application layer).
* Thực hành **least privilege** và **permission boundary** — rất sát chương trình An ninh mạng.
* Biết test WAF rule bằng action **Count** trước khi **Block** trong production.
* Cleanup đầy đủ sau lab WAF (stack + Web ACL + logs).

### Kiến thức liên quan An ninh mạng

| Kỹ năng | Ứng dụng |
| --- | --- |
| Privilege escalation prevention | Permission Boundary giới hạn trần quyền dù policy rộng |
| Conditional access | Assume role theo IP + time window |
| Security compliance | Security Hub aggregate findings, CIS benchmark |
| Web application firewall | WAF chặn OWASP Top 10 (XSS, SQLi) ở edge |
| Secure SDLC | Test rule Count → Block, tránh false positive |

### Khó khăn gặp phải

* Permission Boundary — ban đầu nhầm boundary **grant** quyền thay vì **limit**; phải nhớ công thức intersection.
* Assume role bị deny — condition `aws:SourceIp` sai format hoặc IP lab thay đổi (dynamic IP).
* Security Hub enable lâu, findings mất vài phút mới hiện.
* WAF block nhầm request hợp lệ — dùng action **Count** và CloudWatch metric `count-von-count` để đánh giá trước.
* Juice Shop CloudFormation ~5 phút; phải đợi `CREATE_COMPLETE` mới test được.

> **Lưu ý:** Nếu em chưa hoàn thành bước nào, hãy đổi trạng thái trong bảng trên cho đúng thực tế.

### Chuẩn bị cho tuần 8

* Tiếp tục Cloud Journey — mục Reliability hoặc Performance tùy lộ trình FCJ.
* Ôn lại IAM, WAF, Security Hub; chuẩn bị lab tiếp theo trên workshop.
