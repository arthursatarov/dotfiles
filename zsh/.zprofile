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
