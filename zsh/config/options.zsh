# =========================
# ZSH OPTIONS
# =========================

# Navigation
setopt AUTO_CD

# UX
unsetopt CORRECT
setopt INTERACTIVE_COMMENTS

# Globbing
setopt EXTENDED_GLOB

# History
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY

# =========================
# HISTORY CONFIG
# =========================
HISTSIZE=20000
SAVEHIST=20000
HISTFILE=~/.zsh_history

# =========================
# SECRET GUARD - Block secrets from shell history
# =========================
SECRET_PATTERN='(API_KEY|TOKEN|SECRET|PASSWORD|AUTH|PRIVATE_KEY|ACCESS_KEY|Bearer |sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{20,})'

zshaddhistory() {
    emulate -L zsh

    local cmd="${1}"

    if [[ "$cmd" =~ $SECRET_PATTERN ]]; then
        print -P "%F{yellow}⚠️  Sensitive command blocked from history%f"
        return 1
    fi

    return 0
}
