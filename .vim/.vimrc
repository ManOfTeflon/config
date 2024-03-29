" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
" runtime! archlinux.vim

let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let s:portable = expand('<sfile>:p:h')

let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

set nocp

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim72/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

filetype off

" directory
set directory=/home/mandrews/.vim

set undodir=/home/mandrews/.vim/undo
set undofile
set autoread

let loaded_matchparen = 1

" leader key to ,
let mapleader=","

set sessionoptions=curdir,help,blank,tabpages

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'mtth/scratch.vim'

Bundle 'tpope/vim-fugitive'
Bundle 'justinmk/vim-syntax-extra'

Bundle 'xolox/vim-misc'

Bundle 'xolox/vim-session'

" Bundle 'airblade/vim-rooter'

" Bundle 'AndrewRadev/linediff.vim'
Bundle 'vim-scripts/AnsiEsc.vim'

Bundle 'bling/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'vim-scripts/Align'
Bundle 'vim-scripts/SQLUtilities'
" Bundle 'Valloric/YouCompleteMe'
Bundle 'vim-utils/vim-man'
Bundle 'fatih/vim-go'
Bundle 'leafgarland/typescript-vim'

Bundle 'Shougo/vimproc.vim'
Bundle 'Quramy/tsuquyomi'

au BufRead,BufNewFile *.{tsx} nnoremap <buffer> <silent> ` :TsuDefinition<CR>
au BufRead,BufNewFile *.{tsx} nnoremap <buffer> <silent> ~ :TsuReferences<CR>

let g:ycm_confirm_extra_conf=0
let g:ycm_show_diagnostics_ui=0
let g:ycm_autoclose_preview_window_after_completion=1

set laststatus=2
let g:airline_symbols = { 'space': ' ', 'maxlinenr': '' }
let g:airline_theme='kolor'
let g:airline_detect_whitespace=0
let g:airline_section_warning=""
let g:airline_powerline_fonts=1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Bundle 'kevinw/pyflakes-vim'

Bundle 'terryma/vim-multiple-cursors'

Bundle 'ManOfTeflon/exterminator'
Bundle 'ManOfTeflon/nerdtree-json'
Bundle 'ManOfTeflon/vim-make'
Bundle 'ManOfTeflon/tpane'

" Bundle 'ManOfTeflon/python.vim'
" call python#rc()

" Bundle 'ManOfTeflon/live.vim'
" PythonPlugin 'live.vim'

Bundle 'wincent/Command-T'
let g:CommandTMaxHeight = 10
let g:CommandTMaxFiles = 500000
let g:CommandTFileScanner = 'git'

let g:NERDTreeWinSize = 70
let g:NERDTreeMapJumpNextSibling = "L"
let g:NERDTreeMapJumpPrevSibling = "H"


Bundle 'lyuts/vim-rtags'

Bundle 'chrisbra/NrrwRgn'

nnoremap <silent> <leader>n :NERDTreeFind<cr>
nnoremap <silent> <leader>N :NERDTree<cr>
nnoremap <silent> <leader><C-n> :NERDTreeClose<cr>
nnoremap <leader>e :NERDTreeCurrentFile<cr>

nnoremap <silent> <leader><leader>n :0wincmd w<cr>

au BufRead,BufNewFile *.yxx set ft=yacc
au BufRead,BufNewFile *.ops set ft=cpp
au BufRead,BufNewFile *.types set ft=cpp
au BufRead,BufNewFile *.methods set ft=cpp
au BufRead,BufNewFile *.members set ft=cpp
au BufRead,BufNewFile *.mbc set ft=cpp
au BufRead,BufNewFile *.mpl set ft=maple
au BufRead,BufNewFile *.sql.py.expected set ft=sql
au BufRead,BufNewFile *.sql.tmpl set ft=sql
au BufRead,BufNewFile *.tpst set ft=sql

nnoremap L <C-i>
nnoremap H <C-o>
nnoremap _ H
nnoremap \ ;

" nnoremap <silent> <F2> :CommandTRTags<CR>
nnoremap <c-e> :CommandT<CR>

nmap <silent> <C-]> <F2>
au BufRead,BufNewFile *.{cpp,cc,c,h,hpp,hxx} nnoremap <buffer> <silent> ` :call rtags#JumpTo(g:SAME_WINDOW)<CR>
au BufRead,BufNewFile *.{cpp,cc,c,h,hpp,hxx} nnoremap <buffer> <silent> ~ :call rtags#FindRefs()<CR>
au BufRead,BufNewFile *.{go} nnoremap <buffer> <silent> ` :GoDef<CR>
command! -nargs=0 Rename call rtags#RenameSymbolUnderCursor()
command! -nargs=1 -complete=customlist,rtags#CompleteSymbols RGrep call rtags#FindRefsByName(<f-args>)

nnoremap <space> @q

set grepprg=git\ grep\ -wn\ $*
nnoremap * *N

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set guioptions-=e
set guicursor=a:blinkon0-block-Cursor
set guifont=Inconsolata\ for\ Powerline\ Medium\ 10
if v:progname == 'gvim'
    colorscheme slate
else
    colorscheme elflord
endif

try
    if len(argv()) == 0
        let g:session_default_name = fnamemodify(systemlist("git rev-parse --show-toplevel")[0], ':t')
    endif
catch
endtry

let g:session_default_overwrite = 0
let g:session_autoload="yes"
let g:session_autosave_periodic=1
let g:session_autosave="yes"

set modelines=0
set viminfo+=!

" disable backups (and swap)
set nobackup
set nowritebackup
set noswapfile

" wrap searches
set wrapscan

" tab and indentation
set softtabstop=4
set expandtab
set nosmarttab
set shiftwidth=4
set backspace=indent,eol,start
set autoindent
set cindent
set hidden
set wildmenu
set wildmode=list:longest:full
set ttyfast
set cursorline

" show commands
set showcmd

" show line and column position of cursor
set ruler

" status bar
set cmdheight=1

" formatting options
set formatoptions=c,q,r,t

" line numbers
set number

" search
set hlsearch
set incsearch
set smartcase

" syntax highlighting
filetype plugin on
syntax on

" enable mouse
set mouse=a
set ttymouse=sgr

"allows sudo with :w!!
cnoremap w!! %!sudo tee > /dev/null %
" start of line
:cnoremap <C-A>		<Home>
" back one character
:cnoremap <C-B>		<Left>
" delete character under cursor
:cnoremap <C-D>		<Del>
" end of line
:cnoremap <C-E>		<End>
" forward one character
:cnoremap <C-F>		<Right>
" recall newer command-line
:cnoremap <C-N>		<Down>
" recall previous (older) command-line
:cnoremap <C-P>		<Up>
" back one word
:cnoremap <Esc><C-B>	<S-Left>
:cnoremap <A-b>	        <S-Left>
" forward one word
:cnoremap <Esc><C-F>	<S-Right>
:cnoremap <A-f>	        <S-Left>

" auto indent
filetype plugin indent on

" maintain more context around cursor
set scrolloff=100

" Quickly edit/reload the vimrc file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

nnoremap <silent> <leader>w :SaveSession<CR>:wa<CR>
nnoremap <silent> <leader>q :SaveSession<CR>:xa<CR>

" VERY useful remap
nnoremap ; :
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
vnoremap r "_dP
set clipboard=unnamedplus

" clear highlights with ,<space>
nnoremap <silent> <leader><space> :noh<cr>
nnoremap <silent> <leader><c-space> :noh\|redraw!<cr>

" hides buffers instead of closing them
set hidden

set history=1000   " remember more commands and search history
set undolevels=1000 " use many levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,bincache/**,objdir/**
set title "terminal title

" reselect things just pasted
nnoremap <leader>v V`]

