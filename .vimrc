" ln -s /Users/eddie/code/configs/.vimrc /Users/eddie/.vimrc

"------------ plugs --------------

call plug#begin('~/.vim/plugged')
Plug 'Townk/vim-autoclose'
Plug 'w0rp/ale'
"Plug 'mileszs/ack.vim'
"Plug 'joshdick/vim-action-ack'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-sleuth'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
"Plug 'janko-m/vim-test'
Plug 'jalvesaq/Nvim-R'
Plug 'vim-scripts/indentpython.vim'
call plug#end()

"------------ theme ---------------

syntax on
colorscheme onedark
set termguicolors

"------------- NERDTree -----------

:map <C-n> :NERDTreeToggle<CR>

"------------- mappings -----------

:map / <Plug>(incsearch-forward)
:map ? <Plug>(incsearch-backward)
:map g/ <Plug>(incsearch-stay)
:map ;; <Esc> :w <Enter>
:map <C-down> <C-e>
:map <C-up> <C-y>
:map <C-S-down> <C-d> zz
:map <C-S-up> <C-u> zz
:map <C-c> "+y<CR>"

:imap ;; <Esc> :w <Enter>
:imap <C-l> console.log('');<ESC>hhi

:nmap * <Plug>AckActionWord
:nmap <Space> <Esc>
:nmap <C-l> aconsole.log('');<ESC>hhi

:vmap * <Plug>AckActionVisual
:vmap <Space> <Esc>

"---------- custom commands --------
:command Hist ! git log --pretty=format:"\%C(yellow)>>>|\%h|\%Cred\%ad|\%Cblue\%an|\%Creset\%s" --date=format:"\%Y-\%m-\%d \%H:\%M" -p $(echo %) | sed -e '/>>>|/{n;N;N;N;d;}' | sed -e 's/\(^-.*$\)/'$(printf "\033[91m")'\1'$(printf "\033[0m")'/g' | sed -e 's/\(^+.*$\)/'$(printf "\033[92m")'\1'$(printf "\033[0m")'/g'

"---------- vim-action-ack configs --------

"Alias 'ag' commands for use with ack.vim
" gaiw : search the work
" gai' : search the words inside single quotes
" ga   : search the selected text
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
command! Ag Ack

"Use ag if it's available
if executable('ag')
  let g:ackprg='ag --vimgrep'
endif

"------------- R configs -------------------

" set vim-r-plugin to 
let r_indent_align_args = 0

" Set vim-r-plugin to mimics ess :
let r_indent_ess_comments = 0
let r_indent_ess_compatible = 0

nmap , <Plug>RDSendLine
vmap , <Plug>RDSendSelection
let g:R_tmux_split = 1
let g:R_term = 'tmux'
let g:R_term_cmd = 'tmux split-window -c "#{pane_current_path}"'

"-------------- ale -------------

" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0

"-------------- general configs -------------

filetype plugin indent on
syntax on
set tabstop=2
set shiftwidth=0
set noexpandtab
set encoding=utf-8
set nowrap
set ruler
set backspace=indent,eol,start
set number
set hlsearch
set laststatus=2
set mouse=a

" Enable folding
"set foldmethod=indent
"set foldlevel=99

"-------------- python configs -------------

au FileType python
      \ set tabstop=4 shiftwidth=4

