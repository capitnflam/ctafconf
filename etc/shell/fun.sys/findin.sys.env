#!/bin/sh
# sh_lib.sh -- bash library
# version 1.0.0, October 26th, 2009
#
#  Copyright (C) 2009-2018 Mickael Labau
#
#  This software is provided 'as-is', without any express or implied
#  warranty.  In no event will the authors be held liable for any damages
#  arising from the use of this software.
#
#  Permission is granted to anyone to use this software for any purpose,
#  including commercial applications, and to alter it and redistribute it
#  freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you must not
#     claim that you wrote the original software. If you use this software
#     in a product, an acknowledgment in the product documentation would be
#     appreciated but is not required.
#  2. Altered source versions must be plainly marked as such, and must not be
#     misrepresented as being the original software.
#  3. This notice may not be removed or altered from any source distribution.
#
#  Mickaël Labau mlabau-shlib@megami.fr
#

function findin
{
  function findin_display_usage
  {
    echo 'usage : findin  [ -f folder_location ] [ -t file_extension ] [ -r replace_pattern(sed) ] [-l] [-b] [-[n]t extension] [-e] pattern'
    echo ''
    echo 'Description:'
    echo ''
    echo '-f	: Spécifie le répertoire dans lequel chercher (par défaut il vaut ".").'
    echo '-t	: Limite la recherche au fichier dont l''extension est celle spécifiée.'
    echo '		Cette extension est cumulable avec les options -t et -nt.'
    echo '-nt   : Supprime de la recherche les fichiers dont l''extension est celle spécifiée.'
    echo '		Cette extension est cumulable avec les options -t et -nt.'
    echo '-r	: Pattern de remplacement (de type sed) pour les occurences trouvées.'
    echo '-l	: Liste simplement les fichiers contenant au moins une occurence.'
    echo '-b	: Autorise la recherche dans les fichiers binaires.'
    echo '-i	: Rend la recherche sensible à la casse.'
    echo '-e	: Permet de spécifier que le prochain argument est le pattern.'
    echo '		Cela permet de rechercher "-b" par exemple.'
    echo '-w	: Le pattern de recherche doit matcher un mot complet.'
    echo '		Par exemple :'
    echo '		   Le pattern "debug" ne matchera une ligne contenant "__debug__".'
  }

  local sh_name_tmp=''
  if [ -z "$SHELL_NAME" ]; then
    sh_name_tmp=$(ps | grep "$$" | tr -s ' ')
    sh_name_tmp=${sh_name_tmp# }
    SHELL_NAME=$(echo $sh_name_tmp | cut -f4 -d' ')

#     if echo "$SHELL_NAME" | grep bash; then
#       SHELL_NAME=bash
#     elif echo "$SHELL_NAME" | grep zsh; then
#       SHELL_NAME=zsh
#     fi
  fi

  if  ! [ $SHELL_NAME = bash ] &&
    ! [ $SHELL_NAME = zsh ]; then
    echo "Désolé ce script ne fonctionne que sous bash ou zsh."
    echo "Mais vous pouvez le mettre à jour pour votre shell et me le renvoyer :)"
    return
  fi

  if [ $SHELL_NAME = bash ]; then
    # args: name, index, count
    substr() { echo -n ${!1: $2:$3}; }
  elif [ $SHELL_NAME = zsh ]; then
    substr() { eval print -R -n "\"\$$1[$2,$(($2+$3-1))]\""; }
  fi

  local location='.'
  local pattern=''
  local ext_allowed=''
  local ext_forbidden="! -name '*.*~'"
  ext_forbidden="$ext_forbidden -a ! -name '*.#*#'"
  local case_sensitive='-i'
  local allow_binary_files=0
  local pattern_is_word=
  local only_list=0
  unset replace_pattern
  local grep_color=''
  while [ "$#" -ne 0 ]; do
    if [ "$1" = '-f' ]; then
      location=$2
      shift 2
    elif [ "$1" = '-t' ]; then
      if ! [ -z "$ext_allowed" ]; then
	ext_allowed="$ext_allowed -o"
      fi
      ext_allowed="$ext_allowed -name '*.$2'"
      shift 2
    elif [ "$1" = '-nt' ]; then
      if ! [ -z "$ext_forbidden" ]; then
	ext_forbidden="$ext_forbidden -a"
      fi
      ext_forbidden="$ext_forbidden ! -name '*.$2'"
      shift 2
    elif [ "$1" = '-r' ]; then
      local replace_pattern="$2"
      replace_pattern=${replace_pattern//\//\\\/}
      grep_color='32;40'
      shift 2
    elif [ "$1" = '-b' ]; then
      allow_binary_files=1
      shift
    elif [ "$1" = '-l' ]; then
      only_list=1
      shift
    elif [ "$1" = '-i' ]; then
      case_sensitive=''
      shift
    elif [ "$1" = '-w' ]; then
      pattern_is_word='-w'
      shift
    elif [ "$1" = '-e' ]; then
      pattern="$2"
      shift 2
    else
      pattern="$1"
      shift
    fi
  done

  local sed_pattern=${pattern//\//\\\/}
  if [ -z "$pattern" ]; then
    echo 'Nécessite un pattern !'
    findin_display_usage
    return 1
  fi

  local files="find $location \( -name .svn -o -name .cvs \) -a -type d -prune -o"
  if ! [ -z "$ext_allowed" ]; then
    files="$files \( $ext_allowed \)"
    if ! [ -z "$ext_forbidden" ]; then
      files="$files -a $ext_forbidden"
    fi
  elif ! [ -z "$ext_forbidden" ]; then
    files="$files $ext_forbidden"
  else
    files="$files -o"
  fi
  files="$files -print"
  files=$(eval "$files")

  local i=''
  local color=$'\033[4;30;47m'
  local normal="$(tput sgr0)"
  local padding="="
  for ((i=0; i<8; ++i)); do
    padding="$padding$padding"
  done

  local len=
  # Cette boucle permet de gérer les noms de fichier avec des espaces
  # mais est executée dans un subshell => donc pas d'effet de bord possible sur les variables
  echo "$files" | while read -r file; do
    if [ "${file%.a}" != "$file" -o "${file%.so}" != "$file" ]; then
      if [ $allow_binary_files = 1 ]; then
	out=$(nm $file | GREP_COLOR="$grep_color" grep $pattern_is_word $case_sensitive -n --color=always -e "$pattern")
      else
	out="concord"
      fi
    else
      out=$(GREP_COLOR="$grep_color" grep $pattern_is_word $case_sensitive -n --color=always  -e "$pattern" "$file")
    fi

    if [ "$?" -eq 0 ]; then
      # Les fichiers binaires affichent "concorde" ou "concordant" donc ils sont normalement affiches.
      # On evite ceci car ces fichiers ne nous interessent pas.
      if [ $allow_binary_files = 1 ] || ! echo "$out" | grep -i -q 'concord'; then
	if [ $only_list = 1 ]; then
	  echo "$file";
	else
	  len=$(($COLUMNS - ${#file} - 2))
	  echo "$color$(substr padding 0 $(($len/2))) $file $(substr padding 0 $(($len-$len/2)))$normal"
	  echo "$out"
	fi
	if [ "$replace_pattern" = "${replace_pattern-no_set}" ]; then
	  sed -i -e "s/$sed_pattern/$replace_pattern/g" "$file"
	fi
      fi
    fi
  done
}
