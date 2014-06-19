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

" set relativenumber
set undodir=/home/mandrews/.vim
set undofile

let loaded_matchparen = 1

" leader key to ,
let mapleader=","

set sessionoptions=curdir,help,blank,tabpages

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'
Bundle 'justinmk/vim-syntax-extra'

Bundle 'xolox/vim-misc'

Bundle 'xolox/vim-session'

Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'SkidanovAlex/CtrlK'

Bundle 'airblade/vim-rooter'

Bundle 'bling/vim-airline'

set laststatus=2
let g:airline_symbols = {}
let g:airline_theme='kolor'
let g:airline_detect_whitespace=0
let g:airline_powerline_fonts=1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

Bundle 'kevinw/pyflakes-vim'

Bundle 'terryma/vim-multiple-cursors'

Bundle 'vim-scripts/ProportionalResize'

Bundle 'ManOfTeflon/exterminator'
Bundle 'ManOfTeflon/nerdtree-json'

let g:NERDTreeWinSize = 70

nnoremap <leader>n :NERDTree<cr>
nnoremap <leader>N :exec 'e ' . getcwd()<cr>

au BufRead,BufNewFile *.yxx set ft=yacc

nnoremap L <C-i>
nnoremap H <C-o>
nnoremap _ H
nmap f <Leader><Leader>f
nmap F <Leader><Leader>F
" nnoremap <C-S-o> <C-i>

let g:ctrlk_clang_library_path="/usr/lib/llvm-3.3/lib"
nnoremap <F3> :call GetCtrlKState()<CR>
nnoremap <F2> :call CtrlKNavigateSymbols()<CR>
nnoremap <leader>e :call CtrlKNavigateSymbols()<CR>
nnoremap ` :call CtrlKGoToDefinition()<CR>
nnoremap ~ :call CtrlKGetReferences()<CR>

nnoremap <space> @q

set grepprg=git\ grep\ -wn\ $*
nmap & :grep! <cword> \| copen<cr>
nmap * *N

"colorscheme elflord
exec "colorscheme " . ['elflord'][localtime() % 1]

let g:session_default_to_last=1
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
" set statusline=\ \%f%m%r%h%w\ ::\ %y\ [%{&ff}]\%=\ [%p%%:\ %l/%L:%c]\
" set laststatus=2
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
set ttymouse=xterm2

"allows sudo with :w!!
cmap w!! %!sudo tee > /dev/null %

" auto indent
filetype plugin indent on

" maintain more context around cursor
set scrolloff=100
" au BufWinEnter * norm M

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

nnoremap <leader>w :SaveSession<CR>:wa<CR>
nnoremap <leader>q :SaveSession<CR>:xa<CR>

" VERY useful remap
nnoremap ; :
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
vmap r "_dP
set clipboard+=unnamed

" fix regex so it's like perl/python
" nnoremap / /\v
" vnoremap / /\v

" clear highlights with ,<space>
nnoremap <leader><space> :noh<cr>

" hides buffers instead of closing them
set hidden

set history=1000   " remember more commands and search history
set undolevels=1000 " use many levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title "terminal title

" Shows spaces as you're writing
" set list
" set listchars=tab:>.trail:.,extends:#,nbsp:.

" reselect things just pasted
nnoremap <leader>v V`]

" quick exit from insert
inoremap jj <ESC>

