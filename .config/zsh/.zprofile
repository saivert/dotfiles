# XDG_CONFIG_HOME/zsh/.zprofile

export PATH=$HOME/.local/bin:$HOME/.cabal/bin:$PATH

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR=nano
export VISUAL=nano
export SUDO_EDITOR=rnano

export LESS=-R

export PAGER=less
export LESSHISTFILE=$XDG_CACHE_HOME/less/history

export BROWSER=chromium
export TERMINAL=termite

# LS_COLORS (or a valid TERM, which I don't have) is now required for `ls` to
# use colour.
source <(dircolors $XDG_CONFIG_HOME/terminal-colors.d/ls.enable)

# Disable Mono and Gecko installation and .desktop creation.
export WINEDLLOVERRIDES=winemenubuilder.exe=d,mscoree,mshtml=d
export WINEPREFIX=$XDG_DATA_HOME/wineprefixes/default
export WINEARCH=win32
export WINEDEBUG=-all

export SDL_AUDIODRIVER=pulse

