########################################
# Environment (login shells)
########################################

# Homebrew: put /opt/homebrew/bin ahead of system binaries
eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR="nvim"
export VISUAL="nvim"

typeset -U path
path=(
  $HOME/.local/bin                          # Postman CLI and other user binaries
  $path
  /Applications/Obsidian.app/Contents/MacOS # Obsidian CLI
)

# Point macOS-default tools at ~/.config (managed by stow)
export EZA_CONFIG_DIR="$HOME/.config/eza"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# fzf: Rose Pine (https://github.com/rose-pine/fzf), background follows the terminal
export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:-1,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:-1
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
