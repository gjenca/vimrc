let g:vimtex_quickfix_open_on_warning = 0  
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--noraise --unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
set dict=mybib.bib
map <F9> :w!<CR>:VimtexCompile<CR>
map <F3> :VimtexView<CR>

