---
title: "Nhật ký công việc Tuần 2"
date: 2026-05-11
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

### Thời gian thực hiện

* **Tuần 2:** Từ ngày **2026-05-11** đến **2026-05-17**.

### Mục tiêu Tuần 2

* Hiểu vai trò của Amazon EC2 trong hệ thống AWS.
* Tìm hiểu Amazon Machine Image, Instance Type, Key Pair và Security Group.
* Thực hành triển khai máy chủ Linux và Windows trên Amazon EC2.
* Kết nối đến EC2 bằng SSH và Remote Desktop.
* Tìm hiểu Amazon EBS và Elastic IP.
* Làm quen với AWS Systems Manager Session Manager.
* Thực hành quản lý vòng đời EC2 và kiểm soát chi phí.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại kiến thức Tuần 1 <br> - Tìm hiểu tổng quan về Amazon EC2 <br> - Hiểu vai trò của máy chủ ảo trong môi trường AWS <br> - Tìm hiểu Instance Type, AMI và trạng thái của EC2 Instance | 2026-05-11 | 2026-05-11 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Ba | - Tìm hiểu Key Pair và Security Group <br> - Hiểu quy tắc Inbound và Outbound <br> - Tìm hiểu Public IP, Private IP và Elastic IP <br> - Chuẩn bị cấu hình để triển khai EC2 Linux | 2026-05-12 | 2026-05-12 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Tư | - Tạo Amazon EC2 Linux Instance <br> - Chọn AMI và Instance Type phù hợp <br> - Tạo Key Pair <br> - Cấu hình Security Group cho SSH <br> - Kiểm tra trạng thái hoạt động của Instance | 2026-05-13 | 2026-05-13 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Năm | - Kết nối đến EC2 Linux bằng SSH <br> - Thực hành một số lệnh Linux cơ bản <br> - Kiểm tra Public IP và Private IP <br> - Tìm hiểu và xử lý một số lỗi kết nối SSH thường gặp | 2026-05-14 | 2026-05-14 | <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-ssh.html> |
| Thứ Sáu | - Tạo Amazon EC2 Windows Instance <br> - Lấy mật khẩu Administrator <br> - Kết nối đến máy chủ Windows bằng Remote Desktop <br> - Kiểm tra trạng thái và thông tin hệ thống | 2026-05-15 | 2026-05-15 | <https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/connecting_to_windows_instance.html> |
| Thứ Bảy | - Tìm hiểu Amazon EBS và Root Volume <br> - Tạo và gắn thêm EBS Volume vào EC2 <br> - Tìm hiểu Elastic IP và cách liên kết với EC2 <br> - Kiểm tra Snapshot và khả năng sao lưu dữ liệu | 2026-05-16 | 2026-05-16 | <https://cloudjourney.awsstudygroup.com/> |
| Chủ Nhật | - Tìm hiểu AWS Systems Manager Session Manager <br> - Hiểu vai trò của IAM Role và SSM Agent <br> - Thực hành kết nối EC2 mà không cần mở cổng SSH nếu điều kiện cho phép <br> - Dừng hoặc xóa các tài nguyên không cần thiết <br> - Hoàn thành nhật ký Tuần 2 | 2026-05-17 | 2026-05-17 | <https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html> |

### Kết quả đạt được trong Tuần 2

* Hiểu được vai trò của Amazon EC2 trong việc cung cấp máy chủ ảo trên AWS.

* Nắm được các thành phần cơ bản của EC2, bao gồm:

  * Amazon Machine Image
  * Instance Type
  * Key Pair
  * Security Group
  * Public IP
  * Private IP
  * Elastic IP
  * Amazon EBS

* Tạo và khởi chạy thành công EC2 Linux Instance.

* Cấu hình Security Group để cho phép kết nối SSH an toàn.

* Kết nối thành công đến máy chủ Linux bằng SSH.

* Thực hành một số lệnh Linux cơ bản trên EC2.

* Tạo và kết nối đến EC2 Windows bằng Remote Desktop.

* Hiểu sự khác nhau giữa Public IP, Private IP và Elastic IP.

* Tìm hiểu vai trò của Amazon EBS trong việc lưu trữ dữ liệu cho EC2.

* Thực hành tạo và gắn thêm EBS Volume vào EC2 Instance.

* Hiểu mục đích của EBS Snapshot trong việc sao lưu và khôi phục dữ liệu.

* Làm quen với AWS Systems Manager Session Manager và phương thức truy cập EC2 không phụ thuộc hoàn toàn vào SSH.

* Thực hành dừng, khởi động và xóa EC2 Instance sau khi hoàn thành bài lab.

* Hoàn thành Tuần 2 với kiến thức cơ bản về EC2, SSH, Remote Desktop, EBS, Elastic IP và Systems Manager.