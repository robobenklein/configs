
# build requirement of yodl:
function zinit-setup-icmake () {
  zinit ice nocompletions blockf nocompile \
    from"gl" id-as"zsh-dep-yodl-icmake" \
    as"program" pick"$ZPFX/usr/bin/*" \
    atclone"cd icmake && ./icm_prepare '$ZPFX' && ./icm_bootstrap x && ./icm_install all /" \
    atpull"%atclone"

  zinit load "fbb-git/icmake"
}

# docs requirement of zsh:
function zinit-setup-yodl () {
  zinit-setup-icmake

  zinit ice nocompletions blockf nocompile \
    from"gl" id-as"zsh-dep-yodl" \
    as"program" pick"$ZPFX/usr/bin/*" \
    atclone"cd yodl && sed -i 's;= \"/usr\";= \"$ZPFX\";' INSTALL.im && sed -i '1s;/usr/bin/icmake;/usr/bin/env -S icmake;' build && ./build programs && ./build install programs '$ZPFX'"

  zinit load "fbb-git/yodl"
}

function zinit-setup-zsh () {
  zinit-setup-yodl

  zinit ice nocompletions blockf nocompile \
    from"gh" id-as"zsh" \
    atclone"./Util/preconfig && ./configure --prefix='$ZPFX'" \
    atpull"./configure --prefix='$ZPFX'" \
    make"install PREFIX='$ZPFX'"

  zinit light "zsh-users/zsh"
}
