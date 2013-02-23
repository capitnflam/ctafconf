" Remove menu bar from GUI
let did_install_default_menus = 1

" Remove trailing whitespaces when saving:
autocmd bufwritepre * :%s/\s\+$//e

" I've always find it weird that it was not this way ...
set splitbelow

" More logical, but not vi-compatible
noremap Y y$

" Tabulations
set shiftwidth=2
set expandtab
set smarttab
set smartindent
set tabstop=4



" Status line (requires VimBuddy plugin to be present)
set statusline=%{VimBuddy()}\ [%n]\ %<%f\ %{fugitive#statusline()}%h%m%r%=%-14.(%l,%c%V%)\ %P\ %a


""
" Few keybindings

" 'cd' towards the dir in which the current file is edited
" but only change the path for the current window
map ,cd :lcd %:h<CR>

" I prefer , for mapleader rather than \
let mapleader=","

" Open files located in the same dir in with the current file is edited
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Navigate through the buffer's list with alt+up, alt+down
nnoremap <M-Down>  :bp<CR>
nnoremap <M-Up>    :bn<CR>

" Man page for work under cursor
nnoremap K :Man <cword> <CR>
" Spell check
cmap spc setlocal spell spelllang=

" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp

" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" Call chmod +x on a file when necessary:
nmap <leader>! :call FixSheBang(@%) <CR>


" Remember where I was and what I searched
set viminfo='20,\"50

""
" Misc

" I always make mistakes in these words
abbreviate swith switch
abbreviate wich which
abbreviate lauch launch
abbreviate MSCV MSVC

