source /etc/profile.d/vte.sh
source /etc/profile.d/seahorse-ssh-askpass.sh

if [ "$COLORTERM" == "gnome-terminal" ]
then
    TERM=xterm-256color
    elif [ "$COLORTERM" == "rxvt-xpm" ]
    then
        TERM=rxvt-256color
fi

red="\[\e[0;31m\]"
green="\[\e[0;32m\]"
yellow="\[\e[0;33m\]"
blue="\[\e[0;34m\]"
magenta="\[\e[0;35m\]"
cyan="\[\e[0;36m\]"
white="\[\e[0;37m\]"

if [ `id -u` -eq "0" ]; then
	root="${red}"
else
	root="${cyan}"
fi

PS1="${white}[${root}\u${white}@${yellow}\h${white}][${red}\w${white}]${white}% "


alias ls="ls --color=auto"
alias ll="ls -lA --color=auto"

alias subl=subl3

alias df="df -h"
alias route="echo IPv6 routes;ip -6 route;echo;echo IPv4 routes;ip -4 route"

export EDITOR=/usr/bin/nano
export BROWSER=/usr/bin/firefox

# cd and ls in one
cl() {
    dir=$1
    if [[ -z "$dir" ]]; then
        dir=$HOME
    fi
    if [[ -d "$dir" ]]; then
        cd "$dir"
        ls
    else
        echo "bash: cl: '$dir': Directory not found"
    fi
}

# Disable Mono and Gecko installation and .desktop creation
export WINEDLLOVERRIDES="winemenubuilder.exe,mscoree,mshtml=d"
