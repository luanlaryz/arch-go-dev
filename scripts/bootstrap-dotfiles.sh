#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-/opt/dotfiles}"
TARGET_HOME="${HOME:-/home/dev}"

backup_suffix=".bak.$(date +%s)"

link_entry() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    return
  fi

  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    mv "$target_path" "${target_path}${backup_suffix}"
  fi

  ln -sfn "$source_path" "$target_path"
}

link_entry "${DOTFILES_DIR}/.zshrc" "${TARGET_HOME}/.zshrc"
link_entry "${DOTFILES_DIR}/.tmux.conf" "${TARGET_HOME}/.tmux.conf"
link_entry "${DOTFILES_DIR}/nvim" "${TARGET_HOME}/.config/nvim"

mkdir -p "${TARGET_HOME}/workspace"
mkdir -p "${TARGET_HOME}/.cache/go-build"
mkdir -p "${TARGET_HOME}/go/pkg/mod"
mkdir -p "${TARGET_HOME}/.local/share/nvim"
touch "${TARGET_HOME}/.zsh_history"
