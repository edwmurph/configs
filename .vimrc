" ln -s /Users/eddie/code/configs/.vimrc /Users/eddie/.vimrc

"------------ vundles --------------


" Required for Vundle
set rtp+=~/.vim/bundle/Vundle.vim
filetype plugin indent on

call vundle#begin()

  Plugin 'derekwyatt/vim-scala'

call vundle#end()


"------------ vim-plugs --------------


call plug#begin('~/.vim/plugged')

" GENERAL
  " adds indent visualization
  Plug 'Yggdroot/indentLine'
  " autocloses chars that have matching closing counterparts
  Plug 'Townk/vim-autoclose'
  " async lint engine
  Plug 'w0rp/ale'
  " file explorer
  Plug 'scrooloose/nerdtree'
  " collection of lang packs
  Plug 'sheerun/vim-polyglot'
  " theme
  Plug 'joshdick/onedark.vim'
  " highlights all matches in file while searching
  Plug 'haya14busa/incsearch.vim'
  " detects indent in current file and uses that going forward
  Plug 'tpope/vim-sleuth'
  " <Tab> for simple insert completion
  Plug 'ervandew/supertab'
  " Git integration features like :GBlame
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/gv.vim'
  " fzf expected to be installed with homebrew
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'

" R
  "Plug 'janko-m/vim-test'
  "Plug 'jalvesaq/Nvim-R'

" PYTHON
  Plug 'vim-scripts/indentpython.vim'

call plug#end()


"-------------- general configs -------------


let mapleader=" "

" self-explanatory
syntax on
set encoding=utf-8
set noerrorbells

" tabbing default to hard tabs of width 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=0
set noexpandtab

" Stop word wrapping
set nowrap
" Except on markdown files
  autocmd FileType markdown setlocal wrap
" Dont let vim hide characters
set conceallevel=1
" on bottom bar, display line #, column # and relative position of cursor in file
set ruler
" enable backspace to delete over line breaks or auto-inserted indents
set backspace=indent,eol,start
" display line numbers
set number
" highlight all search matches
set hlsearch
" enable cursor movement by clicking with mouse
set mouse=a

" Required for one of my plugins TODO determine which plugin breaks when removing this and move to plugin-specific configs
filetype off

" Not sure if these are needed
  set laststatus=2


"-------------- plugin-specific configs -------------


" w0rp/ale configs
  " override sbtserver address
  let g:ale_scala_sbtserver_address = '127.0.0.1:5987'
  " dont lint every time text changes
  let g:ale_lint_on_text_changed = 'never'
  " specify linters
  let g:ale_linters = {'javascript': ['eslint'], 'scala': ['sbtserver', 'scalac', 'scalafmt', 'scalastyle']}
  let g:ale_linters_explicit = 1

" Yggdroot/indentLine configs
  " customize indentLine char
  let g:indentLine_enabled = 1
  let g:indentLine_char = "│"

" ervandew/supertab configs
  " let <CR> select completion selection
  let g:SuperTabCrMapping = 1

" junegunn/gv.vim
  " display unfoleded git diffs
  autocmd FileType git set foldlevel=1


"------------ theme ---------------


syntax on
colorscheme onedark
set termguicolors


"------------- mappings -----------


" INSERT MODE

  " save file
  :imap <Leader>; <Esc> :w <Enter>

  :imap <Leader><Leader>c console.log(``);<ESC>2hi
  :imap <Leader><Leader>j JSON.stringify(, null, 2)<ESC>9hi
  :imap <Leader><Leader>m def main(args: Array[String]): Unit = {}<ESC>i


" NORMAL MODE

  " save file
  :nmap <Leader>; <Esc> :w <Enter>

  " Ctrl-space opens fuzzy file search
  :nmap <C-@> :FZF <Enter>

  " Ctrl-n toggles nerdtree panel
  :nmap <C-n> :NERDTreeToggle<CR>

  " text insert shortcuts
  :nmap <Leader><Leader>c aconsole.log(``);<ESC>2hi
  :nmap <Leader><Leader>j aJSON.stringify(, null, 2)<ESC>9hi
  :nmap <Leader><Leader>m adef main(args: Array[String]): Unit = {}<ESC>i

  " Ctrl-i sorts scala imports
  :nmap <C-i> :SortScalaImports<CR>

  " buffer shifts
  :nmap <C-down> <C-e>
  :nmap <C-up> <C-y>
  :nmap <C-S-down> <C-d> zz
  :nmap <C-S-up> <C-u> zz

  " prevent default shift cursor behavior of <space> in normal mode
  :nmap <SPACE> <Nop>

  " space-# searches project for word under cursor
  :nmap <Leader># :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>

  " quick-fix navigations
  " next
  :nmap <Leader>qn :cn <CR>
  " prev
  :nmap <Leader>qp :cp <CR>
  " close quick-fix window
  :nmap <Leader>qc :ccl <CR>

  " ctag navigation
  :nmap <Leader>gd <C-]>
  :nmap <Leader>gn :tn<CR>
  :nmap <Leader>gp :tp<CR>
  :nmap <Leader>go <C-t>

  " override / to use incsearch
  :nmap / <Plug>(incsearch-forward)


" VISUAL MODE

  " save file
  :vmap <Leader>; <Esc> :w <Enter>

  " Ctrl-c copies visual selection to clipboard
  :vmap <C-c> "+y<CR>"


"---------- custom commands --------


" GV plugin is a better alternative to this
:command Hist ! git log --pretty=format:"\%C(yellow)>>>|\%h|\%Cred\%ad|\%Cblue\%an|\%Creset\%s" --date=format:"\%Y-\%m-\%d \%H:\%M" -p $(echo %) | sed -e '/>>>|/{n;N;N;N;d;}' | sed -e 's/\(^-.*$\)/'$(printf "\033[91m")'\1'$(printf "\033[0m")'/g' | sed -e 's/\(^+.*$\)/'$(printf "\033[92m")'\1'$(printf "\033[0m")'/g'


"-------------- python configs -------------


au FileType python
  \ set tabstop=4 shiftwidth=4


"------------- R configs -------------------

" set vim-r-plugin to
"let r_indent_align_args = 0

" Set vim-r-plugin to mimics ess :
"let r_indent_ess_comments = 0
"let r_indent_ess_compatible = 0

"nmap , <Plug>RDSendLine
"vmap , <Plug>RDSendSelection
"let g:R_tmux_split = 1
"let g:R_term = 'tmux'
"let g:R_term_cmd = 'tmux split-window -c "#{pane_current_path}"'

