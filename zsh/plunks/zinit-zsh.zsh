
# build requirement of yodl:
function zinit-setup-icmake () {
  zinit id-as"zsh-dep-yodl-icmake" from"gl" nocompile \
    nocompletions as"program" pick'$ZPFX/usr/bin/*' \
    atclone"cd icmake && ./icm_prepare '\$ZPFX' && ./icm_bootstrap x && ./icm_install all /" \
    atpull"%atclone" for @fbb-git/icmake
}

# docs requirement of zsh:
function zinit-setup-yodl () {
  zinit-setup-icmake

  zinit id-as"zsh-dep-yodl" from"gl" nocompile \
    nocompletions as"program" pick'$ZPFX/usr/bin/*' \
    atclone"cd yodl && sed -i 's;= \"/usr\";= \"\$ZPFX\";' INSTALL.im && sed -i '1s;/usr/bin/icmake;/usr/bin/env -S icmake;' build && ./build programs && ./build install programs '\$ZPFX'" \
        for @fbb-git/yodl
}

function zinit-setup-zsh () {
  zinit-setup-yodl

  zinit id-as"zsh" as"null" from"gh" nocompile \
    atclone'./Util/preconfig && ./configure --prefix="$ZPFX"' \
    atpull'./configure --prefix="$ZPFX"' \
    make"install" for @zsh-users/zsh
}
