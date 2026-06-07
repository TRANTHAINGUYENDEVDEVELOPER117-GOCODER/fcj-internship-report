---
title: "Worklog Tuần 3"
date: 2026-05-23
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

### Tổng quan tuần 3 (23/05 – 29/05/2026)

Tuần thứ ba, em chuyển sang **Module 02 – Optimizing the System** và bắt đầu **Lab 19 – Setting up VPC Peering**. Trọng tâm tuần này là học **Infrastructure as Code (IaC)** với **AWS CloudFormation** để khởi tạo 2 VPC (My VPC và HG VPC) phục vụ bài lab peering.

### Mục tiêu tuần 3

* Nắm tổng quan track Optimizing trên [Cloud Journey](https://cloudjourney.awsstudygroup.com/3-optimize/).
* Hiểu kiến trúc VPC Peering, NACL, Cross-Peer DNS.
* Hoàn thành Lab 19 bước **02.0** (lý thuyết) và **02.1** (khởi tạo hạ tầng bằng CloudFormation).

### Công việc đã triển khai

| Thứ | Công việc | Trạng thái |
| --- | --- | --- |
| 23/05 | Nghiên cứu Module 02; xem video [FCJ Bootcamp playlist](https://www.youtube.com/playlist?list=PLahN4TLWtox2a3vElknwzU_urND8hLn1i) | ✅ |
| 24/05 | **Lab 19 – 02.0:** Đọc tổng quan VPC Peering, NACL, Cross-Peer DNS | ✅ |
| 25–26/05 | **Lab 19 – 02.1:** Tải `VPCTemplate.yaml`, tạo stack **My VPC** | ✅ |
| 27/05 | **Lab 19 – 02.1:** Tạo stack **HG VPC**, nhập parameters CIDR | ✅ |
| 28–29/05 | Xác nhận IAM capabilities; kiểm tra stack `CREATE_COMPLETE` và Outputs | ✅ |

### Em đã làm được gì trong tuần

**Lab 19 – 02.0 (Lý thuyết)**
* Hiểu VPC mặc định bị cô lập, cần VPC Peering để 2 VPC giao tiếp qua private IP.
* Nắm khái niệm NACL (stateless, tầng subnet) và Cross-Peer DNS.

**Lab 19 – 02.1 (CloudFormation)**
* Tải template `VPCTemplate.yaml` từ [tài liệu lab](https://000019.awsstudygroup.com/2-prerequiste/2.1-launchcloudformation/).
* Tạo stack **My VPC** (CIDR `172.31.0.0/16`) và **HG VPC** (CIDR `10.10.0.0/16`) qua CloudFormation Console.
* Tick acknowledge IAM capabilities, chờ mỗi stack ~5–10 phút để đạt `CREATE_COMPLETE`.
* Kiểm tra tab Resources và Outputs: VPC ID, Subnet, EC2 Public IP.

### Kiến thức mới học được

| Khái niệm | Ý nghĩa |
| --- | --- |
| CloudFormation Template | File YAML mô tả tài nguyên AWS |
| Stack | Nhóm tài nguyên được quản lý như một đơn vị |
| Parameters | Giá trị đầu vào khi deploy (CIDR, tên...) |
| Outputs | Kết quả trả về sau khi tạo stack (ID, IP...) |

### Kết quả đạt được

* Hoàn thành Lab 19 bước **02.0** và **02.1**.
* Triển khai thành công **2 CloudFormation Stack** cho 2 VPC.
* Hiểu cách dùng IaC thay vì tạo tài nguyên thủ công từng bước.
* Chuẩn bị sẵn hạ tầng cho các bước peering (03–07) ở tuần 4.

### Khó khăn gặp phải

* Stack bị `CREATE_FAILED` lần đầu vì chưa tick đủ IAM capabilities.
* Mỗi stack mất khá lâu — cần theo dõi tab Events trong CloudFormation.

### Chuẩn bị cho tuần 4

* Tiếp tục Lab 19: bước **03** (NACL) đến **07** (Cleanup).
