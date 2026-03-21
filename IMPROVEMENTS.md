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
- [x] Auto-repair history chạy detached, tránh warning `jobs SIGHUPed`
- [x] Thêm TUI menu trong `install.sh --menu` (ưu tiên `fzf`, fallback `select`)
- [x] Git hooks với lefthook (pre-commit lint/test, commit-msg commitlint)
- [x] Code review skill và changelog automation skill cho agent
- [x] `AGENTS.md` với comprehensive guidelines cho AI agent

---

## 🔜 Đề xuất tiếp theo

### 1. Lazy loading NVM

Đã áp dụng trong `zsh/config/env.zsh`.

---

### 2. Đo tốc độ startup ✅

```bash
make bench
# → chạy: for i in $(seq 1 5); do time zsh -i -c exit; done
```

---

### 3. `Makefile` mở rộng ✅

Đã có: `lint`, `test`, `update`, `doctor`, `bench`, `menu`, `chezmoi-install`, `chezmoi-init`, `chezmoi-apply`.

---

### 4. Script `doctor.sh` — kiểm tra tool chưa cài ✅

Đã có qua `./install.sh --doctor` và `make doctor`.

---

### 5. Hỗ trợ macOS / Linux tự động ✅

Đã áp dụng:

- `env.zsh` làm entrypoint detect OS
- `env.shared.zsh` chứa logic dùng chung
- `env.macos.zsh` và `env.linux.zsh` chứa setup theo hệ điều hành

---

### 6. Tích hợp `chezmoi` (dài hạn)

Đã thêm mức cơ bản trong `Makefile` để cài/init/apply với [chezmoi](https://www.chezmoi.io/) mà chưa cần đổi cấu trúc repo hiện tại.

---

## 📊 Tóm tắt ưu tiên

| # | Cải tiến | Độ ưu tiên | Effort |
|---|---|---|---|
| 6 | chezmoi | 🟡 Trung bình | Cao |
| 7 | Zsh plugin manager (zinit/zplugin) | 🟡 Trung bình | Cao |
