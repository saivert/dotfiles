# XDG_CONFIG_HOME/zsh/.zshrc

parent=$(ps --no-header -o ppid -p $$ | cut -d\  -f 2 2>/dev/null)
parentname=$(ps --no-header -o command -p $parent 2>/dev/null)

if [[ "$parentname" == *"gnome-terminal"* ]];then
gtk-launch termite $*
exit
fi

# Modules.
autoload -Uz edit-command-line run-help compinit zmv
zmodload zsh/complist
compinit

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

# Shell options.
setopt autocd \
    dotglob \
    nobgnice \
    histappend \
    histverify \
    promptsubst \
    rmstarsilent \
    extendedglob \
    sharehistory \
    printexitvalue \
    histsavenodups \
    completealiases \
    histignorespace \
    numericglobsort \
    histignorespace \
    histreduceblanks \
    histignorealldups \
    interactivecomments \

READNULLCMD=$PAGER
HELPDIR=/usr/share/zsh/$ZSH_VERSION/help
HISTFILE=${XDG_CONFIG_HOME:=$HOME/.config}/zsh/.zsh_history
HISTSIZE=20000
SAVEHIST=$HISTSIZE


# Style.
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

if [ $(id -u) -eq "0" ]; then
        root="%F{red}"
else
        root="%F{cyan}"
fi

#current_btrfs_root=$(awk '{ if ($5 =="/") print $4}' /proc/self/mountinfo)

#PROMPT='%F{white}[${root}%n%F{white}@%F{yellow}%m${current_btrfs_root}%F{white}]%F{green}${branch}%f[%F{red}%~%f%F{white}]%f%# '
PROMPT='%F{white}[${root}%n%F{white}@%F{yellow}%m%F{white}]%F{green}${branch}%f[%F{red}%~%f%F{white}]%f%# '

# Functions.
# All I want is the git branch for now, vcs_info is way overkill to do this.
function get_git_branch {
    if [[ -d .git ]]; then
        read -r branch < .git/HEAD
        branch=" ${branch##*/} "
    else
        branch=""
    fi
}

# Print basic prompt to the window title.
function precmd {
    print -Pn "\e];%n %~\a"
    get_git_branch
}

# Print the current running command's name to the window title.
function preexec {
    if [[ $TERM == xterm-* ]]; then
        local cmd=${1[(wr)^(*=*|sudo|exec|ssh|-*)]}
        print -Pn "\e];$cmd:q\a"
    fi
}

# Replace vimode indicators.
function zle-line-init zle-keymap-select {
    vimode=${${KEYMAP/vicmd/c}/(main|viins)/i}
    zle reset-prompt
}

# # Keybinds.
bindkey -e

# Initialise vimode to insert mode.
vimode=i

# Remove the default 0.4s ESC delay, set it to 0.1s.
export KEYTIMEOUT=1

# Shift-tab.
bindkey $terminfo[kcbt] reverse-menu-complete

# Delete.
bindkey -M vicmd $terminfo[kdch1] vi-delete-char
bindkey          $terminfo[kdch1] delete-char

# Insert.
bindkey -M vicmd $terminfo[kich1] vi-insert
bindkey          $terminfo[kich1] overwrite-mode

# Home.
bindkey -M vicmd $terminfo[khome] vi-beginning-of-line
bindkey          $terminfo[khome] beginning-of-line

# End.
bindkey -M vicmd $terminfo[kend] vi-end-of-line
bindkey          $terminfo[kend] end-of-line

# Backspace (and <C-h>).
bindkey -M vicmd $terminfo[kbs] backward-char
bindkey          $terminfo[kbs] backward-delete-char

# Page up (and <C-b> in vicmd).
bindkey -M vicmd $terminfo[kpp] beginning-of-buffer-or-history
bindkey          $terminfo[kpp] beginning-of-buffer-or-history

# Page down (and <C-f> in vicmd).
bindkey -M vicmd $terminfo[knp] end-of-buffer-or-history
bindkey          $terminfo[knp] end-of-buffer-or-history

bindkey -M vicmd '^B' beginning-of-buffer-or-history

# Do history expansion on space.
bindkey ' ' magic-space

# Use M-w for small words.
bindkey '^[w' backward-kill-word
bindkey '^W' vi-backward-kill-word

bindkey -M vicmd '^H' backward-char
bindkey          '^H' backward-delete-char

# h and l whichwrap.
bindkey -M vicmd 'h' backward-char
bindkey -M vicmd 'l' forward-char

# Incremental undo and redo.
bindkey -M vicmd '^R' redo
bindkey -M vicmd 'u' undo

# Misc.
bindkey -M vicmd 'ga' what-cursor-position

# Open in editor.
bindkey -M vicmd 'v' edit-command-line

# History search.
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Patterned history search with zsh expansion, globbing, etc.
bindkey -M vicmd '^T' history-incremental-pattern-search-backward
bindkey          '^T' history-incremental-pattern-search-backward

# Verify search result before accepting.
bindkey -M isearch '^M' accept-search

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


# Aliases.
alias -g ...='../..'
alias -g ....='../../..'
alias rr='rm -rvI'
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias ln='ln -vi'
alias mkdir='mkdir -vp'
alias grep='grep --color=auto'
alias df='df -h'

alias chmod='chmod -c --preserve-root'
alias chown='chown -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'

alias ls='ls --color=auto --group-directories-first -AhXF'
alias ll='ls --color=auto --group-directories-first -AlhXF'

alias dmesg=dmesg -exL
#alias weechat="exec dtach -A $XDG_RUNTIME_DIR/weechat env LD_PRELOAD=$HOME/.local/lib/libwcwidth.so weechat"
#alias mutt="exec dtach -A $XDG_RUNTIME_DIR/mutt mutt -F $XDG_CONFIG_HOME/mutt/muttrc"
#alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

alias i="curl -F 'f:1=<-' ix.io"
alias s="curl -F 'sprunge=<-' sprunge.us"
alias p="curl -F 'c=@-' https://ptpb.pw"
alias xc='xclip -o | i'

# XXX force XDG_CONFIG_HOME where possible.
alias ncmpcpp="ncmpcpp -c $XDG_CONFIG_HOME/ncmpcpp/ncmpcpp.conf"
alias aria2c="aria2c --dht-file-path $XDG_CACHE_HOME/aria2/dht.dat"
alias gdb="gdb -nh -x $XDG_CONFIG_HOME/gdb/init"

# Bash-like help.
unalias run-help
alias help='run-help'

# Directory hashes.
if [[ -d $HOME/downloads ]]; then
    for d in $HOME/Downloads/*(/); do
        hash -d ${d##*/}=$d
    done
fi

# Enable C-S-t in (vte) termite which opens a new terminal in the same working
# directory.
if [[ -n $VTE_VERSION ]]; then
    source /etc/profile.d/vte.sh
    __vte_prompt_command
fi

function cls {
  clear
  date
  tput cup $(( $(tput lines) - 1)) 0
  print -n '\E[3J'
}

# cd and ls in one
function cl {
    dir=$1
    if [[ -z "$dir" ]]; then
        dir=$HOME
    fi
    if [[ -d "$dir" ]]; then
        cd "$dir"
        ls
    else
        echo "zsh: cl: '$dir': Directory not found"
    fi
}
