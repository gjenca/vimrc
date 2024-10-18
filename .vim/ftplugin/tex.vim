let g:vimtex_quickfix_open_on_warning = 0  
set dict=mybib.bib
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--noraise --unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_matchparen_enabled=0
let g:vimtex_quickfix_ignore_all_warnings = 1
let g:vimtex_quickfix_autoclose_after_keystrokes = 1
setlocal indentexpr=
map <F9> :w!<CR>:VimtexCompile<CR>
map <F3> :VimtexView<CR>
set expandtab           " enter spaces when tab is pressed
set textwidth=120       " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4
