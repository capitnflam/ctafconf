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
#  Mickaël Labau mlabau-shlib_AT_megami.fr
#  Translated by capitN.flam
#

function findin
{
  function findin_display_usage
  {
    echo 'Search recursively all occurrences of a pattern in files.'
    echo ''
    echo 'Usage : findin [option] <pattern>'
    echo ''
    echo 'Description:'
    echo ''
    echo '-b    : Allows search in binary files.'
    echo '-e    : Allows to specify thaht the next argument is the pattern.'
    echo '        Allows to search for "-b" for example.'
    echo '        This option is implicit in front of an unknown argument.'
    echo '-f    : Specify the directory in which you want to search (default to ".")'
    echo '-i    : Render the search case sensitive.'
    echo '-l    : Only list files with one or more occurrences.'
    echo '-o    : When the search is done, open the files in which at least one occurence'
    echo '        was found using your favorite editor (uses $EDITOR to know)'
    echo '-r    : Replacement pattern (sed type) for found occurrences.'
    echo '-t    : Limits the search to files with the given extension.'
    echo '        Combining this option with -t and -nt is possible.'
    echo '-nt   : Ignore files with the given extension.'
    echo '        Combining this option with -t and -nt is possible.'
    echo '-w    : The pattern must match a complete word.'
    echo '        For example :'
    echo '         The pattern "debug" will not match a line containing "__debug__"'
    echo '-x    : Exclude from the search all the directories that the name matches the given pattern'
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
    echo 'Sorry, this script only works with bash and zsh.'
    echo 'But you can update it for your shell and send it to me :)'
    return 42
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
    echo 'At least one pattern is mandatory!'
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
    # Aucun fichier n'est traitÃ©, donc soit tout passe, soit rien ne passe.
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
