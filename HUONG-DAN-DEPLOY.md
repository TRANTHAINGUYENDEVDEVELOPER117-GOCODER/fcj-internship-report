# Hướng dẫn đẩy báo cáo lên GitHub (FCJ)

Theo yêu cầu chương trình **First Cloud Journey**, báo cáo phải được publish dạng **website Hugo** trên **GitHub Pages**.

## Yêu cầu FCJ

1. Tạo repository **public** trên GitHub
2. Push code lên nhánh **`main`**
3. Bật **GitHub Pages** → nguồn: **GitHub Actions**
4. Gửi **link website** cho mentor FCJ (AWS Study Group)
5. Nộp **PDF** riêng cho trường HUTECH (nếu được yêu cầu)

Link báo cáo sau deploy:

```
https://tranthainguyendevdeveloper117-gocoder.github.io/fcj-internship-report/vi/
```

Repository GitHub:

```
https://github.com/TRANTHAINGUYENDEVDEVELOPER117-GOCODER/fcj-internship-report.git
```

---

## Bước 1 — Tạo repo trên GitHub

1. Đăng nhập https://github.com
2. Nhấn **New repository**
3. Đặt tên repository: `fcj-internship-report`
4. Chọn **Public**
5. **Không** tick "Add README" (đã có sẵn trong project)
6. Nhấn **Create repository**

---

## Bước 2 — Push code từ máy (PowerShell)

```powershell
cd "c:\Users\Lenovo\Downloads\TRANTHAINGUYEN-fcj-internship-report"

git init
git add .
git commit -m "Bao cao thuc tap FCJ - Tran Thai Nguyen - HUTECH"

git branch -M main
git remote add origin https://github.com/TRANTHAINGUYENDEVDEVELOPER117-GOCODER/fcj-internship-report.git
git push -u origin main
```

Lần đầu push, GitHub sẽ hỏi đăng nhập — dùng **Personal Access Token** (không dùng mật khẩu thường).

### Tạo Personal Access Token

1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token** → quyền `repo`
3. Copy token → dùng làm mật khẩu khi `git push`

---

## Bước 3 — Bật GitHub Pages

1. Vào repo trên GitHub → **Settings** → **Pages**
2. **Source:** chọn **GitHub Actions**
3. Đợi workflow **Deploy Hugo site to GitHub Pages** chạy xong (tab **Actions**, ~2–3 phút)
4. Khi thành công, trang **Pages** hiện link website

---

## Bước 4 — Kiểm tra & nộp

- Link tiếng Việt: `https://tranthainguyendevdeveloper117-gocoder.github.io/fcj-internship-report/vi/`
- Gửi link cho **mentor FCJ** / nhóm AWS Study Group
- Nộp PDF cho **HUTECH** (xuất từ trình duyệt: Ctrl+P → Save as PDF)

---

## Cập nhật báo cáo sau này

Mỗi khi sửa nội dung:

```powershell
cd "c:\Users\Lenovo\Downloads\TRANTHAINGUYEN-fcj-internship-report"
git add .
git commit -m "Cap nhat worklog tuan X"
git push
```

GitHub Actions tự build lại website trong vài phút.

---

## Lỗi thường gặp

| Lỗi | Cách xử lý |
|-----|------------|
| `git push` bị từ chối | Dùng Personal Access Token thay mật khẩu |
| Actions build fail | Vào tab Actions → xem log; thường do thiếu theme |
| Trang trắng / không CSS | Đợi deploy xong; mở đúng link `/vi/` |
| 404 | Kiểm tra Settings → Pages đã chọn **GitHub Actions** |
