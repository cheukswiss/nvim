" =========================
"          KEY MAP
" =========================
let mapleader=" "
imap jj <ESC>
noremap J 5j
noremap K 5k
noremap H 5h
noremap L 5l
noremap <LEADER><CR> :nohlsearch<CR>

map s <nop>
map S :w<CR>
map Q :q<CR>
map E :e!<CR>

map sv <C-w>t<C-w>H
map sh <C-w>t<C-w>K

map si :set splitright<CR>:vsplit<CR>
map sn :set nosplitright<CR>:vsplit<CR>
map su :set nosplitbelow<CR>:split<CR>
map se :set splitbelow<CR>:split<CR>

map <LEADER>l <C-w>l
map <LEADER>k <C-w>k
map <LEADER>h <C-w>h
map <LEADER>j <C-w>j

map <up> :res -5<CR>
map <down> :res +5<CR>
map <left> :vertical resize+5<CR>
map <right> :vertical resize-5<CR>

nmap tu :tabe<CR>
nmap tj :-tabnext<CR>
nmap tk :+tabnext<CR>

nmap <LEADER>m :set mouse=a<CR>

syntax on
set number
set norelativenumber
set cursorline
set wrap
set showcmd
set wildmenu

set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase


set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set encoding=utf-8
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" set list
set scrolloff=5
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set autochdir
 
set clipboard+=unnamed 

call plug#begin('~/.config/nvim/site/autoload/')

Plug 'Yggdroot/indentLine'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'crusoexia/vim-monokai'
Plug 'connorholyday/vim-snazzy'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

call plug#end()

" colorscheme dracula
" colorscheme monokai
colorscheme snazzy

" IndentLine
let g:indent_guides_guide_size            = 1  " 指定对齐线的尺寸
let g:indent_guides_start_level           = 2  " 从第二层开始可视化显示缩进

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap tt :NERDTree<CR>
nnoremap tv :NERDTreeToggle<CR>
nnoremap tf :NERDTreeFind<CR> 

" Bash Language Server 
let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start']
    \ }









