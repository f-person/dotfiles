let mapleader =","
let g:loaded_matchit = 1

call plug#begin('~/.vim/plugged')

"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'andymass/vim-matchup'
Plug 'voithos/vim-python-matchit'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'https://gitlab.com/code-stats/code-stats-vim.git'
Plug 'dart-lang/dart-vim-plugin'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/goyo.vim'
Plug 'fatih/vim-go'
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'kmyk/brainfuck-highlight.vim', { 'autoload' : { 'filetypes' : 'brainfuck' } }
Plug 'ryanoasis/vim-devicons'
Plug 'lervag/vimtex'
Plug 'terryma/vim-multiple-cursors'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'justinmk/vim-sneak'
Plug 'elixir-editors/vim-elixir'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'leafgarland/typescript-vim'
Plug 'habamax/vim-godot'

" Lua
Plug 'andrejlevkovitch/vim-lua-format'
Plug 'euclidianAce/BetterLua.vim'
Plug 'tjdevries/nlua.nvim'

Plug 'f-person/nvim-sort-dart-imports'
"Plug 'f-person/pubspec-assist-nvim'
"Plug 'f-person/git-blame.nvim'
Plug '/Users/fperson/workspace/personal_projects/git-blame.nvim'
Plug '/Users/fperson/workspace/personal_projects/pubspec-assist-nvim'
Plug '/Users/fperson/workspace/personal_projects/auto-dark-mode.nvim'


"Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': 'dart'}
Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'

Plug 'luochen1990/rainbow'
Plug 'gruvbox-community/gruvbox'
Plug 'projekt0n/github-nvim-theme'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mhartington/formatter.nvim'

Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

syntax on
set background=dark
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"
colorscheme gruvbox
let g:rainbow_active = 1
set colorcolumn=80
lang en_US.UTF-8

highlight link luaOperator Special
hi! link LspDiagnosticsDefaultError GruvboxRed
hi! link LspDiagnosticsSignError GruvboxRedSign
hi! link LspDiagnosticsDefaultWarning GruvboxYellow
hi! link LspDiagnosticsSignWarning GruvboxYellowSign
hi! link LspDiagnosticsDefaultInformation GruvboxBlue
hi! link LspDiagnosticsSignInformation GruvboxBlueSign
hi! link LspDiagnosticsDefaultHint GruvboxAqua
hi! link LspDiagnosticsSignHint GruvboxAquaSign

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
set hidden

" codestats config
source ~/.config/nvim/codestats_api_key.vim

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

nnoremap <leader>ph :GitGutterPreviewHunk<cr>

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

let g:didSetCocConfigs = 0
function! SetCocConfigs()
  if g:didSetCocConfigs == 1
	return
  endif

  let g:didSetCocConfigs = 1

  nmap <leader>ca v<Plug>(coc-codeaction-selected)
  nmap gd :call CocActionAsync('jumpDefinition')<CR>
  nmap <leader>gr <Plug>(coc-references)
  nmap <leader>rr <Plug>(coc-rename)
  nmap cd :CocList diagnostics<CR>
  nmap K :call CocActionAsync('doHover')<CR>

  " Better display for messages
  set cmdheight=2
  " Smaller updatetime for CursorHold & CursorHoldI
  set updatetime=300
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

function GDScriptFormat()
	silent !gdformat %:p
	:e
endfunction

autocmd FileType gdscript :command! -buffer GDScriptFormat call GDScriptFormat()

" autoformat
"au BufWrite *.dart :DartFmt
augroup sortDartImports
	autocmd!
    "autocmd BufWrite *.dart :FormatWrite
	autocmd BufWrite *.dart :DartFmt
	autocmd BufWrite *.dart :DartSortImports
augroup END

autocmd FileType cpp au BufWritePost *cpp :FormatWrite

autocmd FileType lua au BufWrite *lua call LuaFormat()
autocmd FileType javascript au BufWrite * :PrettierAsync
autocmd FileType typescript au BufWrite * :PrettierAsync
"autocmd FileType gdscript au BufWritePost *gd call GDScriptFormat()

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
let g:go_gopls_options=['-remote=auto']

let g:go_fmt_command = "golines"
let g:go_fmt_options = {
    \ 'golines': '-m 80 --base-formatter gofmtrlx',
    \ }

autocmd FileType dart set expandtab
autocmd FileType dart set tabstop=2
autocmd FileType dart set shiftwidth=2

autocmd FileType cpp set expandtab
autocmd FileType cpp set tabstop=2
autocmd FileType cpp set shiftwidth=2

autocmd FileType json set expandtab
autocmd FileType json set tabstop=2
autocmd FileType json set shiftwidth=2

autocmd FileType yaml set expandtab
autocmd FileType yaml set tabstop=2
autocmd FileType yaml set shiftwidth=2

autocmd FileType lua set expandtab

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

autocmd BufEnter,BufNew *.dart call SetCocConfigs()

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Manual completion trigger
imap <silent> <c-f> <Plug>(completion_trigger)

let g:completion_matching_ignore_case = 1

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

let g:tex_flavor = 'latex'

autocmd FileType lua let g:completion_confirm_key = "\<C-Y>"

autocmd FileType markdown nmap j gj
autocmd FileType markdown nmap k gk

let g:gitblame_message_template = ' <author> • <date> • <summary> • <sha>'
let g:gitblame_date_format = '%r'
let g:gitblame_position = "right_align"
let g:gitblame_set_extmark_options = {
	\ 'priority': 13,
	\ }

