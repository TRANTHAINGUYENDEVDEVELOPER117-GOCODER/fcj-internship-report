---
title: "Export và review sơ đồ"
date: 2026-07-17
weight: 5
chapter: false
pre: " <b> 5.3.5. </b> "
---

# Export và review sơ đồ

### 1. Kiểm tra trước khi export

Trước khi xuất file, kiểm tra:

- Có title: **AWS CloudSOC Architecture – Lab / Proof of Concept**.
- Có tên nhóm: **Trần Thái Nguyên & Dương Bá Đạt**.
- Có AWS Cloud, Region, VPC, Availability Zone, Public Subnet.
- Có đủ 4 vùng màu: Dashboard, Logging, Detection/Response, Governance.
- Có Threat Actor và SOC Analyst.
- Có `SG-Workload` và `SG-Isolation`.
- Có luồng approval qua SNS, Amazon Q Developer, Slack/Email/SMS.
- Có luồng forensic trước isolation.
- Có legend giải thích màu vùng, màu mũi tên và đường nét đứt.

### 2. Export từ draw.io

Trong draw.io:

1. Chọn **File → Export as → PNG**.
2. Chọn `Zoom: 2x` hoặc `3x`.
3. Chọn **Transparent Background** nếu chèn vào slide tối giản.
4. Chọn nền trắng nếu chèn vào Word/PDF.
5. Bấm **Export**.

Nên export thêm:

- `.drawio`: file gốc để chỉnh sửa.
- `.svg`: dùng cho website, không bị vỡ khi zoom.
- `.pdf`: dùng cho báo cáo/slide.

### 3. Tên file đề xuất

```text
aws-cloudsoc-architecture-team-tran-thai-nguyen-duong-ba-dat.drawio
aws-cloudsoc-architecture-team-tran-thai-nguyen-duong-ba-dat.png
aws-cloudsoc-architecture-team-tran-thai-nguyen-duong-ba-dat.svg
```

### 4. Tiêu chí sơ đồ đạt yêu cầu

| Tiêu chí | Đạt |
| --- | --- |
| Nhìn vào biết đây là SOC trên AWS | ☐ |
| Có thể kể được flow Detect → Investigate → Decide → Contain | ☐ |
| Người không chuyên vẫn hiểu EC2 bị cô lập như thế nào | ☐ |
| Không thiếu approval gate | ☐ |
| Không thiếu forensic trước isolation | ☐ |
| Không nhầm data flow với IAM role/policy | ☐ |
| Có ghi rõ Lab/PoC, không giả định production hoàn chỉnh | ☐ |

### 5. Lỗi thường gặp

- Vẽ quá nhiều mũi tên không có nhãn.
- Đặt Security Hub thay cho GuardDuty ở vai trò phát hiện chính.
- Quên Amazon Q Developer/Slack trong luồng notification.
- Vẽ Lambda cô lập EC2 trước Systems Manager forensic.
- Không thể hiện `SG-Isolation`.
- Không có legend.
- Không ghi rõ đây là Lab/PoC.

