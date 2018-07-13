#!/bin/zsh -i
#           ^ as an interactive shell to load p9k

zmodload zsh/zprof

N=${1:-200}
echo "testing $N times each..."
echo "system: $(uname -a)"
echo "zsh: $(zsh --version)"
echo "P9K_L: $POWERLEVEL9K_LEFT_PROMPT_ELEMENTS"
echo "P9K_R: $POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS"

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

echo
whence -va build_left_prompt
echo -e "\ntest left_prompt speed"
time repeat $N do build_left_prompt > /dev/null 2>&1 ; done

echo
whence -va build_right_prompt
echo -e '\ntest right_prompt speed'
time repeat $N do build_right_prompt > /dev/null 2>&1 ; done

echo
echo 'Zprofile report:'
zprof | head -30
