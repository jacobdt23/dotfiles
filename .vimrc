" ~/.vimrc — minimal, sensible Vim configuration (no plugins)
" Lines starting with a double quote are comments. Change anything you like,
" then reload with  :source ~/.vimrc  (or just restart Vim).

" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------
set nocompatible              " Use Vim defaults, not old vi behaviour
filetype plugin indent on     " Detect file types; load per-language plugins and indenting
syntax on                     " Syntax highlighting
set encoding=utf-8
set hidden                    " Switch buffers without being forced to save first
set autoread                  " Reload files changed outside of Vim
set updatetime=300            " Faster swap-file writes / CursorHold events
set timeoutlen=500            " How long to wait for a mapped key sequence (ms)
set mouse=a                   " Mouse support (scrolling, clicking, resizing)
set clipboard=unnamedplus     " Use the system clipboard for yank/paste (needs a clipboard-enabled Vim)
set backspace=indent,eol,start " Make backspace behave as expected in insert mode

" Keep your project folders clean: store undo history in one place
" and don't litter swap/backup files next to your code.
set undofile
if has('nvim')
  set undodir=~/.local/state/nvim/undo//
else
  set undodir=~/.vim/undo//
endif
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif
set noswapfile
set nobackup
set nowritebackup

" ---------------------------------------------------------------------------
" Appearance
" ---------------------------------------------------------------------------
set number                    " Show line numbers
set relativenumber            " ...relative to the cursor (great for 5j / 12k jumps)
set cursorline                " Highlight the current line
set signcolumn=yes            " Always show the left gutter so text doesn't jump
set scrolloff=8               " Keep 8 lines visible above/below the cursor
set sidescrolloff=8
set nowrap                    " Don't wrap long lines (toggle with <leader>w below)
set laststatus=2              " Always show the status line
set showcmd                   " Show partially typed commands
set ruler                     " Show cursor position
set wildmenu                  " Nicer tab-completion for : commands
set wildmode=longest:full,full
set colorcolumn=88            " Subtle guide line at column 88
set splitbelow splitright     " New splits open below / to the right

if has('termguicolors')
  set termguicolors           " True-color support in modern terminals
endif
set background=dark
try
  colorscheme habamax         " Bundled with Vim 9+ and Neovim 0.9+
catch
  colorscheme desert          " Fallback for older versions
endtry

" ---------------------------------------------------------------------------
" Searching
" ---------------------------------------------------------------------------
set incsearch                 " Show matches while you type
set hlsearch                  " Highlight all matches
set ignorecase                " Case-insensitive search...
set smartcase                 " ...unless you type a capital letter

" ---------------------------------------------------------------------------
" Indentation (4 spaces by default; overridden per language below)
" ---------------------------------------------------------------------------
set expandtab                 " Insert spaces when pressing Tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

augroup filetype_indent
  autocmd!
  " 2-space languages
  autocmd FileType html,css,scss,javascript,typescript,json,yaml,lua,sh,markdown
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
  " Makefiles require real tabs
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8
  " Go uses tabs by convention
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  " Wrap prose nicely
  autocmd FileType markdown,text setlocal wrap linebreak
augroup END

" ---------------------------------------------------------------------------
" Key mappings
" ---------------------------------------------------------------------------
let mapleader = " "           " <leader> is the Space bar

" Clear search highlighting
nnoremap <silent> <leader>h :nohlsearch<CR>

" Save / quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Toggle line wrapping
nnoremap <silent> <leader>z :set wrap!<CR>

" Move between windows with Ctrl + h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move between buffers
nnoremap <silent> <S-l> :bnext<CR>
nnoremap <silent> <S-h> :bprevious<CR>

" Moving through wrapped lines feels natural
nnoremap j gj
nnoremap k gk

" Keep the cursor centred while paging and searching
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Keep selection after indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Move selected lines up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Make Y behave like D and C (yank to end of line)
nnoremap Y y$

" Jump to the same spot you last edited when reopening a file
augroup restore_cursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Strip trailing whitespace on save (except in Markdown, where it can be meaningful)
augroup trim_whitespace
  autocmd!
  autocmd BufWritePre * if &filetype !=# 'markdown' && &modifiable | let s:view = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(s:view) | endif
augroup END

" ---------------------------------------------------------------------------
" Built-in file browser (netrw): :Ex to open, <leader>e to toggle a sidebar
" ---------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3     " Tree view
let g:netrw_winsize = 25
nnoremap <silent> <leader>e :Lexplore<CR>
