#!/bin/sh
##
## openf.sys.fun
## Login : <capitnflam@Milhouse>
## Started on  Thu Apr  1 01:21:25 2010 capitN.flam
## $Id$
##
## Author(s):
##  - capitN.flam <capitnflam@gmail.com>
##
## Copyright (C) 2010 capitN.flam
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

function openf() {
  function openf_display_usage() {
    echo 'usage: openf [-r <root>] [-x <dir>] [-l] [+i] [-i] [-ed <editor>] [-e] <pattern>'
    echo ''
    echo 'Description:'
    echo ' -r <root>    Specify where is the root of the search.'
    echo '              (Optional, defaults to ".", multiple allowed)'
    echo ' -x <dir>     Specify a directory to exclude from the search.'
    echo '              (Optional, multiple allowed, can be a pattern, always case sensitive)'
    echo ' -l           Only list the files without opening them.'
    echo '              (Optional)'
    echo ' +i           Specify that the search should be case insensitive.'
    echo '              (Optional)'
    echo ' -i           Specify that the search should be case sensitive.'
    echo '              (Optional, default behavior)'
    echo ' -ed <editor> Specify the editor to use.'
    echo '              (Optional, default to $VISUAL or $EDITOR)'
    echo ' -e           Specify that the next argument is a search pattern.'
    echo '              (Optional, multiple allowed)'
    echo ' -ne          Specify that the next argument is a search pattern to exclude matching names.'
    echo '              (Optional, multiple allowed)'
    echo ' <pattern>    Specify a search pattern.'
    echo '              (Required, multiple allowed)'
  }

  local roots=''
  local dir_forbidden='-name .svn -o -name .cvs -o -name .subversion -o -name .git'
  local only_list='0'
  local case_sensitive=''
  local editor=''
  local xpatterns=''
  local patterns=''

  local cmd=''
  local files=''

  while [ "$#" -ne 0 ]; do
    if [ "$1" = '-r' ]; then
      roots="$roots $2"
      shift 2
    elif [ "$1" = '-d' ]; then
      if ! [ -z "$dir_fobidden" ]; then
	dir_forbidden="$dir_forbidden -o"
      fi
      dir_forbidden="$dir_forbidden -name '$2'"
      shift 2
    elif [ "$1" = '-l' ]; then
      only_list=''
      shift
    elif [ "$1" = '-i' ]; then
      case_sensitive=''
      shift
    elif [ "$1" = '+i' ]; then
      case_sensitive='i'
      shift
    elif [ "$1" = '-ed' ]; then
      editor="$2"
      shift 2
    elif [ "$1" = '-e' ]; then
      if ! [ -z "$patterns" ]; then
        patterns="$patterns -o"
      fi
      patterns="$patterns -name '$2'"
      shift 2
    elif [ "$1" = '-ne' ]; then
      xpatterns="$xpatterns ! -name '$2' -a"
      shift 2
    else
      if ! [ -z "$patterns" ]; then
        patterns="$patterns -o"
      fi
      patterns="$patterns -name '$1'"
      shift
    fi
  done

  if [ "$only_list" = '0' ]; then
    if [ -z "$editor" ]; then
      if [ -z "$VISUAL" ]; then
        if [ -z "$EDITOR" ]; then
          echo 'ERROR: no default editor defined in $VISUAL or $EDITOR'
          return 1
        else
          editor="$EDITOR"
        fi
      else
        editor="$VISUAL"
      fi
    fi
  fi

  if [ -z "$roots" ]; then
    roots='.'
  fi

  if [ -z "$patterns" ]; then
    echo 'ERROR: pattern required'
    openf_display_usage
    return 2
  fi

  patterns=$(echo -n $patterns | sed -e "s/ -name / -${case_sensitive}name /g")

  cmd="find $roots \( \( $dir_forbidden \) -a -type d -prune -o $patterns \) -a $xpatterns -type f -print$only_list"
  files=$(eval "$cmd")

  if ! [ -z "$files" ]; then
    if [ -z "$only_list" ]; then
      echo "$files"
    else
      echo -n "$files" | xargs --null $editor
    fi
  fi
}
