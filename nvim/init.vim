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
nmap tn :-tabnext<CR>
nmap ti :+tabnext<CR>


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
" set tabstop=4
" set shiftwidth=4
" set softtabstop=4
set list
set scrolloff=5
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set autochdir


call plug#begin('~/.config/nvim/site/autoload/')

        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'

        Plug 'neoclide/coc.nvim', {'branch': 'release'}

        Plug 'preservim/nerdtree'


call plug#end()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
