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
# alias_set var value
# alias_unset var

# var_set var value
# var_unset var

#######################
test "x$1" = "xcsh" && goto csh_functions

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

alias alias_set 'alias'
alias alias_unset 'unalias'

alias var_set 'set \!:1=\!:2'
alias var_unset 'unset \!:1'
alias null_which 'which \!* >&/dev/null'
alias null_cmd '\!* >&/dev/null'


