# 🛠 dotfiles

Cấu hình shell cá nhân, tổ chức theo kiểu **modular dotfile** — mỗi chức năng một file, dễ chỉnh, dễ mang sang máy mới.

---

## 📁 Cấu trúc

```
dotfiles/
├── install.sh                    ← Script cài đặt / gỡ cài đặt
├── Makefile                      ← Shortcut: make install, make update...
├── .gitignore
├── README.md
├── test/
│   └── zsh_test.sh               ← smoke test cho aliases/functions
├── starship/
│   └── starship.toml             ← ~/.config/starship.toml
└── zsh/
    ├── .zshenv                   ← ~/.zshenv (core env cho cả interactive + non-interactive)
    ├── zshrc                     ← ~/.zshrc  (entry point, chỉ source các module)
    └── config/
        ├── env.zsh               ← init runtime: bun hook, lazy NVM, brew, atuin, envman
        ├── options.zsh           ← ZSH options + HISTSIZE
        ├── completion.zsh        ← compinit, zstyle, docker/kubectl completion
        ├── plugins.zsh           ← fzf, zoxide, starship, autosuggestions, syntax-highlight, atuin
        ├── aliases.zsh           ← modern CLI, git, docker, k8s, system
        ├── functions.zsh         ← fsearch, hs, hgrep, sgrep, dsearch, lsearch, dklog, log
        ├── keybindings.zsh       ← bindkey
        ├── history-auto-repair.zsh
        ├── history-repair.sh
        └── local.zsh             ← (KHÔNG commit) override riêng cho từng máy
```

> **`local.zsh`** được load cuối cùng — dùng để override alias, thêm env var hoặc cấu hình riêng mà không cần chỉnh file chung.

> **`.zshenv`** luôn được Zsh load trước (kể cả non-interactive shell). Chỉ để biến môi trường cốt lõi, tránh `source`/`eval` nặng trong file này.

---

## ⚡ Cài đặt nhanh

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Xong. Mở terminal mới hoặc chạy `source ~/.zshrc`.

---

## 🔧 Yêu cầu

Script sẽ kiểm tra và cảnh báo nếu thiếu tool. Dưới đây là danh sách đầy đủ:

