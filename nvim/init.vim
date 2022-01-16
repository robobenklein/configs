
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif
endif

if has('nvim')
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  " Required:
  call plug#begin('~/.vim/plugged')

  " Neovim-only plugins:
  Plug 'Vigemus/nvimux'
else
  " Normal VIM
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  set directory='~/tmp//,~/.cache//,.'

  " Required:
  call plug#begin('~/.vim/plugged')
endif

Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
" Plug 'edkolev/tmuxline.vim'
Plug 'nvie/vim-flake8'
" Plug 'tpope/vim-fugitive'
Plug 'maxboisvert/vim-simple-complete'

" Required:
call plug#end()

" Required:
filetype plugin indent on

" Vim-airline stuff
set laststatus=2
let g:airline_powerline_fonts = 1
":AirlineTheme term
let g:airline#extensions#tmuxline#enabled = 1

" Set ESC timeout (turns out this was originally an issue with tmux)
set ttimeoutlen=50

" Why is this not on for me by default?
syntax enable
" Dark on dark doesn't work...
set background=dark
colorscheme corobalt

set ignorecase
set smartcase
" assumes set ignorecase smartcase
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END

" Neovim-only config section
if has('nvim')
lua << EOF
-- Nvimux configuration
require('nvimux').setup{
  config = {
    prefix = '<C-b>',
  },
  bindings = {
    {{'n', 'v', 'i', 't'}, 's', ':NvimuxHorizontalSplit'},
    {{'n', 'v', 'i', 't'}, 'v', ':NvimuxVerticalSplit'},
  },
}
EOF

" Fixes the weird characters
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

" End Neovim-only config section
endif
