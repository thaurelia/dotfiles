" Plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'dracula/vim'

call plug#end()

" Remap ; to :
nnoremap ; :

filetype plugin indent on
syntax enable
colorscheme dracula

set nobackup
set noswapfile

set laststatus=0
set noshowmode

set cursorline
