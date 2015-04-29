#!/bin/sh

GIT="/usr/bin/git"
CURL="/usr/bin/curl"
WGET="/usr/bin/wget"

if [ ! -e $GIT ]; then
    echo "Unable to find git."
    exit 1
elif [ ! -e $CURL ]; then
    echo "Unable to find curl."
    exit 1
elif [ ! -e $WGET ]; then
    echo "Unable to file wget."
    exit 1
fi

mkdir -p ~/.vim/autoload ~/.vim/bundle
mkdir -p ~/.vim/colors
$CURL -so ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
$GIT clone https://github.com/scrooloose/nerdtree.git

cd ~/.vim/colors
$WGET -O wombat256mod.vim "http://www.vim.org/scripts/download_script.php?src_id=13400"

cd ~/.vim/bundle
$GIT clone https://github.com/bling/vim-airline.git

cd ~/.vim/bundle
$GIT clone git://github.com/airblade/vim-gitgutter.git

cd ~/.vim/bundle
$GIT clone https://github.com/kien/ctrlp.vim.git

cd ~/.vim/bundle
$GIT clone git://github.com/davidhalter/jedi-vim.git

cd ~/.vim/bundle
$GIT clone git://github.com/tpope/vim-fugitive.git

cat > ~/.vimrc <<EOM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" VIM as a simple IDE
"" Daniele Vona <danielv99@yahoo.it>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set splitbelow
set splitright

map <C-t> <esc>:tabnew<CR>
let mapleader=","
let g:mapleader=","

" NerdTree File Explorer
" cd ~/.vim/bundle
" git clone https://github.com/scrooloose/nerdtree.git
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.
set pastetoggle=<F2>
set clipboard=unnamed

" Mouse and backspace
"" set mouse=a " on OSX press ALT and click

" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" map sort function to a key
"" vnoremap <Leader>s :sort<CR>

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation

" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
color wombat256mod
autocmd ColorScheme * highlight Normal ctermbg=none

" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on

" Showing line numbers and length
set number " show line numbers
set tw=79 " width of document (used by gd)
set nowrap " don't automatically wrap on load
set fo-=t " don't automatically wrap text when typing

" easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set autoindent

" Setup Pathogen to manage your plugins
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
" Now you can install any plugin into a .vim/bundle/plugin-name/ folder
call pathogen#infect()
call pathogen#helptags()

" Settings for vim-airline
" cd ~/.vim/bundle
" git clone https://github.com/bling/vim-airline.git
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

" Gitgutter
" cd ~/.vim/bundle
" git clone git://github.com/airblade/vim-gitgutter.git
let g:gitgutter_sign_column_always = 0
let g:gitgutter_realtime = 1
highlight clear SignColumn

" Settings for ctrlp
" cd ~/.vim/bundle
" git clone https://github.com/kien/ctrlp.vim.git
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*

" Settings for jedi-vim
" cd ~/.vim/bundle
" git clone git://github.com/davidhalter/jedi-vim.git
let g:jedi#usages_command = "<leader>z"
let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 0
let g:jedi#completions_command = "<C-Space>"
""map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

EOM
