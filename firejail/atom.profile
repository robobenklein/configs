# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom
noblacklist ${HOME}/.cargo/config
noblacklist ${HOME}/.cargo/registry

#include disable-common.inc
include disable-passwdmgr.inc
#include disable-programs.inc

#caps.drop all
# net none
netfilter
#nodbus
nodvd
nogroups
nonewprivs
noroot
#nosound
notv
#nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
#shell none

private-cache
#private-dev
private-tmp

#noexec ${HOME}
#noexec /tmp
