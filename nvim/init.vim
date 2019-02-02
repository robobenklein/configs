
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
local nvimux = require('nvimux')

-- Nvimux configuration
nvimux.config.set_all{
  prefix = '<C-b>',
  new_window = 'enew', -- Use 'term' if you want to open a new term for every new window
  new_tab = nil, -- Defaults to new_window. Set to 'term' if you want a new term for every new tab
  new_window_buffer = 'single',
  quickterm_direction = 'botright',
  quickterm_orientation = 'vertical',
  quickterm_scope = 't', -- Use 'g' for global quickterm
  quickterm_size = '80',
}

-- Nvimux custom bindings
nvimux.bindings.bind_all{
  {'s', ':NvimuxHorizontalSplit', {'n', 'v', 'i', 't'}},
  {'v', ':NvimuxVerticalSplit', {'n', 'v', 'i', 't'}},
}

-- Required so nvimux sets the mappings correctly
nvimux.bootstrap()
EOF

" Fixes the weird characters
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

" End Neovim-only config section
endif
