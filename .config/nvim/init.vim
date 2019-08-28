let mapleader = " "

call plug#begin('~/.vim/plugged')
Plug 'https://gitlab.com/code-stats/code-stats-vim.git'
Plug 'vim-airline/vim-airline'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'junegunn/goyo.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

syntax on
let g:dracula_colorterm = 0
color dracula

set shell=bash
syntax on
set tabstop=4
set shiftwidth=4
autocmd FileType dart set shiftwidth=2
filetype on
set nu
set ruler
set mouse=a
set showmatch
set number relativenumber
set splitbelow splitright
set encoding=utf-8
autocmd FileType dart set tabstop=2
set clipboard+=unnamedplus

" codestats config
let g:codestats_api_key = ''
let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype', '%{CodeStatsXp()}'])

nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>

map <leader>f<leader> :Goyo \| set linebreak<CR>

" exit terminal mode
tnoremap <Esc> <C-\><C-n> 

" Ctrl+S to save
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

" Alt+` to switch tab
nmap <m-`> :tabNext<CR>
imap <m-`> <Esc> :tabNext<CR>i
tnoremap <m-`> <C-\><C-n> :tabNext<CR>

" coc.nvim config
" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" autoformat
autocmd FileType dart au BufWrite * :Autoformat
autocmd FileType dart au FocusLost * :Autoformat

autocmd FileType python map <leader>b<leader> :w !python3 %:p <CR>
autocmd FileType dart   map <leader>b<leader> :w !dart    %:p <CR>

" go config
nmap <c-g> :GoImports<CR>
imap <c-g> <Esc>:GoImports<CR>a

let g:go_code_completion_enabled = 0
let g:go_highlight_extra_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:jedi#completions_enabled = 0

if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif
