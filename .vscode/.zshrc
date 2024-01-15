export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"
export LANG="en_US.UTF-8"
export EDITOR='vim'
export ARCHFLAGS="-arch x86_64"

if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
    ZSH_THEME=""
    zstyle ':omz:update' mode auto
    zstyle ':omz:update' frequency 13
    plugins=(git zoxide direnv fzf)
    source $ZSH/oh-my-zsh.sh
fi

alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim='nvim'
alias ls="lsd"
alias ll="lsd -l"
alias la="lsd -la"
alias tree="lsd -a --tree"
eval "$(starship init zsh)"
