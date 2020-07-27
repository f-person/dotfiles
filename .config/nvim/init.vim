let mapleader =","

call plug#begin('~/.vim/plugged')

Plug 'https://gitlab.com/code-stats/code-stats-vim.git'
Plug 'vim-airline/vim-airline'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/goyo.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'kmyk/brainfuck-highlight.vim', { 'autoload' : { 'filetypes' : 'brainfuck' } }
Plug 'ryanoasis/vim-devicons'
Plug 'lervag/vimtex'
Plug 'luochen1990/rainbow'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'andrejlevkovitch/vim-lua-format'
Plug 'justinmk/vim-sneak'
Plug 'elixir-editors/vim-elixir'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'

Plug '/home/fperson/workspace/personal_projects/nvim-sort-dart-imports'
Plug '/home/fperson/workspace/personal_projects/pubspec-assist-nvim'

Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': 'dart'}
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'nvim-lua/completion-nvim'

Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

syntax on
color gruvbox
set background=dark
let g:gruvbox_contrast_dark="hard"
let g:rainbow_active = 1
set colorcolumn=80

set shell=fish
syntax on
set tabstop=4
set shiftwidth=4
filetype on
set nu
set ruler
set mouse=a
set showmatch
set number relativenumber
set splitbelow splitright
set encoding=utf-8
set clipboard+=unnamedplus
set updatetime=50

" codestats config
source ./codestats_api_key.vim
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

" Ctrl + 2hjkl to navigate between splits
nnoremap <C-h> <C-w>
nnoremap <C-j> <C-w>
nnoremap <C-k> <C-w>
nnoremap <C-l> <C-w>

" disabled keys
nnoremap <PageUp> <Nop>
nnoremap <PageDown> <Nop>

" o/O
" Start insert mode with [count] blank lines.
" The default behavior repeats the insertion [count]
" times, which is not so useful.
function! s:NewLineInsertExpr( isUndoCount, command )
    if ! v:count
        return a:command
    endif

    let l:reverse = { 'o': 'O', 'O' : 'o' }
    " First insert a temporary '$' marker at the next line (which is necessary
    " to keep the indent from the current line), then insert <count> empty lines
    " in between. Finally, go back to the previously inserted temporary '$' and
    " enter insert mode by substituting this character.
    " Note: <C-\><C-n> prevents a move back into insert mode when triggered via
    " |i_CTRL-O|.
    return (a:isUndoCount && v:count ? "\<C-\>\<C-n>" : '') .
    \   a:command . "$\<Esc>m`" .
    \   v:count . l:reverse[a:command] . "\<Esc>" .
    \   'g``"_s'
endfunction
nnoremap <silent> <expr> o <SID>NewLineInsertExpr(1, 'o')
nnoremap <silent> <expr> O <SID>NewLineInsertExpr(1, 'O')

nmap <leader>rg :Rg<CR>
nmap <C-p> :GFiles<CR>
nnoremap <Leader>pf :Files<CR>

function! SetCocConfigs()
  nmap ca :CocCommand actions.open<CR>
  nmap gd :call CocActionAsync('jumpDefinition')<CR>
  nmap <leader>gr <Plug>(coc-references)
  nmap <leader>rr <Plug>(coc-rename)
  nmap cd :CocList diagnostics<CR>

  " coc.nvim config
  " if hidden is not set, TextEdit might fail.
  set hidden
  " Better display for messages
  set cmdheight=2
  " Smaller updatetime for CursorHold & CursorHoldI
  set updatetime=300
  "don't give |ins-completion-menu| messages.
  set shortmess+=c
  " always show signcolumns
  set signcolumn=yes
  " use <tab> for trigger completion and navigate to the next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  " use <c-space>for trigger completion
  inoremap <silent><expr> <c-space> coc#refresh()

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
endfunction

function SortDartImports()
	if &filetype == 'dart'
		:DartSortImports
	endif
endfunction

" autoformat
autocmd FileType dart au BufWrite * call CocActionAsync('format')
autocmd FileType dart au BufWrite * call SortDartImports()
autocmd FileType lua au BufWrite *lua call LuaFormat()
"autocmd FileType javascript au BufWrite * :CocCommand prettier.formatFile

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
let g:go_gpls_enabled = 0

let g:go_fmt_command = "golines"
let g:go_fmt_options = {
    \ 'golines': '-m 80 --base-formatter gofmtrlx',
    \ }

autocmd FileType dart set expandtab
autocmd FileType dart set tabstop=2
autocmd FileType dart set shiftwidth=2

autocmd FileType json set expandtab
autocmd FileType json set tabstop=2
autocmd FileType json set shiftwidth=2

if ! has('gui_running')
	set ttimeoutlen=10
	augroup FastEscape
		autocmd!
		au InsertEnter * set timeoutlen=0
		au InsertLeave * set timeoutlen=1000
	augroup END
endif

" icons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

autocmd BufEnter,BufNew *.love set filetype=lua
autocmd BufEnter,BufNew *.dart call SetCocConfigs()

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_matching_ignore_case = 1

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ completion#trigger_completion()

luafile ~/.config/nvim/init.lua
