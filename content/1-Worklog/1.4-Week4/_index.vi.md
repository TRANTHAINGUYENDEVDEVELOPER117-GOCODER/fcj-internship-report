---
title: "Worklog Tuần 4"
date: 2026-05-30
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Tổng quan tuần 4 (30/05 – 05/06/2026)

Tuần thứ tư, em tiếp tục **Lab 19 – VPC Peering** từ bước **03 đến 07**, sau khi đã khởi tạo 2 VPC bằng CloudFormation ở tuần 3. Tuần này em tập trung vào **cấu hình kết nối mạng**: NACL, Peering Connection, Route Tables, Cross-Peer DNS và cleanup — các nội dung gắn với ngành **An ninh mạng** (phân vùng mạng, kiểm soát traffic).

### Mục tiêu tuần 4

* Cấu hình Network ACL và VPC Peering giữa My VPC và HG VPC.
* Thiết lập Route Tables cho traffic cross-VPC.
* Bật Cross-Peer DNS và kiểm tra kết nối.
* Cleanup tài nguyên sau lab.

### Công việc đã triển khai

| Bước | Nội dung | Trạng thái | Link |
| --- | --- | --- | --- |
| 03 | Update Network ACL – Rule 100 Source → `172.31.0.0/16` | ✅ | [Hướng dẫn](https://000019.awsstudygroup.com/3-updatenetworkacl/) |
| 04 | Tạo VPC Peering Connection, Accept → Active | ✅ | [Hướng dẫn](https://000019.awsstudygroup.com/4-vpcpeering/) |
| 05 | Cấu hình Route Tables 2 chiều (My ↔ HG VPC) | ✅ | [Hướng dẫn](https://000019.awsstudygroup.com/5-routetable/) |
| 06 | Bật Cross-Peer DNS + DNS hostnames | ✅ | [Hướng dẫn](https://000019.awsstudygroup.com/vi/6-crosspeerdns/) |
| 07 | Kiểm tra ping private IP & public DNS | ✅ | [Lab 19](https://000019.awsstudygroup.com/) |
| 07 | Cleanup: xóa peering, EC2, CloudFormation stacks | ✅ | [Cleanup](https://000019.awsstudygroup.com/7-cleanup/) |

### Em đã làm được gì trong tuần

**Bước 03 – Network ACL**
* Sửa inbound Rule 100 của NACL HG VPC: chỉ cho phép traffic từ `172.31.0.0/16`.
* Kiểm tra: ping public IP EC2 HG VPC từ Internet **thất bại**.

**Bước 04 – VPC Peering**
* Tạo peering My VPC (`172.31.0.0/16`) ↔ HG VPC (`10.10.0.0/16`).
* Accept request → trạng thái **Active**.

**Bước 05 – Route Tables**
* My VPC: thêm route `10.10.0.0/16` → Peering connection.
* HG VPC: thêm route `172.31.0.0/16` → Peering connection.
* Ping **private IP** giữa 2 EC2 → **thành công**.

**Bước 06 – Cross-Peer DNS**
* Bật Requester + Accepter DNS resolution trên peering connection.
* Ping **public DNS** EC2 HG VPC từ EC2 My VPC → resolve về **private IP**, kết nối thành công.

**Bước 07 – Cleanup**
* Xóa peering → terminate EC2 → xóa CloudFormation stacks.
* Kiểm tra Billing Dashboard không còn tài nguyên chạy.

### Kết quả đạt được

* Hoàn thành **toàn bộ Lab 19** (bước 02.0 → 07).
* Phân biệt được **Security Group** (stateful) và **Network ACL** (stateless).
* Cấu hình được VPC Peering — traffic đi qua AWS backbone, không qua Internet.
* Thực hành cleanup đúng thứ tự, tránh phát sinh chi phí.

### Kiến thức liên quan An ninh mạng

| Kỹ năng | Ứng dụng |
| --- | --- |
| Network segmentation | Phân vùng VPC, kiểm soát bằng NACL/SG |
| Defense in depth | Kết hợp NACL (subnet) + SG (instance) |
| Private connectivity | Peering thay vì expose qua Internet |
| DNS security | Cross-Peer DNS tránh leak ra public IP |

### Khó khăn gặp phải

* Ping private IP thất bại ban đầu — thiếu route ở một chiều (chỉ cấu hình 1 VPC).
* Ping public DNS thất bại — chưa bật Cross-Peer DNS, DNS trả về public IP bị NACL chặn.

> **Lưu ý:** Nếu em chưa hoàn thành bước nào, hãy đổi trạng thái trong bảng trên cho đúng thực tế.

### Chuẩn bị cho tuần 5

* Bắt đầu **Lab 20 – AWS Transit Gateway** và Systems Manager.
