#!/bin/zsh

N=200000
local SOME_VARIABLE
SOME_VARIABLE="something"

defined () {
	local varname="$1"
	typeset -p "$varname" > /dev/null 2>&1
}

def () {
  [[ ! -z "${(tP)1}" ]]
}

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

echo
echo "typeset -p:"
time (repeat $N { typeset -p "SOME_VARIABLE" > /dev/null 2>&1 })

echo
echo '${+var}:'
time (repeat $N { (( ${+SOME_VARIABLE} )) })

echo
echo '[[ -v var ]]'
time (repeat $N { [[ -v SOME_VARIABLE ]] })

echo
echo 'p9k old defined'
time (repeat $N { defined SOME_VARIABLE })

echo
echo 'test def function'
time (repeat $N { def SOME_VARIABLE })

echo
echo "Variable NOT set: "
unset SOME_VARIABLE

echo
echo "typeset -p:"
time (repeat $N { typeset -p "SOME_VARIABLE" > /dev/null 2>&1 })

echo
echo '${+var}:'
time (repeat $N { (( ${+SOME_VARIABLE} )) })

echo
echo '[[ -v var ]]'
time (repeat $N { [[ -v SOME_VARIABLE ]] })

echo
echo 'p9k old defined'
time (repeat $N { defined SOME_VARIABLE })

echo
echo 'test def function'
time (repeat $N { def SOME_VARIABLE })