" Creating and moving between splits
nnoremap <leader>h <c-w>v
nnoremap <leader>j <c-w>s<c-w>j
nnoremap <leader>k <c-w>s
nnoremap <leader>l <c-w>v<c-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Creating and moving between tabs
nnoremap <leader>` :tabe<cr>
nnoremap <leader><tab> :tabn<cr>
nnoremap <leader><S-tab> :tabN<cr>
nnoremap <S-UP> <C-w>+
nnoremap <S-DOWN> <C-w>-
nnoremap <S-LEFT> <C-w><
nnoremap <S-RIGHT> <C-w>>

highlight Cursor ctermbg=None ctermfg=24
highlight SpellBad ctermbg=10 ctermfg=White
highlight clear VertSplit
highlight VertSplit ctermfg=56
set fillchars+=vert:\│

function! HighlightCursor()
  let cword=expand("<cword>")
  if cword =~ '\<\*\?\h\w*'
    try
        exec 'match Cursor /\<'.cword.'\>/'
    catch
        match Cursor //
    endtry
  else
    match Cursor //
  endif
endfunction

au CursorMoved * call HighlightCursor()
au InsertLeave * call HighlightCursor()
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

"folding settings
set foldmethod=syntax   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
set foldcolumn=0
hi Folded guibg=DarkGrey ctermbg=DarkGrey guifg=Red ctermfg=Red
hi FoldColumn guibg=Black ctermbg=Black guifg=White ctermfg=White
hi Search guibg=LightBlue ctermbg=Magenta guifg=Black ctermfg=White

hi DiffAdd cterm=bold ctermfg=85 ctermbg=234
hi DiffDelete cterm=bold ctermfg=196
hi DiffChange ctermfg=190 ctermbg=238
hi link DiffText String

" Tex-Live grep fix
" set grepprg=grep\ -nH\ $*

"LaTeX
"auto recompile upon save
autocmd BufWritePost *.tex !pdflatex <afile>

"Fun functions for playing with splits
function! HOpen(dir,what_to_open)

  let [type,name] = a:what_to_open

  if a:dir=='left' || a:dir=='right'
    vsplit
  elseif a:dir=='up' || a:dir=='down'
    split
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

function! HYankWindow()
  let g:window = winnr()
  let g:buffer = bufnr('%')
  let g:bufhidden = &bufhidden
endfunction

function! HDeleteWindow()
  call HYankWindow()
  set bufhidden=hide
  quit
endfunction

function! HPasteWindow(direction)
  let old_buffer = bufnr('%')
  call HOpen(a:direction,['buffer',g:buffer])
  let g:buffer = old_buffer
  let &bufhidden = g:bufhidden
endfunction

nnoremap <c-d> :call HDeleteWindow()<cr>
nnoremap <c-y> :call HYankWindow()<cr>
nnoremap <c-p><up> :call HPasteWindow('up')<cr>
nnoremap <c-p><down> :call HPasteWindow('down')<cr>
nnoremap <c-p><left> :call HPasteWindow('left')<cr>
nnoremap <c-p><right> :call HPasteWindow('right')<cr>
nnoremap <c-p>k :call HPasteWindow('up')<cr>
nnoremap <c-p>j :call HPasteWindow('down')<cr>
nnoremap <c-p>h :call HPasteWindow('left')<cr>
nnoremap <c-p>l :call HPasteWindow('right')<cr>
nnoremap <c-p>p :call HPasteWindow('here')<cr>

let g:extension_cycle = ['.c', '.cc', '.cpp', '.h', '.hpp', '.ipp']
function! CycleExtension()
    let filename = expand('%:p')
    let i=0
    for extension in g:extension_cycle
        let matches = matchlist(filename, '\(.*\)\' . extension . '$')
        if !empty(matches)
            break
        endif
        let i = i + 1
    endfor
    if empty(matches)
        return
    endif
    let prefix = matches[1]
    let j = i + 1
    while j != i
        let j = j % len(g:extension_cycle)
        let newfile = prefix . g:extension_cycle[j]
        if filereadable(newfile)
            echo 'found: ' . newfile
            exec 'edit ' . newfile
            return
        endif
        let j = j + 1
    endwhile
endfunction

nmap <tab> :call CycleExtension()<cr>

nnoremap <leader>b :! build<CR>

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

comm! -nargs=0 -range GdbVEval exec 'GdbEval ' . s:get_range()

nnoremap <F6>  :exec "GdbEval " . expand("<cword>")<CR>
vnoremap <F6>  :GdbVEval<cr>
nnoremap <F5>  :GdbLocals<CR>
nnoremap <F4>  :GdbNoTrack<CR>

nnoremap <Insert> :GdbContinue<cr>
nnoremap <End> :GdbBacktrace<cr>
nnoremap <Home> :GdbUntil<cr>
nnoremap <S-Up> :GdbExec finish<cr>
nnoremap <S-Down> :GdbExec step<cr>
nnoremap <S-Right> :GdbExec next<cr>
nnoremap <S-Left> :GdbToggle<cr>
noremap <PageUp> :GdbExec up<cr>
noremap <PageDown> :GdbExec down<cr>

function! s:start_debugging(cmd)
    cd $PATH_TO_MEMSQL
    exec 'Dbg ' . a:cmd
endfunction
command! -nargs=1 DbgWrapper    call s:start_debugging(<f-args>)

nnoremap <leader>B :DbgWrapper ./memsqld<cr>

function! BranchEdit(branch, file)
    enew
    let branch_file = a:branch . ':' . a:file
    exec "silent %!git show " . branch_file
    setlocal nomodifiable buftype=nofile bufhidden=wipe
    exec "file " . branch_file
    filetype detect
    au BufReadPre <buffer> setlocal modifiable buftype= bufhidden=hide
    let b:original_file = a:file
endfunction

function! BranchEditComplete(arg, cmd, pos)
    return system("git for-each-ref --format='%(refname:short)' refs/heads/")
endfunction

function! GitShow(branch)
    Rooter
    call BranchEdit(a:branch, expand('%'))
endfunction

function! OriginalFile()
    if exists('b:original_file')
        exec 'e ' . b:original_file
    endif
endfunction

command! -nargs=1 -complete=custom,BranchEditComplete GitShow call GitShow(<q-args>)
command! -nargs=0 OriginalFile call OriginalFile()

nnoremap <leader>g :GitShow<space>
nnoremap <leader>G :OriginalFile<cr>
