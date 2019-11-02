#!/bin/zsh

# original idea from
# http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/

tm () {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if (( ${+1} )); then
    tmux $change -t "$1" 2>/dev/null || {
      (tmux -f ~/.tmux.conf new-session -d -s $1 && tmux $change -t "$1")
    }
  else
    local session
    if [[ "$(tmux list-sessions -F "#{session_name}" 2>/dev/null)" != "" ]]; then
      session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzy -p 'tmux sessions > ' ) && {
        tmux $change -t "$session"
      } || {
        [[ ! -n "$session" ]] && return
        read -k 1 "REPLY?Create session \"${session}\"? [Y/n] "
        echo
        [[ $REPLY == 'y' || $REPLY == "" ]] && tm $session
      }
    else
      tmux
    fi
  fi
}

function _fzy_tmux () {
  local -a sessions
  sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
  compadd -a sessions
}
# doesn't load on 5.0.X?
compdef _fzy_tmux tm 2>/dev/null

if (( ${+TMUX} )); then
  if ! tmux showenv -g TMUX_POWERSHELL >/dev/null 2>&1; then
    TMUX_POWERSHELL=$(python3 -c "import powerline,os; print(os.path.join(powerline.__path__[0], \"bindings/tmux/powerline.conf\"))")
    tmux setenv -g TMUX_POWERSHELL "$TMUX_POWERSHELL"
    tmux source-file "$TMUX_POWERSHELL"
  fi
fi
