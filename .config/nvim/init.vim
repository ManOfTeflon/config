let g:python_host_prog = '/home/mandrews/.pyenv/versions/2.7.17/bin/python'
let g:python3_host_prog = '/home/mandrews/.pyenv/versions/3.6.9/bin/python'

set undodir=/home/mandrews/.cache/nvim/undo/
set undofile
set autoread
au FocusGained,CursorHold * :checktime

set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o
set title
set number
set hlsearch
set incsearch
set smartcase
set lazyredraw

set splitbelow
set splitright

let mapleader=","

let g:clipboard = {
    \   'name': 'myClipboard',
    \   'copy': {
    \      '+': 'tmux load-buffer -',
    \      '*': 'tmux load-buffer -',
    \    },
    \   'paste': {
    \      '+': 'tmux save-buffer -',
    \      '*': 'tmux save-buffer -',
    \   },
    \   'cache_enabled': 1,
    \ }

set sessionoptions=curdir,help,blank,tabpages

let g:airline_symbols = { 'space': ' ', 'maxlinenr': '' }
" let g:airline_theme='night_owl'
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
let g:airline_symbols.dirty = ''
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  if g:airline_theme == 'night_owl'
    let a:palette.normal.airline_c[3] = 233
    let a:palette.insert.airline_c[3] = 233
    let a:palette.visual.airline_c[3] = 233
    let a:palette.replace.airline_c[3] = 233
    let a:palette.inactive.airline_c[3] = 233
  endif
endfunction

let g:gitgutter_sign_allow_clobber = 0

let g:db = "postgresql://postgres:example@localhost:5433/impira"

command! -nargs=+ -complete=custom,s:GrepArgs VimGrep exe "CocList grep ".escape(<q-args>, " ")

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

nnoremap <silent> <leader>n :NERDTreeFind<CR>
autocmd filetype nerdtree call NERDTree_mappings()
function! NERDTree_mappings()
  nmap <silent> <buffer>- u
  " noremap <silent> <buffer><esc> :NERDTreeClose<cr>
endfunction
nnoremap <silent> yf :let @+=expand('%')<cr>

nnoremap cd :Gcd<cr>

augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * if argc() == 0 | NERDTree | wincmd p | endif
augroup END

autocmd filetype org call OrgMode_mappings()
function! OrgMode_mappings()
  nmap <buffer> <silent> <localleader>? :H vim-orgmode<cr>
  nmap <buffer> <silent> o <cr>
  nmap <buffer> <silent> O <c-s-cr>
endfunction
nnoremap <silent> yf :let @+=expand('%')<cr>

call plug#begin('~/.cache/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'jceb/vim-orgmode'
Plug 'google/vim-jsonnet'
Plug 'AndrewRadev/linediff.vim'
" Plug 'tpope/vim-dispatch'
Plug 'airblade/vim-gitgutter'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'tpope/vim-dadbod'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'ManOfTeflon/exterminator'

call plug#end()

set mouse=a
colorscheme elflord

filetype plugin indent on
syntax on

au BufRead,BufNewFile *.tsx set ft=typescript.tsx
au BufRead,BufNewFile *.jsx set ft=javascript.jsx
au BufRead,BufNewFile *.yxx set ft=yacc
au BufRead,BufNewFile *.sql.tmpl set ft=sql
au BufRead,BufNewFile *.tpst set ft=sql
au BufRead,BufNewFile *.tql set ft=tql

nnoremap L <C-i>
nnoremap H <C-o>
nnoremap \ ;
vnoremap \ ;

nnoremap Q @q

cnoremap q!! %!sudo tee > /dev/null %
cnoremap <c-a> <Home>
cnoremap <c-b> <Left>
cnoremap <c-d> <Del>
cnoremap <c-e> <End>
cnoremap <c-f> <Right>
cnoremap <c-n> <Down>
cnoremap <c-p> <Up>
cnoremap <esc><c-b> <S-Left>
cnoremap <a-b> <S-Left>
cnoremap <esc><c-f> <S-Right>
cnoremap <a-f> <S-Right>

