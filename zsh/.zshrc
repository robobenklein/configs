# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# If the shell is a login shell, use fishy theme to avoid font problems.
# If shell is tmux or not login, use agnoster (fonts available)
[[ -o login ]] && ZSH_THEME="fishy" || ZSH_THEME="agnoster"
[ -n "$TMUX" ] && ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# oh-my-zsh plugins
plugins=(git command-not-found github python cp colored-man-pages zsh-syntax-highlighting z)
typeset -U plugins
# antigen bundle plugins
antigenplugins=(git command-not-found cp z zsh-users/zsh-syntax-highlighting)
typeset -U antigenplugins

#--------------------#
# User configuration #
#--------------------#

# Tmux plugin:
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="screen-256color"
ZSH_TMUX_AUTOSTART="false"
ZSH_TMUX_AUTOCONNECT="false"

[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc

# Go environment
[ -d $HOME/code/go ] && export GOPATH=$HOME/code/go
[ -d $HOME/code/go/bin ] && path+=($HOME/code/go/bin)

# NVM nodejs
if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

#----------------#
# Load framework #
#----------------#

# If ~/.antigen, then use that instead of oh-my-zsh
if [ -d $HOME/.antigen ]; then
  source $HOME/.antigen/antigen.zsh
  antigen use oh-my-zsh
  for plugin in $antigenplugins; do
    antigen bundle "$plugin"
  done
  antigen theme $ZSH_THEME
  antigen apply
  # Remove paths that start with $HOME/.antigen/
  path=( ${path%$HOME/.antigen/*} )
else
  # Otherwise use oh-my-zsh
  source $ZSH/oh-my-zsh.sh
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Editor
if command -v nvim > /dev/null 2>&1; then
  export EDITOR='nvim'
elif command -v vim > /dev/null 2>&1; then
  export EDITOR='vim'
elif command -v vi > /dev/null 2>&1; then
  export EDITOR='vi'
elif command -v nano > /dev/null 2>&1; then
  export EDITOR='nano'
fi
alias v="$EDITOR"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gpg-message="gpg2 -a -es -r"
alias gpg-sign="gpg2 -a -s"
alias a="atom"
alias n="nautilus"

### PATH configuration
# Keep this clean!
typeset -U path # unique items only in path array

# Place home bin at front of path
[ -d $HOME/bin ] && path[1,0]=$HOME/bin

export PATH

# EOF
ZSHRC_LOADED=1
