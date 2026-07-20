# TRANTHAINGUYEN-fcj-internship-report

Báo cáo thực tập FCJ — Trần Thái Nguyên

**Sinh viên:** Trần Thái Nguyên · HUTECH · An ninh mạng · 22DTHB1  
**Chương trình:** First Cloud Journey Workforce Bootcamp — Amazon Web Services Viet Nam  
**Thời gian:** 09/05/2026 – 10/08/2026

## Demo

Xem báo cáo online tại:

```
https://tranthainguyendevdeveloper117-gocoder.github.io/Tran-Thai-Nguyen-fcj-internship-report/vi/
```

## Tổng quan

Đây là website báo cáo thực tập FCJ của Trần Thái Nguyên trong chương trình First Cloud Journey Workforce Bootcamp 2026. Project gồm đầy đủ các phần: Worklog, Proposal, Blogs, Events, Workshop, Self-Assessment và Sharing/Feedback.

## Điểm nổi bật

- Trình bày song ngữ Anh/Việt bằng Hugo.
- Giao diện gọn, tập trung vào thông tin thực tập.
- Có ảnh đại diện, thông tin sinh viên, trường, ngành, vị trí và thời gian thực tập.
- Có Worklog 12 tuần.
- Có Proposal dự án AWS CloudSOC.
- Có chuỗi Blogs đã đăng về CloudSOC và incident response.
- Có Events đã tham gia.
- Có Workshop triển khai, kiểm thử và cleanup hệ thống CloudSOC.
- Có Self-Assessment và Sharing/Feedback.

## What I Learned

Through this internship report, I practiced building and publishing a bilingual Hugo website with GitHub Pages, documenting an AWS CloudSOC project, and organizing project materials into proposal, blog, and workshop sections.

## Cấu trúc

| Mục | Nội dung |
|-----|----------|
| Internship Report | Thông tin thực tập chính |
| Worklog | Nhật ký thực tập 12 tuần |
| Proposal | Bản đề xuất dự án AWS CloudSOC |
| Blogs | Chuỗi bài viết đã đăng |
| Events | Sự kiện đã tham gia |
| Workshop | Hướng dẫn triển khai, kiểm thử và cleanup CloudSOC |
| Self-Assessment | Tự đánh giá quá trình thực tập |
| Sharing and Feedback | Chia sẻ và phản hồi sau chương trình |

## Chạy local

Mở PowerShell, vào đúng thư mục chứa source Hugo:

```powershell
cd "C:\Users\Lenovo\Downloads\TRANTHAINGUYEN-fcj-internship-report"
hugo server -D -p 3655 --disableFastRender
```

Sau đó mở trình duyệt:

```text
http://localhost:3655/vi/
```

Hoặc chạy nhanh bằng file có sẵn:

```powershell
.\serve.bat
```

Nếu Hugo báo port đang được sử dụng, dừng tiến trình Hugo cũ rồi chạy lại:

```powershell
Get-Process hugo -ErrorAction SilentlyContinue | Stop-Process -Force
hugo server -D -p 3655 --disableFastRender
```

Nếu muốn build bản tĩnh để kiểm tra trước khi deploy:

```powershell
hugo
```

## Deploy

Push lên nhánh `main` → GitHub Actions tự build và deploy lên `gh-pages`.

Chi tiết: xem [HUONG-DAN-DEPLOY.md](HUONG-DAN-DEPLOY.md)
