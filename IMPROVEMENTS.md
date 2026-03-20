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

---

## 🔜 Đề xuất tiếp theo

### 1. Tách `env.zsh` thành `.zshenv`

**Vấn đề:** `env.zsh` chỉ được load khi mở terminal tương tác. Các biến `PATH`, `NVM_DIR`... sẽ không có trong non-interactive shell (script, cron, SSH commands).

**Giải pháp:** Chuyển export PATH và biến môi trường cốt lõi sang `~/.zshenv`:

```zsh
# ~/.zshenv — load bởi ZSH trước mọi thứ, kể cả non-interactive
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
```

---

### 2. Lazy loading NVM

**Vấn đề:** `nvm.sh` làm chậm startup ~200-400ms mỗi lần mở terminal.

**Giải pháp:** Chỉ load NVM khi thực sự gọi `nvm`, `node`, `npm`, `npx`:

```zsh
# Trong env.zsh — thay thế phần NVM hiện tại
export NVM_DIR="$HOME/.nvm"

_load_nvm() {
  unset -f nvm node npm npx yarn pnpm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

nvm()  { _load_nvm; nvm "$@" }
node() { _load_nvm; node "$@" }
npm()  { _load_nvm; npm "$@" }
npx()  { _load_nvm; npx "$@" }
```

---

### 3. Đo tốc độ startup

**Mục đích:** Biết module nào làm chậm shell.

```bash
# Thêm vào Makefile
make bench
# → chạy: for i in $(seq 1 5); do time zsh -i -c exit; done
```

---

### 4. `Makefile` mở rộng

Thêm các target hữu ích:

```makefile
lint:    # zsh -n kiểm tra syntax tất cả file .zsh
test:    # chạy bộ test cơ bản (alias tồn tại, function hoạt động)
update:  # git pull + source ~/.zshrc
doctor:  # kiểm tra tool nào chưa cài
```

---

### 5. Bộ test tối giản

**Mục đích:** Tránh typo trong alias/function làm shell không load được.

```bash
# dotfiles/test/zsh_test.sh
#!/usr/bin/env zsh
source "$HOME/dotfiles/zsh/config/aliases.zsh"
assert_alias() { alias "$1" &>/dev/null || echo "FAIL: alias $1 missing" }
assert_alias ls; assert_alias lg; assert_alias dc
echo "Tests passed"
```

---

### 6. Script `doctor.sh` — kiểm tra tool chưa cài

```bash
./install.sh --doctor
# Output:
# [ok]  eza
# [ok]  bat
# [MISS] lazydocker  →  brew install lazydocker
# [MISS] ctop        →  brew install ctop
```

---

### 7. Hỗ trợ macOS / Linux tự động

Một số alias và path khác nhau giữa macOS và Linux. Có thể detect trong `env.zsh`:

```zsh
if [[ "$(uname)" == "Darwin" ]]; then
  source "$ZSH_CONFIG/env.macos.zsh"
else
  source "$ZSH_CONFIG/env.linux.zsh"
fi
```

---

### 8. Starship config trong dotfiles

Hiện tại `starship.toml` không được quản lý. Nên thêm:

```
dotfiles/
└── starship/
    └── starship.toml     ← symlink → ~/.config/starship.toml
```

---

### 9. Tích hợp `chezmoi` (dài hạn)

Nếu dotfiles ngày càng phức tạp (nhiều máy, nhiều secret), cân nhắc dùng [chezmoi](https://www.chezmoi.io/) — hỗ trợ template, secret manager, diff tool.

---

## 📊 Tóm tắt ưu tiên

| # | Cải tiến | Độ ưu tiên | Effort |
|---|---|---|---|
| 2 | Lazy loading NVM | 🔴 Cao | Thấp |
| 1 | Tách `.zshenv` | 🔴 Cao | Thấp |
| 6 | Script `doctor.sh` | 🟡 Trung bình | Thấp |
| 3 | Đo startup speed | 🟡 Trung bình | Thấp |
| 8 | Starship trong dotfiles | 🟡 Trung bình | Thấp |
| 7 | macOS / Linux detect | 🟢 Thấp | Trung bình |
| 5 | Bộ test | 🟢 Thấp | Trung bình |
| 9 | chezmoi | 🟢 Thấp | Cao |
