let g:ctafconf#name = ""
let g:ctafconf#mail = ""

function! ctafconf#load_profiles()
  if has("unix")
     let s:path_sep = "/"
  else
     let s:path_sep = "\\"
  endif

  let s:ctafconf_path = expand('$HOME') . s:path_sep . ".config" . s:path_sep . "ctafconf"
  let s:profile_file = s:ctafconf_path . s:path_sep . "user-profile.sh"
  let s:lines = readfile(s:profile_file)
  let s:prof_line = ""
  for line in s:lines
    if line =~ '^var_set ctafconf_profiles'
      let s:prof_line = line
      break
    endif
  endfor
  let s:prof_str = substitute(s:prof_line, "var_set ctafconf_profiles" , "", "")
  let s:prof_str = substitute(s:prof_str, '"', "", "g")
  let s:prof_str = substitute(s:prof_str, "'", "", "g")
  let s:profiles = split(s:prof_str)
  for ct_profile in s:profiles
    let s:profile_path =  s:ctafconf_path .
                        \ s:path_sep .
                        \ "profile"  .
                        \ s:path_sep .
                        \ ct_profile .
                        \ s:path_sep .
                        \ "vim"
    call pathogen#infect(s:profile_path)
  endfor
endfunction


function! ctafconf#load_name()
  if has("unix")
     let s:path_sep = "/"
  else
     let s:path_sep = "\\"
  endif

  let s:ctafconf_path = expand('$HOME') . s:path_sep . ".config" . s:path_sep . "ctafconf"
  let s:profile_file = s:ctafconf_path . s:path_sep . "user-profile.sh"
  let s:lines = readfile(s:profile_file)
  let s:name_line = ""
  for line in s:lines
    if line =~ '^var_set ctafconf_name'
      let s:name_line = line
      break
    endif
  endfor
  let s:name_str = substitute(s:name_line, "var_set ctafconf_name" , "", "")
  let s:name_str = substitute(s:name_str, '"', "", "g")
  let s:name_str = substitute(s:name_str, "'", "", "g")
  let g:ctafconf#name = s:name_str
endfunction

function! ctafconf#load_mail()
  if has("unix")
     let s:path_sep = "/"
  else
     let s:path_sep = "\\"
  endif

  let s:ctafconf_path = expand('$HOME') . s:path_sep . ".config" . s:path_sep . "ctafconf"
  let s:profile_file = s:ctafconf_path . s:path_sep . "user-profile.sh"
  let s:lines = readfile(s:profile_file)
  let s:mail_line = ""
  for line in s:lines
    if line =~ '^var_set ctafconf_mail'
      let s:mail_line = line
      break
    endif
  endfor
  let s:mail_str = substitute(s:mail_line, "var_set ctafconf_mail" , "", "")
  let s:mail_str = substitute(s:mail_str, '"', "", "g")
  let s:mail_str = substitute(s:mail_str, "'", "", "g")
  let g:ctafconf#mail = s:mail_str
endfunction
