
if command -v docker >/dev/null 2>&1 && [[ "$platform" == "Linux" ]]; then
function fancy-docker() {

  if command -v resize >/dev/null 2>&1; then
    eval $(resize)
  elif [[ "$COLUMNS" == "" ]] || [[ "$LINES" == "" ]] ; then
    echo "Could not find screen dimensions."
    return 2
  fi

  if command -v whiptail >/dev/null 2>&1; then
    PROMPTER=whiptail
  else
    if command -v dialog; then
      PROMPTER=dialog
    else
      echo "Please install whiptail or dialog first!"
      return 1
    fi
  fi

  local cleanup() {
    # clean up because killing a $PROMPTER will leave the terminal a mess
    tput rmcup
    return $SIGNAL;
  }
  tput smcup
  trap 'SIGNAL=$?;cleanup' ERR
  trap 'cleanup' SIGINT

  local tmpout="$(mktemp -d)"

  stdbuf -o0 \
  docker "$@" | \
  stdbuf -o0 tee ${tmpout}/docker.log | \
  stdbuf -o0 grep -e '^Step [0-9]\+/[0-9]\+ :' | \
  stdbuf -o0 tee ${tmpout}/steps.log | \
  stdbuf -o0 cut -d ' ' -f2,4- | \
  stdbuf -o0 sed 's;/; ;1' | \
  stdbuf -o0 awk '{pc=100*($1/($2 +1));i=int(pc);print "XXX\n" i "\n" $0 "\nXXX"}' | \
  $PROMPTER --title "Running..." --gauge "Starting Docker Build..." $(( LINES - 4 )) $(( COLUMNS - 18 )) $(( $LINES - 12 ))

  tput rmcup
  trap '' ERR
  trap '' SIGINT

  echo "Output: ${tmpout}/docker.log"
  echo "Steps: ${tmpout}/steps.log"
}
(( ${+functions[compdef]} )) || autoload -Uz compinit && compinit -u
compdef _docker fancy-docker

fi
