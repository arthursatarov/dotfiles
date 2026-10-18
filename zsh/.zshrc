########################################
# Zinit Plugin Manager Setup
########################################
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load essential annexes
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

########################################
# Completion Setup
########################################
zinit light zsh-users/zsh-completions

# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)

# Rebuild the completion dump once a day, otherwise load it from cache
autoload -Uz compinit
_stale_dump=($ZDOTDIR/.zcompdump(N.mh+24))
if (( $#_stale_dump )); then
  compinit
else
  compinit -C
fi
unset _stale_dump

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-preview 'bat --color=always $realpath || cat $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept'

########################################
# ZSH Plugins
########################################
# fzf-tab goes after compinit, syntax-highlighting goes last
zinit light Aloxaf/fzf-tab
zinit light akash329d/zsh-alias-finder
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

########################################
# Keybindings
########################################
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

########################################
# ZSH History
########################################
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

########################################
# Shell Integrations
########################################

# FZF
source <(fzf --zsh)

# Oh My POSH
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/rose-pine.omp.json)"

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# fnm (Node version manager, switches on .nvmrc / .node-version)
eval "$(fnm env --use-on-cd --shell zsh)"

# PHP: per-project version from the nearest .php-version (e.g. "8.2"),
# falls back to the linked `php` formula. Older versions: brew install shivammathur/php/php@7.4
function _php_version_use() {
  local dir=$PWD ver=
  while [[ -n $dir ]]; do
    [[ -f $dir/.php-version ]] && { ver=$(<$dir/.php-version); break; }
    dir=${dir%/*}
  done
  path=(${path:#$HOMEBREW_PREFIX/opt/php@*/(s|)bin})
  ver=${(M)ver##<->.<->}
  [[ -z $ver ]] && return
  if [[ -d $HOMEBREW_PREFIX/opt/php@$ver/bin ]]; then
    path=($HOMEBREW_PREFIX/opt/php@$ver/bin $HOMEBREW_PREFIX/opt/php@$ver/sbin $path)
  else
    print -P "%F{yellow}php $ver from .php-version is not installed: brew install shivammathur/php/php@$ver%f"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _php_version_use
_php_version_use

# direnv: per-project env from .envrc
eval "$(direnv hook zsh)"

# Ngrok
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# Superfile: cd into the last directory on quit
function spf() {
  export SPF_LAST_DIR="$HOME/Library/Application Support/superfile/lastdir"
  command spf "$@"
  [[ -f $SPF_LAST_DIR ]] && { . "$SPF_LAST_DIR"; rm -f -- "$SPF_LAST_DIR"; }
}

########################################
# Aliases
########################################

if [ -f "$ZDOTDIR/.aliases" ]; then
  source "$ZDOTDIR/.aliases"
fi
