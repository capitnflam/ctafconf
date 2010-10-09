#!/bin/sh
## ctaftools.sh for ctafconf in /home/ctaf/gterm/gnome-terminal-2.10.0/src
##
## Made by GESTES Cedric
## Login   <ctaf42@gmail.com>
##
## Started on  Wed Oct 12 00:20:30 2005 GESTES Cedric
## Last update Sat Sep 27 21:39:51 2008 Cedric GESTES
##
##CTAFCONF
###
#PARAM: csh | sh
###

##PORTABLE SHELL COMMAND
# env_set var value
# env_unset var
# env_append var value
# env_prepend var value
# env_ifnull var value
# env_ifndef var value

# alias_set var value
# alias_unset var

# var_set var value
# var_unset var

#######################
test "x$1" = "xcsh" && goto csh_functions

#echo "Shell mode: SH"
env_set() {
  eval "$1='$2'" export "$1";
}

env_unset() {
  unset "$@"
}

env_append() {
  eval $1=\${$1:+\$$1${2:+:}}\$2 export $1;
}

env_prepend() {
  eval $1=\$2\${$1:+${2:+:}\$$1} export $1;
}

env_ifnull() {
  eval $1=\${$1:-\$2} export $1;
}

env_ifndef() {
  eval $1=\${$1-\$2} export $1;
}

alias_set() {
  alias -- "$1=$2"
}

alias_unset() {
  unalias -- "$1"
}

var_set() {
  eval $1=\${$1-\$2};
#  eval "$1=$2"
}

var_unset() {
  unset "$1"
}

null_which() {
  which $1 >/dev/null 2>/dev/null
  return $?
}

null_cmd() {
  eval $@ >/dev/null 2>/dev/null
}

return

csh_functions:
#echo "Shell mode: CSH"

alias env_set 'setenv \!:1 \!:2\'
alias env_unset 'unsetenv \!:1'
alias env_ifndef  'if (! $?\!:1) setenv \!:1 \!:2'
alias env_ifnull  'if (! $?\!:1) setenv \!:1; eval " \\
      test X != '\''X$\!:1'\'' || setenv \!:1 \!:2"'
alias env_append  'if (! $?\!:1) setenv \!:1; eval " \\
      test X != '\''X$\!:1'\'' && setenv \!:1 $\!:1\:\!:2 || setenv \!:1 \!:2"'
alias env_prepend 'if (! $?\!:1) setenv \!:1; eval " \\
      test X != '\''X$\!:1'\'' && setenv \!:1 \!:2\:$\!:1 || setenv \!:1 \!:2"'

alias alias_set 'alias'
alias alias_unset 'unalias'

alias var_set 'set \!:1=\!:2'
alias var_unset 'unset \!:1'
alias null_which 'which \!* >&/dev/null'
alias null_cmd '\!* >&/dev/null'


