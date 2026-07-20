# TRANTHAINGUYEN-fcj-internship-report

Báo cáo thực tập FCJ — Trần Thái Nguyên

**Sinh viên:** Trần Thái Nguyên · HUTECH · An ninh mạng · 22DTHB1  
**Chương trình:** First Cloud Journey Workforce Bootcamp — Amazon Web Services Viet Nam  
**Thời gian:** 09/05/2026 – 10/08/2026

## Xem báo cáo online

Sau khi deploy GitHub Pages, link báo cáo:

```
https://<GITHUB_USERNAME>.github.io/TRANTHAINGUYEN-fcj-internship-report/vi/
```

## Cấu trúc

| Mục | Nội dung |
|-----|----------|
| 1. Worklog | Nhật ký công việc 12 tuần |
| 2. Proposal | Bản đề xuất dự án |
| 3. Blogs | Bài viết AWS Study Group |
| 4. Events | Sự kiện đã tham gia |
| 5. Workshop | Lab AWS workshop |
| 6. Self-evaluation | Tự đánh giá |
| 7. Feedback | Chia sẻ & feedback |

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
