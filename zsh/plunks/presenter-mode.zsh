
typeset -A _zsh_presenter_overrides
_zsh_presenter_overrides=()

# function which sets up the terminal for use during demos and explainers
function zsh_presenter_mode_start() {
  # function that prints the expanded command right-aligned before running it
  # (e.x. shows aliases in expanded form so peeps aren't lost)
  function preshow_expanded_command() {
    if [[ "$1" != "$2" ]]; then
      printf "%$(($(tput cols)))b\n" "\033[0;2mexpanded: \033[0;1m$2\033[0;0m"
    fi
    previous_command="$2"
    precmd_functions+=(postshow_previous_command)
  }
  function postshow_previous_command() {
      # a=("${(@)a:#b}")
      printf "%$(($(tput cols)))b\n" "\033[0;2mprevious: \033[0;1m$previous_command\033[0;0m"
      precmd_functions=("${(@)precmd_functions:#postshow_previous_command}")
  }
  Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP=$preexec_functions
  Z_PRESENTER_PRECMD_FUNCTIONS_BACKUP=$precmd_functions
  echo "Backed up preexec array: $Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP"
  echo "Backed up precmd array: $Z_PRESENTER_PRECMD_FUNCTIONS_BACKUP"
  preexec_functions+=(preshow_expanded_command)
  precmd_functions+=(postshow_previous_command)
  Z_PRESENTER_MODE_ENABLED=1
  # set terminal background to black to improve contrast:
  echo -e "\033]11;#000000\a"
  # switch toggle command
  alias zsh-presenter-toggle=zsh_presenter_mode_stop
  # load the as-you-type expansion:
  zinit ice from"gh"
  zinit load "simnalamburt/zsh-expand-all"
  ZSH_EXPAND_ALL_DISABLE="word"
  sleep 1
  clear
  echo ""
  title="PRESENTATION MODE"
  printf "%*s\n" $(((${#title}+$(tput cols))/2)) "$title"
  echo ""
}
function zsh_presenter_mode_stop() {
  echo -e "\033]11;${TERM_EMULATOR_BG_DEFAULT}\a"
  # Check that we're not gonna accidentally set the preexec array blank
  if (( $+Z_PRESENTER_MODE_ENABLED )) && (( $+Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP )); then
    preexec_functions=($Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP)
    precmd_functions=($Z_PRESENTER_PRECMD_FUNCTIONS_BACKUP)
    echo "restored preexec array: $preexec_functions"
    echo "restored precmd array: $precmd_functions"
    unset Z_PRESENTER_MODE_ENABLED
    unset Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP
    unset Z_PRESENTER_PRECMD_FUNCTIONS_BACKUP
    alias zsh-presenter-toggle=zsh_presenter_mode_start
    zinit unload "simnalamburt/zsh-expand-all"
  else
    >&2 echo "Presenter mode not enabled."
    return 1
  fi
}

alias zsh-presenter-toggle=zsh_presenter_mode_start
