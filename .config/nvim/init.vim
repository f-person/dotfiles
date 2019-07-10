let mapleader = " "

call plug#begin('~/.vim/plugged')
Plug 'https://gitlab.com/code-stats/code-stats-vim.git'
Plug 'vim-airline/vim-airline'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'scrooloose/nerdcommenter'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'junegunn/goyo.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

syntax on
let g:dracula_colorterm = 0
color dracula

set shell=bash
syntax on
set tabstop=4
set expandtab
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
autocmd FocusLost * :wa

let g:codestats_api_key = ''
let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype', '%{CodeStatsXp()}'])

nnoremap <leader>fa :FlutterRun<cr>
nnoremap <leader>fq :FlutterQuit<cr>
nnoremap <leader>fr :FlutterHotReload<cr>
nnoremap <leader>fR :FlutterHotRestart<cr>

map <leader>f<leader> :Goyo \| set linebreak<CR>


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
autocmd FileType dart    map <leader>b<leader> :w !dart    %:p <CR>
