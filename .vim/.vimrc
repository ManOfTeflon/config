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

Bundle 'mtth/scratch.vim'

Bundle 'tpope/vim-fugitive'
Bundle 'justinmk/vim-syntax-extra'

Bundle 'xolox/vim-misc'

Bundle 'xolox/vim-session'

Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'SkidanovAlex/CtrlK'

Bundle 'airblade/vim-rooter'

Bundle 'bling/vim-airline'
Bundle 'vim-scripts/Align'
Bundle 'vim-scripts/SQLUtilities'
Bundle 'Valloric/YouCompleteMe'

let g:ycm_confirm_extra_conf=0
let g:ycm_show_diagnostics_ui=0
let g:ycm_autoclose_preview_window_after_completion=1

set laststatus=2
let g:airline_symbols = { 'space': ' ' }
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

" Bundle 'vim-scripts/ProportionalResize'

Bundle 'ManOfTeflon/exterminator'
Bundle 'ManOfTeflon/nerdtree-json'
Bundle 'ManOfTeflon/vim-make'

Bundle 'wincent/Command-T'
nnoremap <F3> :CommandT<CR>
let g:CommandTMaxHeight = 10
let g:CommandTMaxFiles = 500000
let g:CommandTFileScanner = 'watchman'

let g:NERDTreeWinSize = 70
let g:NERDTreeMapJumpNextSibling = "L"
let g:NERDTreeMapJumpPrevSibling = "H"

nnoremap <silent> <leader>n :NERDTree<cr>
nnoremap <silent> <leader>N :NERDTreeFind<cr>

nnoremap <silent> <leader><leader>n :0wincmd w<cr>

au BufRead,BufNewFile *.yxx set ft=yacc
au BufRead,BufNewFile *.ops set ft=cpp
au BufRead,BufNewFile *.types set ft=cpp
au BufRead,BufNewFile *.methods set ft=cpp
au BufRead,BufNewFile *.members set ft=cpp
au BufRead,BufNewFile *.sql.py.expected set ft=sql

nnoremap L <C-i>
nnoremap H <C-o>
nnoremap _ H
nnoremap \ ;
" nnoremap <C-S-o> <C-i>

