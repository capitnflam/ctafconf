#! /bin/sh
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
#  Micka�l Labau mlabau-shlib_AT_megami.fr
#

function findin
{
  function findin_display_usage
  {
    echo "Permet de rechercher récursivement toutes les occurences d'un motif dans les fichiers d'une arborescence."
    echo ''
    echo 'Usage : findin [option] <motif>'
    echo ''
    echo 'Description:'
    echo ''
    echo '-b    : Autorise la recherche dans les fichiers binaires.'
    echo '-e    : Permet de spécifier que le prochaine argument est le motif.'
    echo '        Cela permet de rechercher "-b" par exemple.'
    echo '        Cette option est implicite devant un argument non reconnu.'
    echo '-f    : Spécifie le répertoire dans lequel chercher (défini par défaut à ".").'
    echo '-i    : Rend la recherche sensible à la casse.'
    echo '-l    : Liste simplement les fichiers contenant au moins une occurence.'
    echo '-o    : Lorsque la recherche est terminée, ouvre les fichiers dans lesquels'
    echo '        une ou des occurences ont été trouvé, dans votre editeur favori.'
    echo '-r    : Motif de remplacement (de type sed) pour les occurences trouvées.'
    echo "-t    : Limite la recherche au fichier dont l'extension est celle spécifiée."
    echo '        Cette extension est cumulable avec les options -t et -nt.'
    echo "-nt   : Ignore, lors de la recherche, les fichiers dont l'extension est celle"
    echo '        spécifiée. Cette extension est cumulable avec les options -t et -nt.'
    echo '-w    : Le motif de recherche doit matcher un mot complet.'
    echo '        Par exemple :'
    echo '         Le motif "debug" ne matchera une ligne contenant "__debug__".'
    echo '-x    : Exclure de la recherche tous les dossiers dont les noms sont celui'
    echo '        specifié.'
  }

  if [ -z "$SHELL_NAME" ]; then
    SHELL_NAME=$(ps | grep "$$")
		# on Ubunu 9.10 "ps" command adds a space before the result so :
		# $(ps | grep "$$" | tr -s ' ' | cut -f4 -d' ')
		# cannot work.
    if echo "$SHELL_NAME" | grep -q bash; then
      SHELL_NAME=bash
    elif echo "$SHELL_NAME" | grep -q zsh; then
      SHELL_NAME=zsh
    fi
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
  local forbidden="! -name '*.*~'"
  forbidden="$forbidden -a ! -name '*.#*#'"
  local case_sensitive='-i'
  local allow_binary_files=0
  local pattern_is_word=
  local only_list=0
  local open_results=0
  unset replace_pattern
  local grep_color=''
  while [ "$#" -ne 0 ]; do
    if [ "$1" = '-b' ]; then
      allow_binary_files=1
      shift
    elif [ "$1" = '-e' ]; then
      pattern="$2"
      shift 2
    elif [ "$1" = '-f' ]; then
      location=$2
      shift 2
    elif [ "$1" = '-i' ]; then
      case_sensitive=''
      shift
    elif [ "$1" = '-l' ]; then
      only_list=1
      shift
    elif [ "$1" = '-o' ]; then
      open_results=1
      shift
    elif [ "$1" = '-r' ]; then
      local replace_pattern="$2"
      replace_pattern=${replace_pattern//\//\\\/}
      grep_color='32;40'
      shift 2
    elif [ "$1" = '-t' ]; then
      if ! [ -z "$ext_allowed" ]; then
	ext_allowed="$ext_allowed -o"
      fi
      ext_allowed="$ext_allowed -name '*.$2'"
      shift 2
    elif [ "$1" = '-nt' ]; then
      if ! [ -z "$forbidden" ]; then
	forbidden="$forbidden -a"
      fi
      forbidden="$forbidden ! -name '*.$2'"
      shift 2
    elif [ "$1" = '-w' ]; then
      pattern_is_word='-w'
      shift
    elif [ "$1" = '-x' ]; then
      if ! [ -z "$forbidden" ]; then
	forbidden="$forbidden -a"
      fi
      forbidden="$forbidden ! -name '$2'"
      shift 2
    else # default is like "-e"
      pattern="$1"
      shift
    fi
  done

  if [ -z "$pattern" ]; then
    echo 'Nécessite un pattern !'
    findin_display_usage
    return 1
  fi
  local sed_pattern=${pattern//\//\\\/}
  if ! [ -z "$pattern_is_word" ]; then
    sed_pattern="\b$sed_pattern\b"
  fi

  local files="find $location \( -name .svn -o -name .cvs \) -a -type d -prune -o"
  if ! [ -z "$ext_allowed" ]; then
    files="$files \( $ext_allowed \)"
    if ! [ -z "$forbidden" ]; then
      files="$files -a $forbidden"
    fi
  elif ! [ -z "$forbidden" ]; then
    files="$files $forbidden"
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

  if ! [ -z "$case_sensitive" ]; then
    local sed_i="I"
  fi

  local results=
  local len=
  function process_file()
  {
    if [ "${1%.a}" != "$1" -o "${1%.so}" != "$1" ]; then
      if [ $allow_binary_files = 1 ]; then
	out=$(nm "$1" | GREP_COLOR="$grep_color" grep $pattern_is_word $case_sensitive -n --color=always -e "$pattern")
      else
	out="concord"
      fi
    else
      out=$(GREP_COLOR="$grep_color" grep $pattern_is_word $case_sensitive -n --color=always  -e "$pattern" "$1")
    fi

    if [ "$?" -eq 0 ]; then
			# Les fichiers binaires affichent "concorde" ou "concordant" donc ils sont normalement affiches.
			# On evite ceci car ces fichiers ne nous interessent pas.
      if [ $allow_binary_files = 1 ] || ! echo "$out" | grep -i -q 'concord'; then
	results="$results'$1' "
	if [ $only_list = 1 ]; then
	  echo "$1";
	else
	  len=$(($COLUMNS - ${#1} - 2))
	  echo "$color$(substr padding 0 $(($len/2))) $1 $(substr padding 0 $(($len-$len/2)))$normal"
	  echo "$out"
	fi
	if [ "$replace_pattern" = "${replace_pattern-no_set}" ]; then
	  echo sed -i -e "s/$sed_pattern/$replace_pattern/g$sed_i" "$1"
	  sed -i -e "s/$sed_pattern/$replace_pattern/g$sed_i" "$1"
	fi
      fi
    fi
  }

  if [ $open_results = 0 ]; then
		# Cette boucle permet de gérer les noms de fichier avec des espaces
		# mais est executée dans un subshell => donc pas d'effet de bord possible sur les variables
    echo "$files" | while read -r i; do
      process_file "$file"
    done
  else
    if ! tempfile 1>&2 > /dev/null; then
      function tempfile()
      {
	local prefix="simulated_tempfile"
	if [ "$1" = "-p" ]; then
	  prefix="$2"
	fi
	local p="/tmp"
	local file=
	while true; do
	  file=$p/${prefix}__$RANDOM
	  [[ -e "$file" ]] || break
	done
	echo "$file"
      }
    fi
    function tempfifo()
    {
      local file=$(tempfile "$@")
      mkfifo "$file" && builtin echo -n "$file"
    }

    local fifo=$(tempfifo -p "$(basename -- $0)")
    echo -n "$files" > "$fifo"

		# HACK :
		# Le read de la boucle suivante (pas celle ci dessous, la suivante)
		# peut provoquer un "Interrupted function call" a cause du fifo et
		# Lorsque c'est le cas, la boucle peut etre completement skippée !
		# Aucun fichier n'est traité, donc soit tout passe, soit rien ne passe.
		# "-t5" semble ameliorer les choses mais pas completement
		# on utilise la boucle ci-dessous pour etre sur que read a fonctionné.
    local read_keeps_trying=1
    while (( $read_keeps_trying )); do

		# l'utilisation de read permet de gerer les noms de fichier
		# avec des espaces sans changer l'IFS.
		# L'utilisation du fifo permet au code du while d'avoir des effet de bords
		# Dans le cas présent, modifier les variables results.
		# Code de boucle precedant qui ne necessite pas de hack mais ne permet pas
		# les effets de bord :
		# echo "$files" | while read -r file; do
      while read -r -t5 file; do read_keeps_trying=0
				# Au cas ou stdin est vide on a quand meme une ligne
	[[ "$file" ]] || continue
	process_file "$file"
      done < "$fifo"
    done # fermeture du hack

		# Il ne restent plus qu'a lire results
    $EDITOR $results
  fi
}
