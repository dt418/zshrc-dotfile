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
