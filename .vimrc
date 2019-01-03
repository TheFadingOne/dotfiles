
"""""""""""""""""
""  KEYNDINGS  ""
"""""""""""""""""

inoremap <F12> <Esc>
inoremap jk <Esc>

"F3 for paste
set pt=<F3>

""""""""""""""""""
""   SETTINGS   ""
""""""""""""""""""

filetype plugin indent on
set textwidth=0 " (default) no breaking up of inserted text
set formatoptions+=t " automatic formatting
set fileformat=unix 
set cursorline " highlight line of cursor

set t_Co=256 "more colors

"colorscheme lucius " theme (in .vim/colors)
colorscheme nachtleben " theme (in .vim/colors)
set bg=dark
"let g:lucius_no_term_bg=1

" set language to US (not needed in most cases, produces error in others)
" only enable if vim is german by default!
"language en_US

set history=1000 " remember a lot of 'i' commands

set bs=2 " make backspace working in vim 7.3

set shiftwidth=4 " four spaces for indenting
set encoding=utf-8 
set tabstop=4 "  tab equals 4 spaces
set expandtab "  always use spaces
set ruler " show line and col (bottom)
set tm=500
syntax on
set number  " line numbers
set autoindent 
set smartindent
set scrolloff=5 " min no of lines above/below cursor

set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/ngerman

set list " show spaces with underscores
set lcs=tab:▸\ ,trail:_

" create undofiles in ~/.undodir (less clutter)
" (and create undodir first if needed)
if !isdirectory($HOME."/.undodir")
    call mkdir($HOME."/.undodir", "", 0700)
endif
set undodir=~/.undodir
set undofile
