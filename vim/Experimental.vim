



function! LineTerminate(char)


finish

fu! Test()
  let input = input(">")
  let result = "error\n"
  if 1
    redraw | echom result " is result"
  endif
endf

finish



map <Leader>we :call <SID>ShowSyntaxUnderCursor()<CR>

function! s:ShowSyntaxUnderCursor()
	call s:ShowSyntaxRule(synIDattr(synID(line("."),col("."),1),"name"))
	call s:ShowSyntaxRule(synIDattr(synID(line("."),col("."),0),"name"))
	call s:ShowSyntaxRule(synIDattr(synIDtrans(synID(line("."),col("."),1)),"name"))
endfunction

function! s:ShowSyntaxRule(rule)
	"" Does not give source file/line
	" exec ":verbose syntax list ".a:rule
	exec ":verbose highlight ".a:rule
endfunction


nnoremap <silent><Space> <space>:call <SID>ShowTagDecl()<CR>

function! s:ShowTagDecl()
  redir => output
  silent! exec "tselect ".expand("<cword>")
  redir END
  for line in split(output, "\n")
    if match(line, '\v^\s*[0-9]') != -1
      redraw | echo line
      return 0
    endif
  endfor
endfunction




finish

"
"let $FILENAME="/tmp/" . system('date +"%Y%m%d"')
"echo $FILENAME
"" e.g. /tmp/20130122
"
"if exists('*strftime')
"  let fn = strftime('/tmp/%Y%m%d')
"  exe "tabnew" fn
"endif
"
"" won't get caught in ssh
"imap <silent> <S-Insert> <C-O>:set paste<CR><C-R>+<C-O>:set nopaste<CR>
"imap <silent> <S-Insert> <C-O>:set paste
"
"
"" View Help on current word under cursor in new split window
"map <Leader>hs :help <c-r>=expand("<cword>")<CR>
"
"nnoremap <Leader>es silent ":exec getline('.')"<CR>
"
"
"" Execute selected lines as if :source'd
"nnoremap <Leader>es :exe getline(".")<CR>
"vnoremap <Leader>es :<c-u>exec join(getline("'<","'>"),"\n")<CR>
"
"
"let g:testA = 1
"call TestFun()
"echo 'testA == ' testA
"
"function! TestFun()
"  let g:testA += 1
"endfunction
"
function! TestMe()
  echo "Yay!"
endfunction

call TestMe()
"
"exec "function! TestMe()\n  echo 'Yay!'\nendfunction"
"
"autocmd! WinLeave
"  autocmd WinLeave * :call OnLeaveWindow()
"
"function! OnLeaveWindow()
"  let maxTab = tabpagenr("$")
"  let thisTab = tabpagenr()
"  if (winnr("$") == 1 && maxTab > 1 && thisTab > 1 && thisTab < maxTab)
"    tabprev
"  endif
"endfunction
"

"http://vim.1045645.n5.nabble.com/wish-different-statusline-format-for-noncurrent-statusline-td1209896.html

" Colors of active statusline
hi User1  guifg=#66ff66 guibg=#008000 gui=bold term=standout cterm=bold ctermfg=lightgreen ctermbg=lightgreen
hi User2  guifg=#ffff60 guibg=#008000 gui=bold term=none cterm=bold ctermfg=yellow     ctermbg=lightgreen

" Colors or inactive statusline
hi User3  guifg=#66ff66 guibg=#008000 gui=bold term=standout cterm=bold ctermfg=lightgreen ctermbg=lightgreen
hi User4  guifg=#66ff66 guibg=#008000 gui=bold term=none cterm=bold ctermfg=lightgreen     ctermbg=lightgreen

" Function used to display syntax group.
function! SyntaxItem()
 return synIDattr(synID(line("."),col("."),1),"name")
endfunction

" Function used to display utf-8 sequence.
function! ShowUtf8Sequence()
 let p = getpos('.')
 redir => utfseq
 sil normal! g8
 redir End
 call setpos('.', p)
 return substitute(matchstr(utfseq, '\x\+ .*\x'), '\<\x', '0x&', 'g')
endfunction

if has('statusline')
 if version >= 700
   " Fancy status line.
   set statusline =
   set statusline+=%#User1#                       " highlighting
   set statusline+=%-2.2n\                        " buffer number
   set statusline+=%#User2#                       " highlighting
   set statusline+=%f\                            " file name
   set statusline+=%#User1#                       " highlighting
   set statusline+=%h%m%r%w\                      " flags
   set statusline+=%{(&key==\"\"?\"\":\"encr,\")} " encrypted?
   set statusline+=%{strlen(&ft)?&ft:'none'},     " file type
   set statusline+=%{(&fenc==\"\"?&enc:&fenc)},   " encoding
   set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
   set statusline+=%{&fileformat},                " file format
   set statusline+=%{&spelllang},                 " spell language
   set statusline+=%{SyntaxItem()}                " syntax group under cursor
   set statusline+=%=                             " indent right
   set statusline+=%#User2#                       " highlighting
   set statusline+=%{ShowUtf8Sequence()}\         " utf-8 sequence
   set statusline+=%#User1#                       " highlighting
   set statusline+=0x%B\                          " char under cursor
   set statusline+=%-6.(%l,%c%V%)\ %<%P           " position

   " Use different colors for statusline in current and non-current window.
   let g:Active_statusline=&g:statusline
   let g:NCstatusline=substitute(
     \                substitute(g:Active_statusline,
     \                'User1', 'User3', 'g'),
     \                'User2', 'User4', 'g')
   au WinEnter * let&l:statusline = g:Active_statusline
   au WinLeave * let&l:statusline = g:NCstatusline
 endif
endif

