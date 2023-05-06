"""""""""""""""
"   GENERAL   "
"""""""""""""""
" Case insensitive search
set ignorecase
" Except if a capital letter is typed
set smartcase

" Enable mouse support
set mouse=a

" Show line numbers
set number

" Set to auto read when a file is changed from the outside vim
set autoread

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let $LANG='en'
set langmenu=en

" Turn on the Wild menu
set wildmenu

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

colorscheme peachpuff

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""
"  STATUSLINE  "
""""""""""""""""
" Always show the status line
set laststatus=2

" Set colors for vim mode statusline
hi normalcolor guifg=black guibg=green ctermbg=46 ctermfg=0
hi insertcolor guifg=black guibg=cyan ctermbg=51 ctermfg=0
hi replacecolor guifg=black guibg=maroon1 ctermbg=165 ctermfg=0
hi visualcolor guifg=black guibg=orange ctermbg=202 ctermfg=0

" Format the status lines "
set statusline=
" VIM Mode
set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#InsertColor#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \ REPLACE\ ':''}
set statusline+=%#VisualColor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
" Filepath
set statusline+=%#PmenuSel#
set statusline+=\ %F
set statusline+=%=
" Line part
set statusline+=%#Warnings#
set statusline+=\ [%l:%c\ \|\ %p%%]
