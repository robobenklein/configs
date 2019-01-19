# More power

###
# !!!
# https://github.com/bhilburn/powerlevel9k/issues/852
prompt_context_no_sudo_check () {
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=("ROOT" "yellow" "SUDO" "red" "DEFAULT" "white" "REMOTE" "green" "REMOTE_SUDO" "yellow")
  local content=""
  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_CONTEXT" == true ]] || [[ "$(whoami)" != "$DEFAULT_USER" ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    content="${POWERLEVEL9K_CONTEXT_TEMPLATE}"
  elif [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]]; then
    content="$(whoami)"
  else
    return
  fi
  if [[ $(print -P "%#") == '#' ]]; then
    current_state="ROOT"
  elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    # if sudo -n true 2> /dev/null
    # then
    # 	current_state="REMOTE_SUDO"
    # else
    current_state="REMOTE"
    # fi
  # elif sudo -n true 2> /dev/null; then
  #   current_state="SUDO"
  fi
  "$1_prompt_segment" "${0}_${current_state}" "$2" "$DEFAULT_COLOR" "${context_states[$current_state]}" "${content}"
}

zplugin env-whitelist 'POWERLEVEL9K_*'

# ZSH_THEME="$Z_INSTALL_DETECT_POWERLINE_THEME"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context_no_sudo_check root_indicator dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs battery time)
# Vim master race?
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=( vi_mode )
POWERLEVEL9K_VI_INSERT_MODE_STRING="I"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="CMD"
# Specifics
POWERLEVEL9K_BATTERY_LOW_THRESHOLD=30
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
# User
DEFAULT_USER="robo"
POWERLEVEL9K_ALWAYS_SHOW_USER="true"
POWERLEVEL9K_USER_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_USER_SUDO_FOREGROUND="gold1"
POWERLEVEL9K_USER_ROOT_FOREGROUND="red"
POWERLEVEL9K_USER_ICON=""
POWERLEVEL9K_ROOT_ICON=""
POWERLEVEL9K_SUDO_ICON=""
# Host
POWERLEVEL9K_HOST_LOCAL_FOREGROUND="grey58"
POWERLEVEL9K_HOST_REMOTE_FOREGROUND="white"
POWERLEVEL9K_HOST_ICON=""
POWERLEVEL9K_SSH_ICON=""
# Context
POWERLEVEL9K_ALWAYS_SHOW_CONTEXT="true"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="grey58"
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="maroon"
POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND="white"
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND="gold1"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="red"
# Single
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="red"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="black"
POWERLEVEL9K_BATTERY_ICON=""
POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD="95"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="black"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="242" # dimm gray
POWERLEVEL9K_EXECUTION_TIME_ICON="⧖ "
POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON="⇗ "
if (( ${+functions[rtab]} )); then
  POWERLEVEL9K_CUSTOM_RTAB_DIR="echo \${RTAB_PWD}"
  POWERLEVEL9K_CUSTOM_RTAB_DIR_FOREGROUND="black"
  POWERLEVEL9K_CUSTOM_RTAB_DIR_BACKGROUND="blue"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context_no_sudo_check root_indicator dir_writable custom_rtab_dir vcs)
  typeset -a chpwd_functions
  chpwd_functions+=(_rtab_pwd_update)
  function _rtab_pwd_update() {
    export RTAB_PWD=$(rtab -l -t)
  }
  _rtab_pwd_update
fi

zplugin ice from"gh"
zplugin load bhilburn/powerlevel9k
