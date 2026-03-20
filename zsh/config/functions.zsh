# =========================
# FUNCTIONS
# =========================

# Search content + preview + open in nvim
fsearch() {
  rg --line-number --no-heading --color=always "$1" | \
  fzf --ansi \
      --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
      --delimiter ':' \
      --bind 'enter:become(nvim {1} +{2})'
}

# Search config files (yaml, toml, json)
hs() {
  rg -t yaml -t yml -t toml -t json "$1" | \
  fzf --preview 'bat --color=always {}'
}

# Search with context in config/env files
hgrep() {
  rg -n -C 3 \
    -g "*.yml" -g "*.yaml" -g "*.env" \
    "$1" .
}

# Search by service directory
sgrep() {
  rg "$1" services/$2
}

# Search docker/compose files
dsearch() {
  rg -g "*docker-compose*" -g "*compose*" "$1"
}

# Search system logs
lsearch() {
  rg "$1" /var/log ~/logs
}

# Filtered docker compose logs
dklog() {
  docker compose logs -f "$1" | rg --line-buffered "$2"
}

# Unified log: docker or k8s depending on MODE env
# Usage: MODE=k8s log <pod> <pattern>
log() {
  if [ "$MODE" = "k8s" ]; then
    kubectl logs -f "$1" | rg "$2"
  else
    docker compose logs -f "$1" | rg "$2"
  fi
}
