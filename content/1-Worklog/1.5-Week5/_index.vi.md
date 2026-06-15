---
title: "Worklog Tuần 5"
date: 2026-06-06
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Tổng quan tuần 5 (06/06 – 12/06/2026)

Tuần thứ năm, em chuyển sang **Lab 20 – AWS Transit Gateway** sau khi hoàn thành VPC Peering ở tuần 4. Khác với Peering (chỉ nối 2 VPC), Transit Gateway giúp **kết nối nhiều VPC** qua một hub trung tâm — gần với mô hình mạng doanh nghiệp. Em cũng làm quen **AWS Systems Manager** và **Session Manager** để quản trị EC2 mà không cần mở port SSH.

### Mục tiêu tuần 5

* Hoàn thành **Lab 20 – AWS Transit Gateway** (CloudFormation → attachments → route tables → kiểm tra).
* Thực hành **AWS Systems Manager** và **Session Manager**.
* So sánh **VPC Peering** vs **Transit Gateway** trong bối cảnh mở rộng mạng.

### Công việc đã triển khai

| Bước | Nội dung | Trạng thái | Link |
| --- | --- | --- | --- |
| 02.1 | Khởi tạo CloudFormation stack (3 VPC + Transit Gateway) | ✅ | [Lab 20](https://000020.awsstudygroup.com/) |
| 03 | Tạo VPC attachments, gắn VPC vào Transit Gateway | ✅ | [Playlist](https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i) |
| 04 | Cấu hình Transit Gateway route tables (association + propagation) | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/3-optimize/) |
| 05 | Kiểm tra ping / kết nối cross-VPC qua TGW | ✅ | [Lab 20](https://000020.awsstudygroup.com/) |
| 06 | Systems Manager: IAM role, Run Command trên EC2 | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 07 | Session Manager: SSH không cần mở port 22 | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 08 | Cleanup: xóa attachments, TGW, CloudFormation stacks | ✅ | [Lab 20](https://000020.awsstudygroup.com/) |

### Em đã làm được gì trong tuần

**Bước 02.1 – Khởi tạo môi trường**
* Deploy CloudFormation stack tạo **3 VPC** (mỗi VPC có subnet public/private) và **Transit Gateway**.
* Kiểm tra stack `CREATE_COMPLETE`, ghi nhận Transit Gateway ID và CIDR từng VPC.

**Bước 03 – VPC Attachments**
* Tạo attachment cho từng VPC → Transit Gateway.
* Đợi trạng thái attachment chuyển **available** trước khi cấu hình route.

**Bước 04 – Transit Gateway Route Tables**
* Gắn (associate) attachment vào route table phù hợp.
* Bật propagation để route giữa các VPC được học tự động.
* So sánh với Peering tuần 4: TGW **một hub** thay vì nhiều peering connection riêng lẻ.

**Bước 05 – Kiểm tra kết nối**
* SSH vào EC2 ở VPC A, ping private IP EC2 ở VPC B/C.
* Kết nối **thành công** qua Transit Gateway (traffic đi qua AWS backbone).

**Bước 06 – AWS Systems Manager**
* Gắn IAM role `AmazonSSMManagedInstanceCore` cho EC2.
* Dùng **Run Command** chạy lệnh từ xa (ví dụ `uname -a`, kiểm tra agent).
* Không cần SSH trực tiếp — phù hợp hướng **least privilege**.

**Bước 07 – Session Manager**
* Kết nối EC2 qua **Session Manager** trên console — không mở port **22**.
* Giảm attack surface so với SSH public (liên quan môn An ninh mạng).

**Bước 08 – Cleanup**
* Xóa attachments → Transit Gateway → EC2 → CloudFormation stacks.
* Kiểm tra Billing Dashboard không còn tài nguyên chạy.

### Kết quả đạt được

* Hoàn thành **Lab 20** và làm quen **Systems Manager / Session Manager**.
* Hiểu **Transit Gateway** là hub trung tâm cho multi-VPC; Peering phù hợp kết nối đơn giản 1–1.
* Thực hành quản trị EC2 **không SSH** — giảm rủi ro mở port trên Security Group.
* Cleanup đúng thứ tự, tránh phát sinh chi phí TGW attachment.

### Kiến thức liên quan An ninh mạng

| Kỹ năng | Ứng dụng |
| --- | --- |
| Hub-and-spoke networking | TGW gom traffic, dễ audit và kiểm soát |
| Attack surface reduction | Session Manager thay SSH public |
| IAM least privilege | Role SSM chỉ cấp quyền cần thiết cho instance |
| Defense in depth | Kết hợp SG + private subnet + SSM thay vì expose port |

### Khó khăn gặp phải

* Attachment ở trạng thái **pending** lâu — phải đợi đủ trước khi test ping.
* Ping thất bại ban đầu — thiếu route propagation hoặc SG chưa cho ICMP.
* Session Manager không kết nối được — EC2 chưa có IAM role `AmazonSSMManagedInstanceCore` hoặc agent chưa online.

> **Lưu ý:** Nếu em chưa hoàn thành bước nào, hãy đổi trạng thái trong bảng trên cho đúng thực tế.

### Chuẩn bị cho tuần 6

* Tiếp tục **Cloud Journey – Optimize** (các lab networking nâng cao).
* Ôn lại VPC, TGW, SSM trước khi sang chủ đề mới.
