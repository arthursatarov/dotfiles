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
# ZSH Plugins
########################################
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab


########################################
# Keybindings
########################################
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


########################################
# ZSH History
########################################
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


########################################
# Completion Setup
########################################
autoload -U compinit && compinit -u

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-preview 'bat --color=always $realpath || cat $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept'


########################################
# Shell Integrations
########################################
source <(fzf --zsh)

#eval "$(starship init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/emodipt-extend.omp.json)"
eval "$(zoxide init --cmd cd zsh)"

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


########################################
# Environment Variables
########################################
export PATH="$HOME/.local/bin:$PATH"

########################################
# Aliases
########################################
alias c="clear"
alias cl="clear"
alias clr="clear"

alias ls='eza --icons --group-directories-first'
alias la='eza --icons -a --group-directories-first'
alias ll='eza -la --icons'

alias vi='nvim'
alias vim='nvim'
alias lzg='lazygit'

# Tmux
alias ta="tmux attach -t"           # Attach tmux to already running named session
alias tad="tmux attach -d -t"       # Detach named tmux session
alias ts="tmux new-session -s"      # Create a new named tmux session
alias tl="tmux list-sessions"       # Displays a list of running tmux sessions
alias tksv="tmux kill-server"       # Terminate all running tmux sessions
alias tkss="tmux kill-session -t"   # Terminate named running tmux session

# Docker Compose
alias dco="docker-compose"  	           
alias dcb="docker-compose build"  	           
alias dce="docker-compose exec"  	           
alias dcps="docker-compose ps"  	           
alias dcrestart="docker-compose restart"  	           
alias dcrm="docker-compose rm"      
alias dcr="docker-compose run"      
alias dcR="docker-compose run --rm"      
alias dcstop="docker-compose stop"      
alias dcup="docker-compose up"       
alias dcupd="docker-compose up -d"       
alias dcupdb="docker-compose up -d --build"       
alias dcdn="docker-compose down"        
alias dcl="docker-compose logs"        
alias dclf="docker-compose logs -f"        
alias dclF="docker-compose logs -f --tail0"        
alias dcpull="docker-compose pull"        
alias dcstart="docker-compose start"        
alias dck="docker-compose kill"        

# Composer
alias ccp='composer create-project'
alias cdo='composer dump-autoload -o'
alias cdu='composer dump-autoload'
alias cget='curl -s https://getcomposer.org/installer | php'
alias cgr='composer global require'
alias cgrm='composer global remove'
alias cgu='composer global update'
alias ci='composer install'
alias co='composer outdated'
alias cod='composer outdated --direct'
alias cr='composer require'
alias crm='composer remove'
alias cs='composer show'
alias csu='composer self-update'
alias cu='composer update'
alias cuh='composer update --working-dir=$(composer config -g home)'

########################################
# NVM
########################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
