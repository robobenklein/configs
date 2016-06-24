"NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=/home/robo/.config/nvim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/robo/.config/nvim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'bling/vim-airline'
NeoBundle 'edkolev/tmuxline.vim'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Vim-airline stuff
set laststatus=2
let g:airline_powerline_fonts = 1
":AirlineTheme term
let g:airline#extensions#tmuxline#enabled = 1

" Not sure if these even work,
" Set color
set t_Co=256
" Set ESC timeout (turns out this was originally an issue with tmux)
set ttimeoutlen=50

" Why is this not on for me by default?
syntax enable

