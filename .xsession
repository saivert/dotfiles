#!/bin/sh
xrdb -merge ~/.Xresources
#source /etc/X11/xinit/xinitrc.d/*
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GPG_AGENT_INFO SSH_AUTH_SOCK
exec bash --login -c 'gnome-session'
