
deploy-message() {
    [[ "$1" = <-> ]] && { zle && {
            local alltext text IFS=$'\n' nl=$'\n'
            repeat 25; do read -u"$1" text; alltext+="${text:+$text$nl}"; done
            [[ -n "$alltext" ]] && zle -M "$alltext"
        }
        zle -F "$1"; exec {1}<&-
        return 0
    }
    local THEFD
    # The expansion is: if there is @sleep: pfx, then use what's after
    # it, otherwise substitute 0
    exec {THEFD} < <(LANG=C sleep $(( 0.01 + ${${${(M)1#@sleep:}:+${1#@sleep:}}:-0} )); print -r -- ${1:#(@msg|@sleep:*)} "${@[2,-1]}")
    zle -F "$THEFD" deploy-message
}

dbp() {
  prg="$BUFFER"
  prg="${${(s. .)prg}[1]}"
  deploy-message "$(man $prg | egrep -A1 '^SYNOPSIS' | tail -1)"
}

zle -N dbp
bindkey ^x^m dbp

