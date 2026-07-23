---
title: "Nhật ký công việc Tuần 5"
date: 2026-06-01
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Thời gian thực hiện

* **Tuần 5:** Từ ngày **2026-06-01** đến **2026-06-07**.

### Mục tiêu Tuần 5

* Hiểu các khái niệm cơ bản về giám sát và ghi log trên AWS.
* Tìm hiểu cách Amazon CloudWatch giám sát tài nguyên AWS.
* Hiểu CloudWatch Metrics, Logs, Alarms và Dashboards.
* Thực hành giám sát Amazon EC2 Instance.
* Tìm hiểu cách VPC Flow Logs ghi nhận thông tin lưu lượng mạng.
* Tạo cảnh báo và bảng điều khiển để theo dõi tài nguyên.
* Kiểm tra mức sử dụng tài nguyên và chi phí AWS.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại kiến thức về mạng và VPN của Tuần 4 <br> - Tìm hiểu các khái niệm cơ bản về giám sát và ghi log <br> - Hiểu vai trò của Amazon CloudWatch trong quá trình vận hành hệ thống AWS | 2026-06-01 | 2026-06-01 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Ba | - Tìm hiểu CloudWatch Metrics <br> - Xem các chỉ số EC2 như CPU Utilization, Network In, Network Out và Status Checks <br> - Hiểu khái niệm Namespace, Dimension, Period và Statistic | 2026-06-02 | 2026-06-02 | <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html> |
| Thứ Tư | - Giám sát EC2 Instance bằng Amazon CloudWatch <br> - Xem các chỉ số hiệu suất của tài nguyên <br> - So sánh giá trị chỉ số trong các khoảng thời gian khác nhau <br> - Xác định các dấu hiệu sử dụng tài nguyên bất thường | 2026-06-03 | 2026-06-03 | <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html> |
| Thứ Năm | - Tạo CloudWatch Alarm cho một chỉ số EC2 <br> - Cấu hình ngưỡng, khoảng thời gian đánh giá và điều kiện cảnh báo <br> - Tìm hiểu các trạng thái cảnh báo: OK, ALARM và INSUFFICIENT_DATA <br> - Tìm hiểu phương thức gửi thông báo bằng Amazon SNS | 2026-06-04 | 2026-06-04 | <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html> |
| Thứ Sáu | - Tìm hiểu VPC Flow Logs <br> - Tạo Flow Log cho VPC, Subnet hoặc Network Interface <br> - Gửi dữ liệu Flow Log đến CloudWatch Logs <br> - Xem các bản ghi lưu lượng mạng ACCEPT và REJECT | 2026-06-05 | 2026-06-05 | <https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html> |
| Thứ Bảy | - Tạo CloudWatch Log Group và xem các Log Event <br> - Tạo Metric Filter cho lưu lượng bị từ chối khi cần thiết <br> - Xây dựng một CloudWatch Dashboard cơ bản <br> - Thêm chỉ số EC2 và thông tin cảnh báo vào Dashboard | 2026-06-06 | 2026-06-06 | <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html> |
| Chủ Nhật | - Kiểm tra AWS Billing, mức sử dụng Free Tier và các tài nguyên đang hoạt động <br> - Kiểm tra chi phí có thể phát sinh từ CloudWatch Logs, NAT Gateway, VPN và EC2 <br> - Xóa các tài nguyên thử nghiệm không cần thiết <br> - Hoàn thành nhật ký Tuần 5 | 2026-06-07 | 2026-06-07 | <https://aws.amazon.com/cloudwatch/pricing/> |

### Kết quả đạt được trong Tuần 5

* Hiểu được tầm quan trọng của việc giám sát và ghi log trong môi trường AWS.

* Nắm được các thành phần chính của Amazon CloudWatch, bao gồm:

  * Metrics
  * Logs
  * Alarms
  * Dashboards
  * Log Groups
  * Metric Filters

* Xem và phân tích các chỉ số cơ bản của Amazon EC2, bao gồm:

  * CPU Utilization
  * Network In
  * Network Out
  * Status Checks

* Hiểu cách CloudWatch Metrics được tổ chức theo Namespace, Dimension, Period và Statistic.

* Tạo CloudWatch Alarm để giám sát tài nguyên EC2.

* Hiểu các trạng thái chính của CloudWatch Alarm:

  * OK
  * ALARM
  * INSUFFICIENT_DATA

* Tìm hiểu cách Amazon SNS được sử dụng để gửi thông báo cảnh báo.

* Hiểu mục đích của VPC Flow Logs trong việc ghi nhận thông tin lưu lượng mạng.

* Tạo VPC Flow Log và gửi dữ liệu đến CloudWatch Logs.

* Xem các bản ghi ACCEPT và REJECT để xác định lưu lượng mạng được cho phép hoặc bị từ chối.

* Hiểu cách Metric Filter được sử dụng để phát hiện các mẫu dữ liệu cụ thể trong log.

* Tạo một CloudWatch Dashboard cơ bản để hiển thị các chỉ số EC2 và thông tin cảnh báo quan trọng.

* Kiểm tra AWS Billing và mức sử dụng Free Tier để xác định các tài nguyên có thể phát sinh chi phí.

* Xóa các tài nguyên thử nghiệm không cần thiết sau khi hoàn thành bài thực hành.

* Hoàn thành Tuần 5 với kiến thức nền tảng về Amazon CloudWatch, VPC Flow Logs, cảnh báo, Dashboard, ghi log và giám sát chi phí AWS.
