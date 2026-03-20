# 🚀 Đề xuất cải tiến dotfiles

Danh sách cải tiến được chia thành **đã thực hiện** và **đề xuất tiếp theo**.

---

## ✅ Đã thực hiện

- [x] Tách `.zshrc` thành các module theo chức năng
- [x] `install.sh` tạo symlink, tự backup file cũ
- [x] `install.sh --uninstall` để gỡ cài sạch
- [x] Guard clause trong `plugins.zsh` — không crash nếu tool chưa cài
- [x] `local.zsh` — override riêng cho từng máy, không commit
- [x] `.gitignore` để tránh commit file nhạy cảm
- [x] Tách core env sang `~/.zshenv` để non-interactive shell có đủ `PATH`, `BUN_INSTALL`, `NVM_DIR`
- [x] `install.sh` quản lý thêm symlink `~/.zshenv` khi install/uninstall/restore backup
- [x] `make lint` kiểm tra thêm `zsh/.zshenv`
- [x] Thêm smoke test `test/zsh_test.sh` + `make test`
- [x] Hỗ trợ chạy test đơn: `make test TEST="alias <name>"`
- [x] Quản lý `starship/starship.toml` trong repo và symlink sang `~/.config/starship.toml`

---

## 🔜 Đề xuất tiếp theo

### 1. Lazy loading NVM

Đã áp dụng trong `zsh/config/env.zsh`.

---

### 2. Đo tốc độ startup

**Mục đích:** Biết module nào làm chậm shell.

```bash
# Thêm vào Makefile
make bench
# → chạy: for i in $(seq 1 5); do time zsh -i -c exit; done
```

---

### 3. `Makefile` mở rộng

Đã có: `lint`, `test`, `update`, `doctor`, `bench`.

---

### 4. Script `doctor.sh` — kiểm tra tool chưa cài

Đã có qua `./install.sh --doctor` và `make doctor`.

---

### 5. Hỗ trợ macOS / Linux tự động

Một số alias và path khác nhau giữa macOS và Linux. Có thể detect trong `env.zsh`:

```zsh
if [[ "$(uname)" == "Darwin" ]]; then
  source "$ZSH_CONFIG/env.macos.zsh"
else
  source "$ZSH_CONFIG/env.linux.zsh"
fi
```

---

### 6. Tích hợp `chezmoi` (dài hạn)

Nếu dotfiles ngày càng phức tạp (nhiều máy, nhiều secret), cân nhắc dùng [chezmoi](https://www.chezmoi.io/) — hỗ trợ template, secret manager, diff tool.

---

## 📊 Tóm tắt ưu tiên

| # | Cải tiến | Độ ưu tiên | Effort |
|---|---|---|---|
| 2 | Đo startup speed | 🟡 Trung bình | Thấp |
| 4 | Hỗ trợ macOS / Linux detect | 🟢 Thấp | Trung bình |
| 5 | Tách env theo OS (env.macos.zsh/env.linux.zsh) | 🟢 Thấp | Trung bình |
| 6 | chezmoi | 🟢 Thấp | Cao |
