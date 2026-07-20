---
title: "Dựng layout tổng thể"
date: 2026-07-17
weight: 2
chapter: false
pre: " <b> 5.3.2. </b> "
---

# Dựng layout tổng thể

### 1. Nguyên tắc bố cục

Sơ đồ CloudSOC nên đọc theo hướng **trái → phải** và **trên → dưới**:

- Bên trái: Threat Actor, Internet, VPC, EC2 workload.
- Góc trên bên phải: SOC Dashboard & Access.
- Giữa bên phải: Logging & Evidence Storage.
- Dưới bên phải: Threat Detection & Response.
- Dưới bên trái: Security, Compliance & Governance.
- Ngoài cùng bên phải: SOC Analyst, Slack Channel, Email/SMS.

### 2. Tạo boundary chính

Vẽ các khung theo thứ tự:

1. **AWS Cloud**: khung ngoài cùng, màu xám nhạt.
2. **AWS Region: ap-southeast-1**: khung nét đứt màu teal.
3. **VPC**: đặt bên trái, màu viền tím.
4. **Availability Zone**: nằm trong VPC.
5. **Public Subnet**: nằm trong Availability Zone.

### 3. Đặt workload lab

Trong Public Subnet, thêm:

- Amazon EC2.
- `SG-Workload`.
- `SG-Isolation`.
- Internet Gateway.

Luồng traffic:

```text
Threat Actor → Internet → Internet Gateway → Amazon EC2
```

Nhãn mũi tên:

```text
Internet Traffic / Port Scan / SSH Brute-force
```

### 4. Quy tắc màu nền

| Vùng | Màu |
| --- | --- |
| AWS Cloud | `#FAFAFA` |
| Region | Không fill, nét đứt teal |
| VPC | Không fill, viền tím |
| Availability Zone | `#F4F7FB` |
| Public Subnet | `#FEF9C3` |
| SG-Isolation | Viền đỏ, nền trắng/xám |

### 5. Kiểm tra trước khi sang bước tiếp theo

- Boundary không bị chồng lên chữ.
- EC2 nằm rõ trong Public Subnet.
- Threat Actor nằm ngoài AWS Cloud.
- Internet Gateway nằm ở biên VPC.
- `SG-Isolation` nằm gần EC2 để dễ hiểu containment.

