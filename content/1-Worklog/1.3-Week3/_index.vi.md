---
title: "Nhật ký công việc Tuần 3"
date: 2026-05-18
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

### Thời gian thực hiện

* **Tuần 3:** Từ ngày **2026-05-18** đến **2026-05-24**.

### Mục tiêu Tuần 3

* Hiểu các khái niệm cơ bản về Amazon VPC.
* Tìm hiểu CIDR Block, Subnet, Route Table, Internet Gateway và NAT Gateway.
* Hiểu sự khác nhau giữa Public Subnet và Private Subnet.
* Thực hành tạo một VPC tùy chỉnh.
* Triển khai EC2 Instance trong Public Subnet và Private Subnet.
* Cấu hình Security Group và định tuyến mạng.
* Kiểm tra khả năng kết nối giữa các tài nguyên AWS.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại kiến thức Amazon EC2 của Tuần 2 <br> - Tìm hiểu các khái niệm cơ bản về Amazon VPC <br> - Hiểu VPC CIDR Block, dải địa chỉ IP và khả năng cô lập mạng | 2026-05-18 | 2026-05-18 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Ba | - Tìm hiểu Public Subnet và Private Subnet <br> - Hiểu Subnet CIDR Block và Availability Zone <br> - Tìm hiểu cách các tài nguyên giao tiếp với nhau bên trong VPC | 2026-05-19 | 2026-05-19 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Tư | - Tạo một Amazon VPC tùy chỉnh <br> - Tạo một Public Subnet và một Private Subnet <br> - Lựa chọn các CIDR Block phù hợp <br> - Kiểm tra cấu hình subnet và vị trí triển khai tài nguyên | 2026-05-20 | 2026-05-20 | <https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc.html> |
| Thứ Năm | - Tạo và gắn Internet Gateway vào VPC <br> - Tạo các Route Table <br> - Cấu hình Default Route cho Public Subnet <br> - Liên kết Route Table với đúng subnet | 2026-05-21 | 2026-05-21 | <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html> |
| Thứ Sáu | - Tìm hiểu NAT Gateway và khả năng truy cập Internet của Private Subnet <br> - Tạo NAT Gateway khi cần thiết <br> - Cấu hình Private Route Table <br> - Tìm hiểu chi phí sử dụng NAT Gateway | 2026-05-22 | 2026-05-22 | <https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html> |
| Thứ Bảy | - Khởi tạo một EC2 Instance trong Public Subnet <br> - Khởi tạo một EC2 Instance trong Private Subnet <br> - Cấu hình Security Group <br> - Kết nối đến Public EC2 Instance bằng SSH <br> - Kiểm tra kết nối nội bộ giữa hai EC2 Instance | 2026-05-23 | 2026-05-23 | <https://cloudjourney.awsstudygroup.com/> |
| Chủ Nhật | - Tìm hiểu Network ACL và so sánh với Security Group <br> - Kiểm tra Route, địa chỉ IP và khả năng kết nối của các Instance <br> - Khắc phục một số lỗi cấu hình VPC thường gặp <br> - Xóa các tài nguyên không cần thiết và hoàn thành nhật ký Tuần 3 | 2026-05-24 | 2026-05-24 | <https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html> |

### Kết quả đạt được trong Tuần 3

* Hiểu được vai trò của Amazon VPC trong việc tạo một môi trường mạng ảo được cô lập trên AWS.

* Nắm được các thành phần chính của Amazon VPC, bao gồm:

  * VPC CIDR Block
  * Public Subnet
  * Private Subnet
  * Route Table
  * Internet Gateway
  * NAT Gateway
  * Security Group
  * Network ACL

* Hiểu cách CIDR Block được sử dụng để xác định dải địa chỉ IP.

* Hiểu sự khác nhau giữa Public Subnet và Private Subnet.

* Tạo thành công một Amazon VPC tùy chỉnh.

* Tạo và cấu hình Public Subnet và Private Subnet.

* Gắn Internet Gateway vào VPC.

* Tạo Route Table và liên kết với các subnet phù hợp.

* Cấu hình khả năng truy cập Internet cho Public Subnet.

* Hiểu cách NAT Gateway cung cấp kết nối Internet chiều ra cho các tài nguyên trong Private Subnet.

* Khởi tạo EC2 Instance trong Public Subnet và Private Subnet.

* Kết nối thành công đến Public EC2 Instance bằng SSH.

* Kiểm tra kết nối nội bộ giữa các EC2 Instance.

* Hiểu sự khác nhau giữa Security Group và Network ACL.

* Thực hành xử lý các lỗi mạng thường gặp liên quan đến Route, địa chỉ IP, Security Group và cấu hình Subnet.

* Hoàn thành Tuần 3 với kiến thức nền tảng về Amazon VPC, thiết kế Subnet, định tuyến, kết nối Internet và bảo mật mạng.