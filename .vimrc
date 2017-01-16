set term=$TERM
set mouse=a
set modeline
set nohlsearch
let loaded_matchparen=1
set showmatch
set nobomb
set guifont=Monospace\ 14
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
set bg=dark
set backup
set writebackup
set hidden
set wildmenu
set bs=2
filetype on
set dictionary+=mybib.bib
set dictionary+=keys.txt
set dictionary+=mykeys.txt
set fileencodings=utf-8

set incsearch


highlight Pmenusel ctermbg=7 ctermfg=12 guibg=White guifg=LightBlue 
highlight Pmenu ctermbg=12 guibg=LightBlue

filetype plugin on
autocmd FileType perl call FT_pl()
autocmd FileType python call FT_py()
autocmd FileType tex call FT_tex()
autocmd FileType c call FT_C()
autocmd FileType mail call FT_mail()
autocmd FileType html call FT_html()
autocmd FileType htmldjango call FT_html()
autocmd FileType haskell call FT_hs()


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
	return -1
endfunction

function FindEnd() 

	let i=line(".")+1
	let cnt=0
	while i<=line("$")
		let str=getline(i)
		if (str=~'begin{.*}')
			 let cnt=cnt+1
		endif
		if (str=~'end{.*}')
			 let cnt=cnt-1
		endif
		if (cnt < 0)
			return i
		endif
		let i=i+1
	endwhile
	return -1
endfunction

function PutBegin()

	let end=FindEnd()
	if (end>0)
		let @u=getline(end)
		exec "normal \"uP"
		exec ".s/end/begin/"
	endif
endfunction

function PutEnd()

	let beg=FindBegin()
	if (beg>0)
		let @u=getline(beg)
		exec "normal ik\"uP"
		exec ".s/begin{\\([^}]*\\)}.*/end{\\1}/"
	endif
endfunction

function FT_C()
set ofu=syntaxcomplete#Complete
map <F9> :wa:!cc -lm %
map <F3> :wa:!cc -lm %:!./a.out
endfunction

function FT_hs()
nmap <F9> :wa:echo system("cd ".expand("%:p:h").";"."runhaskell ".expand("%:p"))
imap <F9> :wa:echo system("cd ".expand("%:p:h").";"."runhaskell ".expand("%:p"))i
endfunction


function FT_pl()
nmap <F9> :wa:echo system("cd ".expand("%:p:h").";"."perl ".expand("%:p"))
imap <F9> :wa:echo system("cd ".expand("%:p:h").";"."perl ".expand("%:p"))i
endfunction

function FT_html()
set ai 
set ts=2 
set sts=2 
set et 
set sw=2
set omnifunc=syntaxcomplete#Complete
endfunction

function FT_py()
set ai 
set ts=4 
set sts=4 
set et 
set sw=4
set omnifunc=pythoncomplete#Complete
nmap <F9> :wa:echo system("cd ".expand("%:p:h").";"."python ".expand("%:p"))
imap <F9> :wa:echo system("cd ".expand("%:p:h").";"."python ".expand("%:p"))i
set cinwords=if,e­lif,else,for,whi­le,try,except,fi­nally,def,class
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


function FT_mail()

set foldexpr=Mail_foldexpr(v:lnum)
set foldmethod=expr
set foldlevel=1
set foldtext=Mail_foldtext()
endfunction

function! SyncTexForward()
     let execstr = "silent !okular --unique %:p:r.pdf\\#src:".line(".")."%:p 2>/dev/null&"
     exec execstr
endfunction

function FT_tex()

call Bolds()

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
let g:beamer=0
let g:xetex=0
let g:ispdf=0
while i<20
	if getline(i)=~"documentclass.*beamer" || getline(i)=~"usepackage.*tikz"
		let g:beamer=1
		let g:ispdf=1
		break
	endif
	if getline(i)=~"usepackage.*unicode-math"
		let g:xetex=1
		let g:ispdf=1
		break
	endif
	let i=i+1
endwhile	

if g:xetex==1
		setlocal makeprg=echo\ xelatex\ %\;xelatex\ --synctex=1\ \ -src-specials\ --file-line-error\ --interaction\ nonstopmode\ %\ \\\|\ grep\ '^[^:]*:[0123456789]*:'
else
if g:beamer==1
		setlocal makeprg=echo\ pdflatex\ %\;pdflatex\ --synctex=1\ -src-specials\ --file-line-error\ --interaction\ nonstopmode\ %\ \\\|\ grep\ '^[^:]*:[0123456789]*:'
else
		setlocal makeprg=echo\ latex\ %\;latex\ -src-specials\ --file-line-error\ --interaction\ nonstopmode\ %\ \\\|\ grep\ '^[^:]*:[0123456789]*:'
endif
endif

set errorformat=%f:%l:%m

nnoremap <Tab><F3> :execute "!cd ".expand("%:p:h").";".g:psview." ".expand("%:p:r").".ps &"
if (g:ispdf==1)
	"nnoremap <buffer> <F3> :execute "!cd ".expand("%:p:h").";"."okular ".expand("%:p:r").".pdf &"
	nnoremap <buffer> <F3> :call SyncTexForward()<CR>
else
	nnoremap <buffer> <F3> :execute "!cd ".expand("%:p:h").";".g:dviview." -editor \"vim --servername VIM --remote\" -watchfile 0.5 -s 5 -sourceposition ".line(".")."\\ ".expand("%:p:t")." ".expand("%:p:r")." 2>/dev/null >/dev/null &"
endif	
map <F9> <F2>:make<CR>
imap <F9> <F9>
inoremap <C-E> :call PutEnd()i
inoremap <C-B> :call PutBegin()i
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

syn sync clear
syn sync fromstart

endfunction

function Bolds()
	
	dig AA 119808
	dig BB 119809
	dig CC 119810
	dig DD 119811
	dig EE 119812
	dig FF 119813
	dig GG 119814
	dig HH 119815
	dig II 119816
	dig JJ 119817
	dig KK 119818
	dig LL 119819
	dig MM 119820
	dig NN 119821
	dig OO 119822
	dig PP 119823
	dig QQ 119824
	dig RR 119825
	dig SS 119826
	dig TT 119827
	dig UU 119828
	dig VV 119829
	dig WW 119830
	dig XX 119831
	dig YY 119832
	dig ZZ 119833
	dig aa 119834
	dig bb 119835
	dig cc 119836
	dig dd 119837
	dig ee 119838
	dig ff 119839
	dig gg 119840
	dig hh 119841
	dig ii 119842
	dig jj 119843
	dig kk 119844
	dig ll 119845
	dig mm 119846
	dig nn 119847
	dig oo 119848
	dig pp 119849
	dig qq 119850
	dig rr 119851
	dig ss 119852
	dig tt 119853
	dig uu 119854
	dig vv 119855
	dig ww 119856
	dig xx 119857
	dig yy 119858
	dig zz 119859
	dig 00 120782
	dig 11 120783
	dig 22 120784
	dig 33 120785
	dig 44 120786
	dig 55 120787
	dig 66 120788
	dig 77 120789
	dig 88 120790

endfunction
				
