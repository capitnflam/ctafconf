#!/bin/sh
##
## set_title.sys.fun
## Login : <capitnflam@Milhouse>
## Started on  Mon Feb 25 18:25:25 2013 capitN.flam
## $Id$
##
## Author(s):
##  - capitN.flam <capitnflam@gmail.com>
##
## Copyright (C) 2013 capitN.flam
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

function set_title() {
    function set_title_display_usage() {
        echo 'usage: set_title <title>'
        echo ''
        echo 'Description:'
        echo ' <title>      Specify a title to set'
        echo '              (Required)'
    }
    local title=''

    if [ "$#" -lt 1 ]; then
        echo 'ERROR: title required'
        set_title_display_usage
        return 2
    fi
    title="$@"
    echo -ne '\e]2;'${title}'\007\e]1;\007'
}
alias my_set_title=set_title
