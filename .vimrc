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

set nocp

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim72/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

filetype off

" directory
set directory=/home/mandrews/.vim

" leader key to ,
let mapleader=","

set sessionoptions=curdir,help,blank,folds,tabpages

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'
Bundle 'xolox/vim-misc'

Bundle 'xolox/vim-session'

Bundle 'EasyMotion'

Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'SkidanovAlex/CtrlK'

Bundle 'airblade/vim-rooter'
Bundle 'ton/vim-bufsurf'

Bundle 'bling/vim-airline'

nnoremap L :BufSurfForward<cr>
nnoremap H :BufSurfBack<cr>
nnoremap <F4> :BufSurfList<cr>
nnoremap _ H
nmap f <Leader><Leader>f
nmap F <Leader><Leader>F

let g:ctrlk_clang_library_path="/usr/lib/llvm-3.3/lib"
nnoremap <F3> :call GetCtrlKState()<CR>
nnoremap <F2> :call CtrlKNavigateSymbols()<CR>
nnoremap ` :call CtrlKGoToDefinition()<CR>
nnoremap ~ :call CtrlKGetReferences()<CR>

nnoremap <space> @q

nmap & *:!git grep -n \\b<cword>\\b<cr>
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

" set relativenumber
" set undofile

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

"allows sudo with :w!!
cmap w!! %!sudo tee > /dev/null %

" auto indent
filetype plugin indent on

" maintain more context around cursor
set scrolloff=100

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
vmap w wh
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

" auto-save on leaving focus
au FocusLost * :wa
au VimResized * <c-w>=

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
nnoremap <leader>b :! bash<CR>
nnoremap <S-UP> <C-w>+
nnoremap <S-DOWN> <C-w>-
nnoremap <S-LEFT> <C-w><
nnoremap <S-RIGHT> <C-w>>

highlight SignColumn gui=bold ctermbg=Black ctermfg=White
highlight Cursor ctermbg=None ctermfg=23

function! HighlightCursor()
  let cword=expand("<cword>")
  if cword =~ '\<\*\?\h\w*'
    let cword = substitute(cword, "/", "\/", "g")
    exec 'match Cursor /\<'.cword.'\>/'
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
hi Search guibg=LightBlue ctermbg=LightBlue guifg=Black ctermfg=Black

" Tex-Live grep fix
set grepprg=grep\ -nH\ $*

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

let g:extension_cycle = ['.c', '.cc', '.cpp', '.h', '.hpp', '.ipp', '']
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
