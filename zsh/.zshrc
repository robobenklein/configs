# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# If the shell is a login shell, use fishy theme to avoid font problems.
# If shell is tmux or not login, use agnoster (fonts available)
[[ -o login ]] && ZSH_THEME="fishy" || ZSH_THEME="agnoster"
[ -n "$TMUX" ] && ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git command-not-found github python cp colored-man-pages zsh-syntax-highlighting z)

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
# Load oh-my-zsh #
#----------------#
source $ZSH/oh-my-zsh.sh

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
