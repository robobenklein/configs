
if has('nvim')
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
  " Normal VIM
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  set directory='~/tmp//,~/.cache//,.'
endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif
endif

" Required:
call plug#begin('~/.vim/plugged')

" Add or remove your Bundles here:
Plug 'bling/vim-airline'
"NeoBundle 'edkolev/tmuxline.vim'
Plug 'nvie/vim-flake8'
Plug 'hkupty/nvimux'
Plug 'tpope/vim-fugitive'

" Required:
call plug#end()

" Required:
filetype plugin indent on


" Vim-airline stuff
set laststatus=2
let g:airline_powerline_fonts = 1
":AirlineTheme term
let g:airline#extensions#tmuxline#enabled = 1

" Not sure if these even work,
" Set color
"set t_Co=256
" Set ESC timeout (turns out this was originally an issue with tmux)
set ttimeoutlen=50

" Why is this not on for me by default?
syntax enable
" Dark on dark doesn't work...
set background=dark
colorscheme corobalt

" Fixes the weird characters
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
command! -bang Q quit<bang>
