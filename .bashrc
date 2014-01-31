# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" 

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) ;&
    rxvt-256color) color_prompt=yes;;
esac

if [ -f /usr/share/git/completion/git-prompt.sh ] && ! shopt -oq posix; then
    source /usr/share/git/completion/git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true

if [ "$color_prompt" = yes ]; then
    PS1='\[\e[0;32m\]\u\[\e[0;36m\]@\[\e[0;38m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\]\[\033[00;34m\]$(__git_ps1 " [%s]")\[\e[1;32m\] \$\[\e[m\] '
else
    PS1='\u@\h \W$(__git_ps1 " [%s]") \$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto '
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto '
    alias fgrep='fgrep --color=auto '
    alias egrep='egrep --color=auto '
fi

# some more ls aliases
alias ls='ls -lh --color '
alias la='ls -Alh --color '

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export EDITOR=vim

export PATH=~/.scripts:$PATH

function waitforport () {
    echo "Waiting for port $1""..."
    until nc -vz localhost $1; do true; done &>/dev/null
}
function redirect() {
    sudo iptables -t nat -A PREROUTING -i eth0 -p $1 --dport $2 -j REDIRECT --to-port $3
}
function ssh_with_config() {
    scp ~/.bashrc $1:/tmp/.bashrc_temp > /dev/null
    sudo rsync -avz --delete ~/.vim $1:/tmp/vim
    TERM=xterm-256color ssh -t $@ "bash --rcfile /tmp/.bashrc_temp; rm /tmp/.bashrc_temp"
}

alias playground="cat | sed '1i#include <stdio.h>\\n#include <malloc.h>\\n#include <string.h>\\nint main() { ' | sed '$ a printf(\"\n\"); }' | tcc -run -"
alias please='sudo '
alias sudo='sudo '
alias bitch='. bitch '
alias ns='netstat -lnutp'
alias ssh='TERM=xterm-256color ssh_with_config '
alias vim='vim -u /tmp/vim/.vimrc '
if [ ! -d /tmp/vim ]; then
    ln -s ~/.vim /tmp/vim
fi

touch ~/.localrc
source ~/.localrc

if [ -n `which xrdb` ]; then
    xrdb ~/.Xresources &>/dev/null
fi
