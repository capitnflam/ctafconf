#!/bin/sh
## ct-gconf.sh for ctafconf in /home/simon/.ctafconf/etc/gconf
##
## Made by
## Login   <simon@epita.fr>
##
## Started on  Thu Oct 13 04:27:37 2005
## Last update Thu Oct 13 04:34:24 2005 
##
##CTAFCONF

param=$1

if [ w$param = wdump ] ; then
#gnone-panel-bar
  gconftool-2 -dump /apps/panel > ~/.ctafconf/etc/gconf/panel
#gnome style
  gconftool-2 -dump /desktop/gnome/interface > ~/.ctafconf/etc/gconf/gnome-interface
#gnome-terminal profile
  gconftool-2 -dump /apps/gnome-terminal > ~/.ctafconf/etc/gconf/gnome-terminal
#metacity theme
  gconftool-2 -dump /apps/metacity/general > ~/.ctafconf/etc/gconf/metacity-window
fi

if [ w$param = wload ] ; then
  gconftool-2 -load=~/.ctafconf/etc/gconf/panel
  gconftool-2 -load=~/.ctafconf/etc/gconf/gnome-interface
  gconftool-2 -load=~/.ctafconf/etc/gconf/gnome-terminal
  gconftool-2 -load=~/.ctafconf/etc/gconf/metacity-window
fi
