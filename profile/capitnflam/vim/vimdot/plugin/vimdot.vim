" Adding *.dot files to be handled
"au BufNewFile,BufRead *.dot call system('dot -Txlib "' . expand("<afile>:p") . '" &')
au BufNewFile,BufRead *.dot call system('dot -Tx11 "' . expand("<afile>:p") . '" &')
