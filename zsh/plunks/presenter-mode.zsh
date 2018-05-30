
# function which sets up the terminal for use during demos and explainers
function zsh_presenter_mode_start() {
  # function that prints the expanded command right-aligned before running it
  # (e.x. shows aliases in expanded form so peeps aren't lost)
  function preshow_expanded_command() {
    if [[ "$1" != "$2" ]]; then
      printf "%$(($(tput cols)))b\n" "expanded: \033[0;1m$2\033[0;0m"
    fi
  }
  Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP=$preexec_functions
  echo "Backed up preexec array: $Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP"
  preexec_functions+=(preshow_expanded_command)
  Z_PRESENTER_MODE_ENABLED=1
  # set terminal background to black to improve contrast:
  echo -e "\033]11;#000000\a"
  # switch toggle command
  alias zsh-presenter-toggle=zsh_presenter_mode_stop
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
    echo "restored preexec array: $preexec_functions"
    unset Z_PRESENTER_MODE_ENABLED
    unset Z_PRESENTER_PREEXEC_FUNCTIONS_BACKUP
    alias zsh-presenter-toggle=zsh_presenter_mode_start
  else
    >&2 echo "Presenter mode not enabled."
    return 1
  fi
}

alias zsh-presenter-toggle=zsh_presenter_mode_start
