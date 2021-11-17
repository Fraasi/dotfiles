" for changes to take effect, run ':so %'

""""""""""""""""""""""""""""""""""""""
" Shortcuts
""""""""""""""""""""""""""""""""""""""
" map leader key to space
let mapleader = " " 
" map jk to esc 
imap jk <Esc>
" a shortcut for opening/closing folds, bind it to the spacebar.
nnoremap <space> za
" run current script
nnoremap <leader>r :! clear && ./% <return>
" un/comment line with #
nnoremap gc 0i#<Esc>
nnoremap gu 0x

"""""""""""""""""""""""""""""""""""""
" Indents
"""""""""""""""""""""""""""""""""""""
" replace tabs with spaces
set expandtab
" 1 tab = 2 spaces
set tabstop=2 shiftwidth=2

" when deleting whitespace at the beginning of a line, delete 
" 1 tab worth of spaces (for us this is 2 spaces)
set smarttab

" when creating a new line, copy the indentation from the line above
set autoindent

"""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""
" Ignore case when searching
set ignorecase
set smartcase

" highlight search results (after pressing Enter)
set hlsearch

" highlight all pattern matches WHILE typing the pattern
set incsearch

"""""""""""""""""""""""""""""""""""""
" Mix
"""""""""""""""""""""""""""""""""""""
" show line nuumbers
set number
" show the mathing brackets
set showmatch
" highlight current line
set cursorline

" Always display the status line, even if only one window is displayed
set laststatus=2

" Enable use of the mouse for all modes
if has('mouse')
  set mouse=a
endif

" Set the command window height to 2 lines, to avoid many cases of having to "press <Enter> to continue"
set cmdheight=2

" show the command in the bottom bar, no matter what.
set showcmd

" autocomplete menu
set wildmenu

" allows folding code blocks for easier navigation through the code.
set foldenable

