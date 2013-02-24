" Color scheme compatible with both gui & terminal
colorscheme elflord

" leader key
let mapleader=";"

" Mapping F8 to toggle tag list
nnoremap <silent> <F8> :TlistToggle<CR>

" Disable visual bell
set noeb vb t_vb=

" Autoload cscope database
" http://vim.wikia.com/wiki/Autoloading_Cscope_Database
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

if has("gui_running")
" Put gvim only configuration here
" Disable visual bell
set vb t_vb=
else
" Put vim only configuration here
endif
