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
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -C'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom prompt
function parse_git_branch() { # Git Branch
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    echo "[${BRANCH}]"
  else
    echo ""
  fi
}

function parse_git_tag() { # Git Tag
  TAG=`git describe --abbrev=0 --tags 2> /dev/null`
  if [ ! "${TAG}" == "" ]
  then
    echo "[${TAG}]"
  else
    echo ""
  fi
}

# PS1 Line
PS1="\[\e[00;96m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[0;93m\]\`parse_git_branch\`\[\e[m\]\[\e[0m\]\[\e[0;38m\]\`parse_git_tag\`\[\e[m\]\[\e[00;34m\][\w]\[\e[0m\]\n\[\e[00;92m\]bash> \[\e[00;38m\]"


#git autocomplete
if [ -f /etc/bash_completion.d/git ]; then 
	. /etc/bash_completion.d/git
fi

# General allias
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ll='ls -lAFh'
alias less='less -FSRc'
alias nano='nano -W'

alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# GIT allias
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gb='git branch'
alias gl='git log'
alias gco='git checkout'
alias gam='git commit --amend --no-edit'

# go folder back
alias ..='cd ..'

alias ping='ping -c 5'

# Set title 
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}\007"'

alias i3cheatsheet='egrep ^bind ~/.config/i3/config | cut -d '\'' '\'' -f 2- | sed '\''s/ /\t/'\'' | column -ts $'\''\t'\'' | pr -2 -w 145 -t | less'

# File permission alias
alias perm='stat --printf "%a %n \n "'

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules"

# Local bin path
PATH="$HOME/.local/bin:$PATH"

# dont show GUI password prompt
unset SSH_ASKPASS


# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# Django completion
_django_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                 DJANGO_AUTO_COMPLETE=1 $1 ) )
}
complete -F _django_completion -o default django-admin.py manage.py django-admin


# History suggestions on 'arrow up' when typing command.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias cpu-normal='sudo cpupower frequency-set --max=3000mhz'
alias cpu-low='sudo cpupower frequency-set --max=2400mhz'

alias vpn-start='sudo systemctl start openvpn@client'
alias vpn-stop='sudo systemctl stop openvpn@client'

alias venv='python3 -m venv env; . env/bin/activate'
alias activate='. env/bin/activate'

# Postgresql helper aliases and functions 
alias start-postgresql='sudo systemctl start postgresql'


# RabbitMQ helper aliases and functions 
alias start-rabbitmq='sudo systemctl start rabbitmq-server'

create-rabbitmq-vhost () {
  if [ -z "$1" ] 
    then
      echo "No vhost supplied"
      return 1
  fi
  sudo systemctl start rabbitmq-server;
  sudo rabbitmqctl add_vhost $1;
  sudo rabbitmqctl set_permissions -p $1 guest ".*" ".*" ".";
  echo amqp://guest:guest@localhost:5672/$1;
}
