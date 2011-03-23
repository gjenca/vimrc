set term=$TERM
set mouse=a
set modeline
set nohlsearch
let loaded_matchparen=1
set showmatch
set nobomb
if &term=~"xterm"
if has("terminfo")
  set t_Co=16
  set t_Sf=<Esc>[3%p1%dm
  set t_Sb=<Esc>[4%p1%dm
else
  set t_Co=16
  set t_Sf=<Esc>[3%dm
  set t_Sb=<Esc>[4%dm
endif
endif
syn on
set backup
set writebackup
set hidden
set wildmenu
set bs=2
filetype on
set dictionary+=mybib.bib
set incsearch
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 
let Tlist_Ctags_Cmd='/usr/bin/ctags'
highlight Pmenusel ctermbg=7 ctermfg=12 guibg=White guifg=LightBlue 
highlight Pmenu ctermbg=12 guibg=LightBlue

if executable("darcs")
	let g:darcs_have_darcs=1
	let g:darcs_patch_name=system("echo -n `date +%F`-`whoami`-`hostname -f`")
	let g:darcs_dontrecord=system("darcs changes | grep "."'".g:darcs_patch_name."'")
else
	let g:darcs_have_darcs=0
endif

function Darcs_author()
	return system("echo -n `whoami`@`hostname -f`")
endfunction

function Darcs_record()
	if g:darcs_have_darcs == 1
		if g:darcs_dontrecord =~ '.'
			echo system("yes | darcs amend-record -a >/dev/null")
		else
			echo system("darcs record -a -A ".Darcs_author()." -m ".g:darcs_patch_name." >/dev/null")
		endif
	endif
endfunction


filetype plugin on
autocmd FileType perl call FT_pl()
autocmd FileType python call FT_py()
autocmd FileType ruby call FT_ruby()
autocmd FileType pyrex call FT_py()
autocmd FileType tex call FT_tex()
autocmd FileType c call FT_C()
autocmd FileType mail call FT_mail()
" Darcs_record sa vola vzdy
autocmd VimLeave * call Darcs_record()


map <F6> :bn
map <F5> :bp
nmap <silent> <F10> :wqa
nmap <silent> <F2> :w
imap <F6> :bn
imap <F5> :bp
imap <F10> <F10>
imap <F2> <F2>i

function FindBegin() 

	let i=line(".")-1
	let cnt=0
	while i>=1
		let str=getline(i)
		if (str=~'end{.*}')
			 let cnt=cnt+1
		endif
		if (str=~'begin{.*}')
			 let cnt=cnt-1
		endif
		if (cnt < 0)
			return i
		endif
		let i=i-1
	endwhile
	return -1;
endfunction

function PutEnd()

	let beg=FindBegin()
	if (beg>0)
		let @u=getline(beg)
		exec "normal \"uP"
		exec ".s/begin{\\([^}]*\\)}.*/end{\\1}/"
	endif
endfunction

function FT_C()
map <F9> :wa
map <F3> :wa
endfunction


function FT_pl()
nmap <F9> :wa
imap <F9> :wa

endfunction

function FT_py()
set ai 
set ts=4 
set sts=4 
set et 
set sw=4
set omnifunc=pythoncomplete#Complete
nmap <F9> :wa
imap <F9> :wa

endfunction

function Mail_foldtext()

	 let i=v:foldstart
	 while i <= v:foldend
	 	let str=getline(i)
		if str =~'Subject:'
			let str = substitute(str,'Subject: *\[[^\]].*\] *','Subject: ','')
			return v:folddashes . str
		endif
		let i=i+1
	 endwhile
	 return v:folddashes . 'Subject: None'
endfunction
			

function Mail_foldexpr(lnum)
	
	if getline(a:lnum+1)=~'^From '
		return '<1'
	else
		return '1'
	endif
endfunction

function TeX_foldexpr(lnum)
	
	if getline(a:lnum+1)=~'\\section'
		return '<1'
	else
		return '1'
	endif
endfunction

function InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

function FT_ruby()
set ai 
set ts=4 
set sts=4 
set et 
set sw=4
nmap <F9> :wa
imap <F9> :wa
endfunction

function FT_mail()

set foldexpr=Mail_foldexpr(v:lnum)
set foldmethod=expr
set foldlevel=1
set foldtext=Mail_foldtext()
endfunction

function FT_tex()

set foldexpr=TeX_foldexpr(v:lnum)
set foldmethod=expr
set foldlevel=1
set iskeyword=134,@,48-57,_,192-255,:
set complete=.,w,b,u,t,i,k

let g:dviview='xdvi'
let g:psview='gv'

map [[ ?\\section
map ]] /\\section

let i=1
let g:amstex=0
while i<20
	if getline(i)=~"amsppt"
		let g:amstex=1
		break
	endif
	let i=i+1
endwhile	

let i=1
let g:beamer=0
while i<20
	if getline(i)=~"documentclass.*beamer"
		let g:beamer=1
		break
	endif
	let i=i+1
endwhile	

if g:amstex==0
if g:beamer==0
		setlocal makeprg=echo\ latex\ %\;latex\ -src-specials\ --file-line-error\ --interaction\ nonstopmode\ %\ \\\|\ grep\ '^[^:]*:[0123456789]*:'
else
		setlocal makeprg=echo\ pdflatex\ %\;pdflatex\ -src-specials\ --file-line-error\ --interaction\ nonstopmode\ %\ \\\|\ grep\ '^[^:]*:[0123456789]*:'

endif
else
		setlocal makeprg=echo\ tex\ %\;tex\ -src-specials\ --file-line-error\ --interaction\ nonstopmode\ %\ \\\|\ grep\ '^[^:]*:[0123456789]*:'
endif

set errorformat=%f:%l:%m

nnoremap <Tab><F3> :execute "!cd ".expand("%:p:h").";".g:psview." ".expand("%:p:r").".ps &"
if g:beamer==1
	nnoremap <buffer> <F3> :execute "!cd ".expand("%:p:h").";"."xpdf ".expand("%:p:r").".pdf &"
else
	nnoremap <buffer> <F3> :execute "!cd ".expand("%:p:h").";".g:dviview." -watchfile 0.5 -s 5 -sourceposition ".line(".")."\\ ".expand("%:p:t")." ".expand("%:p:r")." &"
endif	
map <F9> <F2>:make<CR>
imap <F9> <F9>
inoremap <C-E> :call PutEnd()
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

syn sync clear
syn sync fromstart

endfunction

				