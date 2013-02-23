if !exists('loaded_snippet') || &cp
    finish
endif

Snippet . self.<{}>

Snippet ifn if __name__ == "__main__":<CR><{}>

Snippet class class <{}>:<CR><TAB>"""<CR><{}><CR>"""<CR><{}>

Snippet _init def __init__(self<{}>):<CR><TAB><{}>

Snippet _str  def __str__(self):<CR><TAB><{}>

Snippet pdb import pdb; pdb.set_trace()
Snippet ipdb import ipdb; ipdb.set_trace()