" Creating and moving between splits
nnoremap <leader>h <c-w>v
nnoremap <leader>j <c-w>s<c-w>j
nnoremap <leader>k <c-w>s
nnoremap <leader>l <c-w>v<c-w>l
nmap <C-w>h <C-h>
nmap <C-w>j <C-j>
nmap <C-w>k <C-k>
nmap <C-w>l <C-l>

function! s:Forget()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    exec 'file Scratch' . bufnr('%')
endfunction

function! s:Less(filename)
    exec 'edit ' . a:filename
    setlocal buftype=nowrite
    setlocal bufhidden=delete
    setlocal nomodifiable
    setlocal readonly
    setlocal noswapfile
    AnsiEsc
endfunction

function! s:Bash(command)
    enew
    exec '%!' . a:command
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nomodifiable
    setlocal readonly
    setlocal noswapfile
    exec 'file output:\ ' . substitute(a:command, ' ', '\\ ', 'g')
    AnsiEsc
endfunction

command! -nargs=0 Forget call s:Forget()
command! -nargs=1 -complete=file Less call s:Less(<q-args>)
command! -nargs=1 -complete=shellcmd Bash call s:Bash(<q-args>)

" Creating and moving between tabs
nnoremap <silent> <leader>` :tabe<cr>
nnoremap <silent> <leader><tab> :tabn<cr>
nnoremap <silent> <leader><S-tab> :tabN<cr>
nnoremap <S-UP> <C-w>+
nnoremap <S-DOWN> <C-w>-
nnoremap <S-LEFT> <C-w><
nnoremap <S-RIGHT> <C-w>>

highlight CursorWord guibg=NONE ctermbg=None guifg=#005f87 ctermfg=24
highlight SpellBad guibg=Green ctermbg=Green guifg=White ctermfg=White
highlight clear VertSplit
highlight VertSplit guifg=#5f00d7 ctermfg=56
highlight TrailingWhitespace ctermbg=Magenta
au Syntax * syn match TrailingWhitespace /\s\+$/
set fillchars+=vert:\│

function! s:HighlightCursor()
  let cword=expand("<cword>")
  if cword =~ '\<\*\?\h\w*'
    try
        exec 'match CursorWord /\<'.cword.'\>/'
    catch
        match CursorWord //
    endtry
  else
    match CursorWord //
  endif
endfunction

au CursorMoved * call s:HighlightCursor()
au InsertLeave * call s:HighlightCursor()
au InsertEnter * match Cursor //

let default_path = escape(&path, '\ ') " store default value of 'path'

" Always add the current file's directory to the path and tags list if not
" already there. Add it to the beginning to speed up searches.
au BufRead *
      \ let tempPath=escape(escape(expand("%:p:h"), ' '), '\ ')."/**" |
      \ exec "set path-=".tempPath |
      \ exec "set path-=".default_path |
      \ exec "set path^=".tempPath |
      \ exec "set path^=".default_path

hi Folded guibg=#5fffff ctermbg=87 guifg=Red ctermfg=Red
hi FoldColumn guibg=Black ctermbg=Black guifg=White ctermfg=White
hi Search guibg=Magenta ctermbg=Magenta guifg=White ctermfg=White

hi DiffAdd gui=bold cterm=bold guifg=#5fffaf ctermfg=85 guibg=#1c1c1c ctermbg=234
hi DiffDelete gui=bold cterm=bold guifg=#ff0000 ctermfg=196
hi DiffChange guifg=#d7ff00 ctermfg=190 guibg=#444444 ctermbg=238
hi link DiffText String

"LaTeX
"auto recompile upon save
autocmd BufWritePost *.tex silent call system('pdflatex ' . expand("<afile>"))

"Fun functions for playing with splits
function! HOpen(dir,what_to_open)

  let [type,name] = a:what_to_open

  if a:dir=='left' || a:dir=='right'
    vsplit
  elseif a:dir=='up' || a:dir=='down'
    split
  elseif a:dir=='tab'
    tabe
  end

  if a:dir=='down' || a:dir=='right'
    exec "normal! \<c-w>\<c-w>"
  end

  if type=='buffer'
    exec 'buffer '.name
  else
    exec 'edit '.name
  end
endfunction

function! HYankWindow(removed)
  if exists('g:buffer') && g:removed
    if g:bufhidden == 'wipe'
        exec 'bwipeout ' . g:buffer
    elseif g:bufhidden == 'delete'
        exec 'bdelete ' . g:buffer
    endif
  endif

  let g:removed = a:removed
  let g:window = winnr()
  let g:buffer = bufnr('%')
  let g:bufhidden = &bufhidden
endfunction

function! HDeleteWindow()
  call HYankWindow(1)
  set bufhidden=hide
  quit
endfunction

function! HPasteWindow(direction)
  let old_buffer = bufnr('%')
  call HOpen(a:direction,['buffer',g:buffer])
  let g:buffer = old_buffer
  let &l:bufhidden = g:bufhidden
endfunction

function! HMaximize(nonumber)
    call HYankWindow(0)
    call HPasteWindow('tab')
    if a:nonumber
        set nonumber
    endif
endfunction

nnoremap <silent> <c-d> :call HDeleteWindow()<cr>
nnoremap <silent> <c-y> :call HYankWindow(0)<cr>
nnoremap <silent> <c-p><up> :call HPasteWindow('up')<cr>
nnoremap <silent> <c-p><down> :call HPasteWindow('down')<cr>
nnoremap <silent> <c-p><left> :call HPasteWindow('left')<cr>
nnoremap <silent> <c-p><right> :call HPasteWindow('right')<cr>
nnoremap <silent> <c-p>k :call HPasteWindow('up')<cr>
nnoremap <silent> <c-p>j :call HPasteWindow('down')<cr>
nnoremap <silent> <c-p>h :call HPasteWindow('left')<cr>
nnoremap <silent> <c-p>l :call HPasteWindow('right')<cr>
nnoremap <silent> <c-p>t :call HPasteWindow('tab')<cr>
nnoremap <silent> <c-p>p :call HPasteWindow('here')<cr>
nnoremap <silent> <c-w>z :call HMaximize(0)<cr>
nnoremap <silent> <c-w>Z :call HMaximize(1)<cr>

let g:extension_cycles = [ ['.c', '.cc', '.cpp', '.h', '.hpp', '.hxx', '.ipp'], ['.sql', '.sql.py.expected'], ['.mpl', '.mbc'] ]

function! CycleExtension()
    let filename = expand('%:p')
    let cycle = []
    let prefix = ""
    for extension_cycle in g:extension_cycles
        let i=0
        for extension in extension_cycle
            let matches = matchlist(filename, '\(.*\)\' . extension . '$')
            if !empty(matches)
                break
            endif
            let i = i + 1
        endfor
        if ! empty(matches)
            let cycle = extension_cycle
            let prefix = matches[1]
            break
        endif
    endfor

    if ! empty(cycle)
        let j = i + 1
        while j != i
            let j = j % len(cycle)
            let newfile = prefix . cycle[j]
            if filereadable(newfile)
                echo 'found: ' . newfile
                exec 'edit ' . newfile
                return
            endif
            let j = j + 1
        endwhile
    endif
endfunction

nnoremap <silent> <tab> :call CycleExtension()<cr>

" These say shift, but they are actually ctrl
set <S-Up>=[A
set <S-Down>=[B
set <S-Right>=[C
set <S-Left>=[D

function! s:get_range()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

comm! -nargs=1 -range RangeExec exec <q-args> . ' ' . s:get_range()

nnoremap <silent> & :exec 'VimGrep \b' . expand('<cword>') . '\b'<cr>
vnoremap <silent> & :RangeExec VimGrep<cr>
nnoremap <silent> <c-_> :VimGrep 

nnoremap <silent> <F6>  :exec "GdbEval " . expand("<cword>")<CR>
vnoremap <silent> <F6>  :RangeExec GdbEval<cr>

nnoremap <silent> <Insert> :GdbContinue<cr>
nnoremap <silent> <Home> :GdbUntil<cr>
nnoremap <silent> <S-Up> :GdbExec finish<cr>
nnoremap <silent> <S-Down> :GdbExec step<cr>
nnoremap <silent> <S-Right> :GdbExec next<cr>
nnoremap <silent> <S-Left> :GdbToggle<cr>
noremap <silent> <PageUp> :GdbExec up<cr>
noremap <silent> <PageDown> :GdbExec down<cr>

nnoremap <silent> <F5>  :GdbToggleLocals<CR>
nnoremap <silent> <End> :GdbFrame<cr>

function! s:BranchEdit(branch, file)
    let branch_file = a:branch . ':' . a:file
    if bufnr(branch_file) != -1
        exec "buffer " . branch_file
    else
        enew
        exec "silent %!git show " . branch_file
        setlocal nomodifiable buftype=nofile bufhidden=wipe
        exec "file " . branch_file
        filetype detect
        au BufReadPre <buffer> setlocal modifiable buftype= bufhidden=wipe
        let b:original_file = a:file
    endif
endfunction

function! s:BranchEditComplete(arg, cmd, pos)
    return system("git for-each-ref --format='%(refname:short)' refs/heads/")
endfunction

function! s:GitShow(branch)
    " Rooter
    call s:BranchEdit(a:branch, expand('%'))
endfunction

function! s:OriginalFile()
    if exists('b:original_file')
        exec 'e ' . b:original_file
    endif
endfunction

command! -nargs=1 -complete=custom,s:BranchEditComplete GitShow call s:GitShow(<q-args>)
command! -nargs=0 OriginalFile call s:OriginalFile()

nnoremap <silent> <leader>g :GitShow<space>
nnoremap <silent> <leader>G :OriginalFile<cr>

command! -nargs=1 Curl read!curl -s <q-args>

let g:GO_TEST_PREFIX=fnamemodify($GOPATH . '/src/github.com/impira/impira/', ':p')
function! s:ResolveGoTestArgs()
    let l:file = expand('%:p')

    if strpart(l:file, 0, len(g:GO_TEST_PREFIX)) != g:GO_TEST_PREFIX
        return []
    else
        let l:file = strpart(l:file, len(g:GO_TEST_PREFIX))
    endif

    if l:file !~# '^.*_test\.go$'
        let l:file = expand('%:h') . '/...'
    endif

    let l:args = [ l:file ]
    if expand('<cword>') =~# '^Test[a-zA-Z0-9]\+$'
        let l:args = l:args + [ '-run', expand('<cword>') ]
    endif

    return l:args
endfunction

function! s:TestGo(args)
    let g:LAST_GO_TEST = a:args
    exec 'TestArgs ' . join(a:args, ' ')
endfunction
command! -nargs=* TestGo call s:TestGo(len(<q-args>) ? [<f-args>] : s:ResolveGoTestArgs())

function! s:TestLastGo()
    if exists('g:LAST_GO_TEST')
        call s:TestGo(g:LAST_GO_TEST)
    endif
endfunction
command! -nargs=0 TestLastGo call s:TestLastGo()

let g:TPANE_SETTINGS = {
    \ 'BUILD_COMMAND': 'build backend',
    \ 'EXECUTABLE': './impirad -f configs/mandrews.yaml',
    \ 'TEST_RUNNER': 'gotest',
 \ }

nnoremap <silent> <leader>s :Settings<CR>
nnoremap <silent> <leader>d :DefaultSettings\|Settings<CR>

nnoremap <silent> <leader>b     :Run<CR>

nnoremap <silent> <leader>a     :Build<CR>
nnoremap <silent> <leader><c-a> :Build build dist/<CR>
nnoremap <silent> <leader>A     :Build build all<CR>

nnoremap <silent> <leader>S :Term bash<CR>

nnoremap <silent> <leader>t     :TestGo /home/mandrews/Projects/impira/go/src/github.com/impira/impira/...<CR>
nnoremap <silent> <leader>T     :TestGo<CR>
nnoremap <silent> <leader><c-t> :TestLastGo<CR>

nnoremap <silent> <leader>cd :Gcd<cr>

function! MakePattern(text)
  let pat = escape(a:text, '\')
  let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
  let pat = substitute(pat, '^\_s\+', '\\s\\*', '')
  let pat = substitute(pat, '\_s\+',  '\\_s\\+', 'g')
  return '\\V' . escape(pat, '\"')
endfunction
vnoremap <silent> / :<C-U>let @/="<C-R>=MakePattern(getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]])<CR>" \| set hls<CR>

highlight SignColumn guibg=Black guifg=White ctermbg=None ctermfg=White

hi TabLineFill ctermfg=Black ctermbg=Black
hi TabLine ctermfg=White ctermbg=141
hi TabLineSel ctermfg=LightGray ctermbg=91

" Impira stuff

function! s:ViewSchema()
    enew
    %!pg_dump -s -d impira
    set ft=sql
    Forget
endfunction
comm! -nargs=0 ViewSchema call s:ViewSchema()