let g:ctrlk_clang_library_path="/usr/lib/llvm-3.3/lib"
nnoremap <silent> <F4> :call GetCtrlKState()<CR>
nnoremap <silent> <F2> :call CtrlKNavigateSymbols()<CR>
au BufRead,BufNewFile *.{cpp,cc,c,h,hpp,hxx} nnoremap <buffer> ` :call CtrlKGoToDefinition()<CR>
nnoremap ~ :call CtrlKGetReferences() \| Lopen<CR>

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
cnoremap w!! %!sudo tee > /dev/null %

" auto indent
filetype plugin indent on

" maintain more context around cursor
set scrolloff=100
" au BufWinEnter * norm M

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

" fix regex so it's like perl/python
" nnoremap / /\v
" vnoremap / /\v

" clear highlights with ,<space>
nnoremap <silent> <leader><space> :noh<cr>

" hides buffers instead of closing them
set hidden

set history=1000   " remember more commands and search history
set undolevels=1000 " use many levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,bincache/**,objdir/**
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
nmap <C-w>h <C-h>
nmap <C-w>j <C-j>
nmap <C-w>k <C-k>
nmap <C-w>l <C-l>

nnoremap <silent> <C-h> :call WindowMotion('h')<cr>
nnoremap <silent> <C-j> :call WindowMotion('j')<cr>
nnoremap <silent> <C-k> :call WindowMotion('k')<cr>
nnoremap <silent> <C-l> :call WindowMotion('l')<cr>

function! s:Forget()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    exec 'file Scratch' . bufnr('%')
endfunction

command! -nargs=0 Forget call s:Forget()

function! WindowMotion(dir) "{{{
    let dir = a:dir
 
    let old_winnr = winnr()
    execute "wincmd " . dir
    if old_winnr != winnr()
        return
    endif
 
    if dir == 'h'
        let dir = '-L'
    elseif dir == 'j'
        let dir = '-D'
    elseif dir == 'k'
        let dir = '-U'
    elseif dir == 'l'
        let dir = '-R'
    endif
    call system('tmux select-pane ' . dir)
endfunction

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

function! HighlightCursor()
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
" set foldmethod=syntax   "fold based on indent
" set foldnestmax=10      "deepest fold is 10 levels
" set nofoldenable        "dont fold by default
" set foldlevel=1         "this is just what i use
" set foldcolumn=0
hi Folded guibg=#5fffff ctermbg=87 guifg=Red ctermfg=Red
hi FoldColumn guibg=Black ctermbg=Black guifg=White ctermfg=White
hi Search guibg=Magenta ctermbg=Magenta guifg=White ctermfg=White

hi DiffAdd gui=bold cterm=bold guifg=#5fffaf ctermfg=85 guibg=#1c1c1c ctermbg=234
hi DiffDelete gui=bold cterm=bold guifg=#ff0000 ctermfg=196
hi DiffChange guifg=#d7ff00 ctermfg=190 guibg=#444444 ctermbg=238
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

nnoremap <silent> <c-d> :call HDeleteWindow()<cr>
nnoremap <silent> <c-y> :call HYankWindow()<cr>
nnoremap <silent> <c-p><up> :call HPasteWindow('up')<cr>
nnoremap <silent> <c-p><down> :call HPasteWindow('down')<cr>
nnoremap <silent> <c-p><left> :call HPasteWindow('left')<cr>
nnoremap <silent> <c-p><right> :call HPasteWindow('right')<cr>
nnoremap <silent> <c-p>k :call HPasteWindow('up')<cr>
nnoremap <silent> <c-p>j :call HPasteWindow('down')<cr>
nnoremap <silent> <c-p>h :call HPasteWindow('left')<cr>
nnoremap <silent> <c-p>l :call HPasteWindow('right')<cr>
nnoremap <silent> <c-p>p :call HPasteWindow('here')<cr>

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

function! TMuxExecute(cmd, log, clear)
    if a:clear != 0
        call TMuxExecute("clear", a:log, 0)
    endif
    call system("tmux_run_pane.sh '" . a:log . "' " . a:cmd)
endfunction

function! s:Test(cmd)
    if a:cmd == ""
        let curfile = expand("%")
        let curfile_is_test = (curfile =~ "\.sql$" || curfile =~ "\.py$")

        if exists("g:LAST_TEST") && g:LAST_TEST != "" && ! curfile_is_test
            let cmd = g:LAST_TEST
        else
            let cmd = curfile
        endif
    else
        let cmd = a:cmd
    endif

    let g:LAST_TEST = cmd

    call TMuxExecute("run-test -P3306 --keep-alive " . cmd . ' ' . g:TEST_ARGS, 'test', 0)
endfunction

let s:TestPlugin = {}

function! s:TestPlugin.Activate(path)
    call s:Test(a:path.str({'format': 'Edit'}))
    call nerdtree#closeTreeIfOpen()
endfunction

function! s:TestTree()
    call g:NERDTreeCreator.CreatePrimary('memsqltest', s:TestPlugin)
endfunction

command! -nargs=1 -complete=shellcmd TMuxExecute call s:TMuxExecute(<q-args>, 'misc')
command! -nargs=* -complete=file Test call s:Test(<q-args>)
command! -nargs=0 TestTree call s:TestTree()

nnoremap <silent> <leader>t :TestTree<CR>
nnoremap <silent> <leader>T :Test<CR>
nnoremap <silent> <c-t> :exec "e " . g:LAST_TEST<CR>

nnoremap <silent> <leader>a :call TMuxExecute('build ' . g:BUILD_TARGETS, 'build', 0)<CR>
nnoremap <silent> <leader>c :call TMuxExecute('c', 'build', 0)<CR>
nnoremap <silent> <leader>S :call TMuxExecute('bash', 'interactive', 0)<CR>
nnoremap <silent> <leader>r :call TMuxExecute('$PATH_TO_MEMSQL/memsqld ' . g:MEMSQL_ARGS, 'server', 1)<CR>

nnoremap <silent> <leader>e :checktime<cr>

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

nnoremap <silent> & :exec 'VimGrep \b' . expand('<cword>') . '\b'<cr>
vnoremap <silent> & :exec 'VimGrep \b' . s:get_range() . '\b'<cr>
comm! -nargs=0 -range GdbVEval exec 'GdbEval ' . s:get_range()

nnoremap <silent> <F6>  :exec "GdbEval " . expand("<cword>")<CR>
vnoremap <silent> <F6>  :GdbVEval<cr>

nnoremap <silent> <Insert> :GdbContinue<cr>
nnoremap <silent> <Home> :GdbUntil<cr>
nnoremap <silent> <S-Up> :GdbExec finish<cr>
nnoremap <silent> <S-Down> :GdbExec step<cr>
nnoremap <silent> <S-Right> :GdbExec next<cr>
nnoremap <silent> <S-Left> :GdbToggle<cr>
noremap <silent> <PageUp> :GdbExec up<cr>
noremap <silent> <PageDown> :GdbExec down<cr>

function! GdbFrame()
    if v:count == 0
        GdbBacktrace
    else
        exec "GdbExec frame " . string(v:count)
    endif
endfunction
nnoremap <silent> <End> :<C-U>call GdbFrame()<cr>

function! s:start_debugging(dbg_args, cmd)
    if GdbIsAttached()
        GdbExec run
    else
        cd $PATH_TO_MEMSQL
        call TMuxExecute('', 'exit', 0)
        exec 'GdbStartDebugger --lock=build.lock ' . a:dbg_args . ' -args ' . a:cmd . ' ' . g:MEMSQL_ARGS
        " call TMuxExecute('', '', 0)
        wincmd =
    endif
endfunction
command! -nargs=1 DbgRun    call s:start_debugging('-ex r', <f-args>)
command! -nargs=1 DbgWait   call s:start_debugging('', <f-args>)

nnoremap <silent> <leader>b :DbgWait ./memsqld<cr>
nnoremap <silent> <leader>B :DbgRun  ./memsqld<cr>
nnoremap <silent> <leader>C :FindCores<cr>

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

nnoremap <silent> <leader>g :GitShow<space>
nnoremap <silent> <leader>G :OriginalFile<cr>

nnoremap <silent> <leader>m :RemoteMake<cr>

command! -nargs=1 Curl read!curl -s <q-args>

function! s:mrp(arg)
    if a:arg
        exec 'edit ' . system("mrp -r'" . getcwd() . "' -n " . a:arg)
    else
        let queries_raw = system("vim_mrp.py -r'" . getcwd() . "'")
        let queries_list = split(queries_raw, '\n')

        let llist = []
        for query in queries_list
            let item = {}
            let i = match(query, "\t")
            let item['filename'] = strpart(query, 0, i)
            let item['text'] = strpart(query, i)
            let llist += [ item ]
        endfor
        call setqflist(llist)
        copen
        wincmd J
    end
endfunction

command! -nargs=? Mrp call s:mrp(<q-args>)
nnoremap <silent> <leader>M :Mrp<cr>

function! s:GetSettings(settings)
    let buf = ''
    for setting in a:settings
        if !exists('g:' . setting)
            let g:{setting}=''
        endif
        let name = "g:" . setting
        let buf = buf . 'let ' . name . "='" . eval(name) . "'\n"
    endfor
    return buf
endfunction

function! s:SetSettings()
    norm ggyG
    @"
endfunction

function! s:EditSettings(settings)
    tabnew
    setlocal buftype=nofile bufhidden=wipe
    let old_o = @o
    let @o = s:GetSettings(a:settings)
    silent put o
    let @o = old_o
    au BufLeave <buffer> call s:SetSettings()
endfunction

command! -nargs=0 Settings call s:EditSettings(['BUILD_TARGETS', 'MEMSQL_ARGS', 'TEST_ARGS'])
nnoremap <silent> <leader>s :Settings<CR>

highlight SignColumn guibg=Black guifg=White ctermbg=None ctermfg=White

