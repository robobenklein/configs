#!/bin/zsh

N=200000
local SOME_VARIABLE
SOME_VARIABLE="something"

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
