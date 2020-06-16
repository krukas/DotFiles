" Enable pathogen to load vim plugins 
execute pathogen#infect()

" Rebind <leader> key
let mapleader = "\<Space>"

" Styling
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syntax enable
set number
set relativenumber
set t_Co=256
" let python_highlight_all = 1
set background=dark
colorscheme monokai
set encoding=utf-8

" default syntax
set filetype=python

" faster redrawing
set ttyfast

" Enable highlight search + add toggle
set hlsearch
nnoremap <F3> :set hlsearch!<CR>

" Tab display and insert settings
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
filetype plugin indent on
set noexpandtab " insert tabs rather than spaces for <Tab>
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
set shiftround " round indent to a multiple of 'shiftwidth'
" Overwrite setting for ftplugin/python.vim
autocmd BufNewFile,BufRead *.py setlocal tabstop=4
autocmd BufNewFile,BufRead *.py setlocal noexpandtab

" Buffer Settings
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Shows open buffers on top
let g:airline#extensions#tabline#enabled = 1

" Allow hidden changed buffers
set hidden

" Open a new empty buffer
nmap <leader>t :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
nmap <leader>e :bp <BAR> bd #<CR>


" Window
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" map window movement <ctrl>+j/k/h/l create new window if not exists 
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

map <C-h> :call WinMove('h')<cr>
map <C-j> :call WinMove('j')<cr>
map <C-k> :call WinMove('k')<cr>
map <C-l> :call WinMove('l')<cr>


" General leader key shortcuts
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Close window with leader q
 noremap <leader>q :q<cr>

" Save window with w
noremap <leader>w :w<cr>

" comment out text
noremap <leader>/ :Commentary<cr>

" goto defenition
nnoremap <leader>g :YcmCompleter GoTo<CR>

" run python code
nnoremap <silent> <F5> :!clear;python3 %<CR>
" open fussy file search
let g:ctrlp_map = '<c-p>'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/env/*
let g:ctrlp_working_path_mode = 'ra'

" Diable gitgutter leader key mappings
let g:gitgutter_map_keys = 0

" Disable case sensitve searching
set ignorecase

" Save document CTRL+Z
" noremap <C-Z> :update<CR>
" vnoremap <C-Z> <C-C>:update<CR>
" inoremap <C-Z> <C-O>:update<CR>

set wildmenu " enhanced command line completion
set wildmode=list:longest " complete files like a shell
set showcmd " show incomplete commands
set noshowmode " don't show which mode disabled for PowerLine
set scrolloff=3 " lines of text around cursor

set showmatch " show matching braces
set matchtime=2 " how many tenths of a second to blink

" Airline settings:
let g:airline_powerline_fonts = 1
set laststatus=2
let g:airline_theme='badwolf'

" Enable mouse support
" set mouse=a

" Change menu color (Monokai)
highlight Pmenu ctermfg=NONE ctermbg=8 cterm=NONE guifg=NONE guibg=NONE gui=NONE
highlight PmenuSel ctermfg=NONE ctermbg=60 cterm=NONE guifg=NONE guibg=#49483e gui=NONE

" python autocomplete
let g:ycm_python_binary_path = '/usr/bin/python3'

" Nerdtree 
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=1
let NERDTreeIgnore = ['__pycache__', '*.pyc']
let NERDTreeShowHidden=1
" let g:nerdtree_tabs_open_on_console_startup=1

" Disable arrow keys in insert
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
map <up> :echo "use k"<CR>
map <down> :echo "use j"<CR>
map <left> :echo "use h"<CR>
map <right> :echo "use l"<CR>