cnoreabbrev H vert bo h

set grepprg=git\ grep\ -wn\ $*
nnoremap * *N
nmap <silent> <c--> :cd %:h \| e .<cr>

set modelines=0
set viminfo+=!

set wrapscan

func! s:SetTabWidth(value, local)
    let command = a:local ? "setlocal" : "set"
    exec command . " softtabstop=" . a:value
    exec command . " shiftwidth=" . a:value
endf

call s:SetTabWidth(4, 0)
au FileType typescript call s:SetTabWidth(2, 1)
au FileType typescript.tsx call s:SetTabWidth(2, 1)
au FileType javascript call s:SetTabWidth(2, 1)
au FileType scss call s:SetTabWidth(2, 1)

set expandtab
set nosmarttab
set backspace=indent,eol,start
set autoindent
set cindent
set wildmenu
set wildmode=list:longest:full
set ttyfast
set cursorline

set showcmd
set ruler

set cmdheight=1

set formatoptions=c,q,r,t

set scrolloff=100

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
set noswapfile

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

nnoremap ; :
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
vnoremap r "_dP
set clipboard=unnamedplus

nnoremap <silent> <leader><space> :noh<cr>
nnoremap <leader>v V`]

nnoremap <leader>h <c-w>v<c-w>h
nnoremap <leader>j <c-w>s
nnoremap <leader>k <c-w>s<c-w>k
nnoremap <leader>l <c-w>v

nnoremap <silent> <leader><tab> :tabe .<cr>
nnoremap <silent> <tab> :tabn<cr>
nnoremap <silent> <s-tab> :tabN<cr>
nnoremap <silent> <c-d> :q<cr>
nnoremap <s-up> <c-w>+
nnoremap <s-down> <c-w>-
nnoremap <s-left> <c-w><
nnoremap <s-right> <c-w>>

highlight clear VertSplit
highlight Normal ctermbg=234
highlight CocHighlightText ctermbg=237
highlight CocInlayHint ctermfg=8
highlight VertSplit guifg=#5f00d7 ctermfg=56
highlight SignColumn guibg=Black guifg=White ctermbg=None ctermfg=White
highlight TabLineFill ctermfg=Black ctermbg=Black
highlight TabLine ctermfg=White ctermbg=141
highlight TabLineSel ctermfg=LightGray ctermbg=91
highlight Pmenu cterm=bold ctermfg=LightGray ctermbg=black
highlight PmenuSel cterm=bold ctermfg=85 ctermbg=black
highlight TrailingWhitespace ctermbg=Magenta
au Syntax * syn match TrailingWhitespace /\s\+$/
highlight HardTab ctermbg=Black
au Syntax * syn match HardTab /\t/ containedin=goRawString
au Syntax * syn match HardTab /\t/ containedin=makeNextLine
set fillchars+=vert:\│

" Always add the current file's directory to the path and tags list if not
" already there. Add it to the beginning to speed up searches.
let default_path = escape(&path, '\ ') " store default value of 'path'
au BufRead *
      \ let tempPath=escape(escape(expand("%:p:h"), ' '), '\ ')."/**" |
      \ exec "set path-=".tempPath |
      \ exec "set path-=".default_path |
      \ exec "set path^=".tempPath |
      \ exec "set path^=".default_path

highlight Folded guibg=#5fffff ctermbg=87 guifg=Red ctermfg=Red
highlight FoldColumn guibg=Black ctermbg=Black guifg=White ctermfg=White
highlight Search guibg=Magenta ctermbg=Magenta guifg=White ctermfg=White

highlight DiffAdd gui=bold cterm=bold guifg=#5fffaf ctermfg=85 guibg=#1c1c1c ctermbg=234
highlight DiffDelete gui=bold cterm=bold guifg=#ff0000 ctermfg=196
highlight DiffChange guifg=#d7ff00 ctermfg=190 guibg=#444444 ctermbg=238
highlight link DiffText String

nnoremap <silent> <leader>ev :e /home/mandrews/.config/nvim/init.vim<CR>
nnoremap <silent> <leader>sv :so /home/mandrews/.config/nvim/init.vim<CR>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> pg <Plug>(coc-diagnostic-info)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> ` <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> <leader>` <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ~ <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList

nnoremap <silent> <a-e> :<C-u>CocList files<CR>
nnoremap <silent> <c-e> :<C-u>CocList files<CR>
nnoremap <silent> <a-o> :<C-u>CocList outline<CR>
nnoremap <silent> <a-p> :<C-u>CocList -I symbols<CR>
nnoremap <silent> <a-?> :<C-u>CocList -A --normal diagnostics<cr>
nnoremap <silent> <a-/> :<C-u>exe 'VimGrep '.expand('<cword>')<CR>
nnoremap <silent> <a-y> :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> <a-q> :<C-u>CocList quickfix<cr>

nnoremap <silent> ]<space>  :<C-u>CocNext<CR>
nnoremap <silent> [<space>  :<C-u>CocPrev<CR>
nnoremap <silent> p<space>  :<C-u>CocListResume<CR>

command! -nargs=0 Gtree call Gtree_tab()
highlight GtreeSelected ctermfg=red ctermbg=235
func! Gtree_select(word)
    if exists('b:Gtree_select_match')
        call matchdelete(b:Gtree_select_match)
        unlet b:Gtree_select_word
        unlet b:Gtree_select_match
    endif
    if a:word != ''
        let b:Gtree_select_word = a:word
        let b:Gtree_select_match = matchadd('GtreeSelected', a:word)
    endif
endf
func! Gtree_selected()
    if !exists('b:Gtree_select_word')
        echoerr 'No selected revision'
        return
    endif

    return b:Gtree_select_word
endf
func! Gtree_checkout()
    let revision = Gtree_selected()
    call system('git checkout ' . revision)
    call Gtree_open()
endf
func! Gtree_rebase()
    let revision = Gtree_selected()
    exec 'Grebase ' . expand('<cword>') . ' ' . revision
endf
func! Gtree_tab()
    tabe
    call Gtree_open()
endf
func! Gtree_open()
    call Gtree_select('')
    te git --no-pager tree -n1000
    setlocal nonumber
    setlocal filetype=gittree
    nnoremap <silent> <buffer> <space> :call Gtree_select(expand('<cword>'))<cr>
    nnoremap <silent> <buffer> <esc> :call Gtree_select('')<cr>
    nnoremap <silent> <buffer> r :call Gtree_open()<cr>
    nnoremap <silent> <buffer> c :call Gtree_checkout()<cr>
    nnoremap <silent> <buffer> m :call Gtree_rebase()<cr>
endf

func! s:ToggleMaximize()
    exec 'tab sb ' . bufnr()
endf
command! -nargs=0 ToggleMaximize call s:ToggleMaximize()
nnoremap <silent> <c-a>z :ToggleMaximize<cr>

func! s:Gwin(cmd)
    exec 'vert bo ' . a:cmd
    vertical resize 64
    let b:natural_width = 64
    nnoremap <silent> <buffer> A :ToggleMaximize<cr>
    setlocal winfixwidth
    setlocal nowrap
    norm <c-w>=
endf
command! -nargs=1 Gwin call s:Gwin(<f-args>)

func! s:Gmergediff(...)
    let file=expand('%')
    let merge_head="MERGE_HEAD"
    if a:0 >= 1
        let merge_head=a:1
    endif
    let head="HEAD"
    if a:0 >= 2
        let head=a:2
    endif
    exec 'vert rightb Git diff ' . head . ' ' . merge_head . ' -- ' . file
    exec 'file git diff ' . head . ' ' . merge_head . ' -- ' . file
endf
command! -nargs=* Gmergediff call s:Gmergediff(<f-args>)

func! s:Gmergediffs(...)
    let file=expand('%')
    let merge_head="MERGE_HEAD"
    if a:0 >= 1
        let merge_head=a:1
    endif
    let head="HEAD"
    if a:0 >= 2
        let head=a:2
    endif
    if a:0 >= 3
        let merge_base=a:3
    else
        let merge_base=system('git merge-base ' . head . ' ' . merge_head)
    endif

    exec 'vert Git diff ' . merge_base . ' ' . merge_head . ' -- ' . file
    exec 'file git diff ' . merge_base . ' ' . merge_head . ' -- ' . file
    wincmd l
    exec 'vert rightb Git diff ' . merge_base . ' ' . head . ' -- ' . file
    exec 'file git diff ' . merge_base . ' ' . head . ' -- ' . file
    wincmd h
endf
command! -nargs=* Gmergediffs call s:Gmergediffs(<f-args>)

command! -nargs=0 Grebasediffs call s:Gmergediffs('rebase-apply/orig-head')

nnoremap <silent> <F2> :Gwin G<cr>
nnoremap <silent> <F3> :Gwin Gdiff HEAD<cr>
nnoremap <silent> <F4> :tabe term://git commit<cr>
nnoremap <silent> <F5> :Gtree<cr>

func! s:FindMergeMarker(tokens, jump, forward)
    let s:pattern = '^\('
    for s:token in split(a:tokens, '\zs')
        if s:pattern != '^\('
            let s:pattern = s:pattern . '\|'
        endif
        let s:pattern = s:pattern . repeat(s:token, 7)
    endfor
    let s:pattern = s:pattern . '\)'

    let s:flags = 'cW'

    if !a:jump
        let s:flags = s:flags . 'n'
    endif

    if !a:forward
        let s:flags = s:flags . 'b'
    endif

    let s:ret = search(s:pattern, s:flags)
    if a:jump
        let @/ = s:pattern
    endif

    return s:ret
endf

func! s:FindCurrentMergeRange(whole)
    let s:tokens = '<=|>'
    if a:whole
        let s:tokens = '<>'
    endif

    let s:start = s:FindMergeMarker(s:tokens, 0, 0)
    let s:end = s:FindMergeMarker(s:tokens, 0, 1)

    if s:start == 0 || s:end == 0 || s:start >= s:end
        return [0, 0]
    endif

    return [s:start, s:end]
endf

func! s:FindNextMergeConflict()
    call s:FindMergeMarker('=', 1, 1)
endf

func! s:DiffCurrentMergeRange()
    let [s:start, s:end] = s:FindCurrentMergeRange(0)
    if s:start > 0 && s:end > 0
        call linediff#Linediff(s:start+1, s:end-1, {})
    endif
endf

func! s:UseCurrentMergeRange()
    let [s:start, s:end] = s:FindCurrentMergeRange(0)
    let [s:whole_start, s:whole_end] = s:FindCurrentMergeRange(1)
    echo [s:start, s:end, s:whole_start, s:whole_end]
    if s:start > 0 && s:end > 0 && s:whole_start > 0 && s:whole_end > 0
        exec s:whole_start . ',' . s:start . 'd'
        let s:deleted = s:start - s:whole_start + 1
        let s:end = s:end - s:deleted
        let s:whole_end = s:whole_end - s:deleted
        exec s:end . ',' . s:whole_end . 'd'
    endif
endf

command! -nargs=0 Mergefind call s:FindNextMergeConflict()
command! -nargs=0 Mergediff call s:DiffCurrentMergeRange()
command! -nargs=0 Mergeuse  call s:UseCurrentMergeRange()

nnoremap <silent> <leader>mf :Mergefind<cr>
nnoremap <silent> <leader>md :Mergediff<cr>
nnoremap <silent> <leader>mu :Mergeuse<cr>

command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

" Turn this into a plugin...
augroup twig_ft
  au!
  autocmd BufNewFile,BufRead *.co set syntax=sql
augroup END

