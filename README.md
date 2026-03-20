# dotfiles

Cấu hình shell cá nhân, được tổ chức theo kiểu modular dotfile.

## Cấu trúc

```
dotfiles/
├── install.sh            ← Script cài đặt (tạo symlinks)
├── README.md
└── zsh/
    ├── zshrc             ← ~/.zshrc (entry point)
    └── config/
        ├── env.zsh           ← PATH, NVM, BUN, brew, atuin, envman
        ├── options.zsh       ← ZSH options + history config
        ├── completion.zsh    ← compinit, zstyle, docker/kubectl completion
        ├── plugins.zsh       ← fzf, zoxide, starship, autosuggestions, syntax-highlight, atuin
        ├── aliases.zsh       ← modern CLI, git, docker, k8s, system aliases
        ├── functions.zsh     ← fsearch, hs, hgrep, sgrep, dsearch, lsearch, dklog, log
        ├── keybindings.zsh   ← bindkey
        ├── history-auto-repair.zsh  ← tự sửa history bị corrupt
        └── history-repair.sh
```

## Cài đặt

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Script sẽ:
- Tạo symlinks từ repo → `~/.config/zsh/` và `~/.zshrc`
- Tự động backup file cũ vào `~/.dotfiles-backup/<timestamp>/` nếu có

## Cập nhật

Chỉnh sửa file trong `~/dotfiles/zsh/` — symlink nên thay đổi có hiệu lực ngay.

```bash
source ~/.zshrc   # reload
```

## Thêm máy mới

```bash
git clone <repo-url> ~/dotfiles && ~/dotfiles/install.sh
```
