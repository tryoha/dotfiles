call pathogen#infect()
syntax on
filetype plugin indent on
"set mouse=a
"set clipboard=unnamedplus
set nocompatible
set list
set listchars=tab:►·,eol:·,trail:↔
set nobackup
set noundofile
set nowritebackup
set noswapfile
set number
set nowrap
set cursorline
set smartcase
set fileencodings=utf-8,cp1251,koi8-r,cp866
set encoding=UTF-8
set autoindent  " indent when moving to the next line while writing code
set showmatch " show the matching part of the pair for [] {} and ()
set smarttab
set tabstop=4
set softtabstop=4
set expandtab
set hidden
set hlsearch
set ignorecase
set ttyfast
set t_Co=256
set background=dark
colorscheme gruvbox

" ************* NERDTree configuration *************

let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_synchronize_view = 0

map <F3> :NERDTreeToggle<CR>
let g:webdevicons_enable_nerdtree = 1
let g:airline_powerline_fonts = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let NERDTreeShowHidden=1
autocmd BufEnter NERD_tree_* | execute 'normal R'

nmap <F8> :TagbarToggle<CR>
autocmd FileType python,c,cpp TagbarOpen

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['pylint','bandit','pep8','pycodestyle']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

let g:syntastic_aggregate_errors = 1