| Tool | Mục đích | Cài đặt |
|---|---|---|
| [zsh](https://www.zsh.org/) | Shell chính | `apt install zsh` |
| [starship](https://starship.rs/) | Prompt | `curl -sS https://starship.rs/install.sh \| sh` |
| [eza](https://github.com/eza-community/eza) | `ls` thay thế | `brew install eza` |
| [bat](https://github.com/sharkdp/bat) | `cat` thay thế | `brew install bat` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` thay thế | `brew install ripgrep` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | `brew install fzf` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` thay thế | `brew install zoxide` |
| [atuin](https://github.com/atuinsh/atuin) | History nâng cao | `curl --proto '=https' --tlsf v1 -LsSf https://setup.atuin.sh \| sh` |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI | `brew install lazygit` |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker TUI | `brew install lazydocker` |
| [btop](https://github.com/aristocratsoftics/btop) | System monitor | `brew install btop` |
| [duf](https://github.com/muesli/duf) | Disk usage | `brew install duf` |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Gợi ý lệnh | `brew install zsh-autosuggestions` |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Tô màu syntax | `brew install zsh-syntax-highlighting` |

---

## 📖 Aliases

### Modern CLI

| Alias | Lệnh thật | Mô tả |
|---|---|---|
| `ls` | `eza --icons` | List file với icon |
| `ll` | `eza -lah --icons` | List chi tiết |
| `la` | `eza -a --icons` | Bao gồm file ẩn |
| `tree` | `eza --tree --icons` | Dạng cây |
| `cat` | `bat` | Hiển thị file có syntax highlight |
| `grep` | `rg` | Tìm kiếm nhanh hơn |
| `rgd` | `rg -g "!*.log" -g "!node_modules"` | rg bỏ qua log và node_modules |

### Git

| Alias | Lệnh thật |
|---|---|
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add .` |
| `gc` | `git commit` |
| `gcm "msg"` | `git commit -m "msg"` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gd` | `git diff` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `glog` | `git log --oneline --graph --decorate` |
| `lg` | `lazygit` |

### Docker

| Alias | Lệnh thật |
|---|---|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dps` | `docker ps` |
| `dpa` | `docker ps -a` |
| `di` | `docker images` |
| `dex` | `docker exec -it` |
| `dlog` | `docker logs -f` |
| `ld` | `lazydocker` |
| `ct` | `ctop` |

### Kubernetes

| Alias | Lệnh thật |
|---|---|
| `k` | `k9s` |
| `kgp` | `kubectl get pods` |
| `kgs` | `kubectl get svc` |
| `kgn` | `kubectl get nodes` |

### System

| Alias | Lệnh thật |
|---|---|
| `cls` | `clear` |
| `bt` | `btop` |
| `df` | `duf` |
| `reload` | `source ~/.zshrc` |

---

## 🔍 Functions

### `fsearch <pattern>`
Tìm nội dung trong file → preview với bat → mở file trong nvim đúng dòng.
```bash
fsearch "TODO"
```

### `hs <pattern>`
Tìm trong file config (yaml, toml, json) với fzf preview.
```bash
hs "traefik"
```

### `hgrep <pattern>`
Tìm với context 3 dòng trong `*.yml`, `*.yaml`, `*.env`.
```bash
hgrep "DATABASE_URL"
```

### `sgrep <pattern> <service>`
Tìm trong thư mục `services/<service>`.
```bash
sgrep "PORT" api
```

### `dsearch <pattern>`
Tìm trong file docker-compose.
```bash
dsearch "volumes"
```

### `lsearch <pattern>`
Tìm trong `/var/log` và `~/logs`.
```bash
lsearch "error"
```

### `dklog <service> <pattern>`
Xem log docker compose + filter realtime.
```bash
dklog api "ERROR"
```

### `log <service> [pattern]`
Xem log docker hoặc k8s tùy biến `MODE`.
```bash
log api "panic"
MODE=k8s log my-pod "timeout"
```

---

## 🛠 Workflow

### Cập nhật dotfiles

```bash
# Chỉnh file trong ~/dotfiles/zsh/
vim ~/dotfiles/zsh/config/aliases.zsh

# Reload ngay
reload   # hoặc: source ~/.zshrc

# Commit và push
cd ~/dotfiles
git add . && git commit -m "feat: add new alias"
git push
```

### Đồng bộ sang máy khác

```bash
git pull   # trong ~/dotfiles/
```

Vì dùng symlink nên thay đổi có hiệu lực ngay — không cần chạy lại `install.sh`.

### Kiểm tra syntax nhanh

```bash
make lint
```

### Chạy smoke test

```bash
make test
```

Chạy một test đơn theo alias:

```bash
make test TEST="alias ls"
```

### Gỡ cài đặt

```bash
cd ~/dotfiles && ./install.sh --uninstall
```

---

## ⚙️ Tùy chỉnh riêng (local.zsh)

Tạo file `~/.config/zsh/local.zsh` cho cấu hình riêng của từng máy (không bị commit):

```bash
# Ví dụ: ~/.config/zsh/local.zsh

export WORK_TOKEN="ghp_..."
export KUBECONFIG="$HOME/.kube/work-cluster.yaml"
alias vpn="sudo openvpn ~/work.ovpn"
```

---

## 🚀 Đề xuất cải tiến

Xem chi tiết trong [`IMPROVEMENTS.md`](./IMPROVEMENTS.md).

---

## 💡 Tips

- **`Ctrl+R`** → fzf history search (hoặc dùng atuin nếu đã cài)
- **`z <tên-thư-mục>`** → nhảy nhanh đến thư mục đã từng cd vào (zoxide)
- **`fsearch`** → tìm code trong project, Enter để mở nvim đúng dòng
- History tự sửa khi bị corrupt nhờ `history-auto-repair.zsh`
