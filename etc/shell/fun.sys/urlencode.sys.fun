#!/bin/sh
##
## urlencode.sys.fun
## Login : <capitnflam@Milhouse>
## Started on  Tue Mar 17 11:02:25 2013 capitN.flam
## $Id$
##
## Author(s):
##  - capitN.flam <capitnflam@gmail.com>
##
## Copyright (C) 2015 capitN.flam
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

function urlencode() {
    function urlencode_display_usage() {
        echo 'usage: urlencode <string>'
        echo ''
        echo 'Description:'
        echo ' <string>     The string to encode (Required)'
    }
    local str=''

    if [ "$#" -lt 1 ]; then
        echo 'ERROR: string required'
        urlencode_display_usage
        return 2
    fi
    str="$@"
    echo -n ${str} | sed -e 's/%/%25/g' -e 's/!/%21/g' -e 's/#/%23/g' \
                         -e 's/\$/%26/g' -e "s/'/%27/g" -e 's/(/%28/g' \
                         -e 's/)/%29/g' -e 's/\*/%2A/g' -e 's/\+/%2B/g' \
                         -e 's/,/%2C/g' -e 's!/!%2F!g' -e 's/:/%3A/g' \
                         -e 's/;/%3B/g' -e 's/=/%3D/g' -e 's/\?/%3F/g' \
                         -e 's/@/%40/g' -e 's/\[/%5B/g' -e 's/\]/%5D/g' \
                         -e 's/ /%20/g'
}

function urldecode() {
    function urldecode_display_usage() {
        echo 'usage: urldecode <string>'
        echo ''
        echo 'Description:'
        echo ' <string>     The string to decode (Required)'
    }
    local str=''

    if [ "$#" -lt 1 ]; then
        echo 'ERROR: string required'
        urldecode_display_usage
        return 2
    fi
    str="$@"

    echo -n $(echo -n ${str} | sed -e 's/%\(..\)/\\x\1/g')
}

alias my_urlencode=urlencode
alias my_urldecode=urldecode
