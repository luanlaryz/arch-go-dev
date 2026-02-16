export EDITOR="nvim"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

setopt autocd
setopt no_beep

export ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
  ZSH_THEME="robbyrussell"
  plugins=(git)
  source "$ZSH/oh-my-zsh.sh"
else
  PROMPT='%n@%m:%~ %# '
fi

alias ll='ls -lah'
alias gs='git status -sb'
alias v='nvim'
