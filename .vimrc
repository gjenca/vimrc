execute pathogen#infect()
syntax on
filetype plugin indent on
set modeline
set nohlsearch
set showmatch
set nobomb
set textwidth=0
set noai
set backup
set hidden
set wildmenu
set bs=2
set dictionary+=mybib.bib
set dictionary+=keys.txt
set dictionary+=mykeys.txt
set dictionary+=~/work/awiki/pages.txt
set dictionary+=~/citacie/gejza/keys.txt
colorscheme morning
set expandtab ts=4 sw=4
map <F6> :bn
map <F5> :bp
nmap <silent> <F10> :wqa
nmap <silent> <F2> :w
imap <F6> :bn
imap <F5> :bp
imap <F10> <F10>
imap <F2> <F2>i
