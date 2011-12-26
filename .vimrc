call pathogen#infect()
call pathogen#helptags()

" PLUGINS to consider
" - matchit (do/end with %)
" - regreplop
" - fuzzyfinder
" - tabular
" - ruby-refactoring
" - textobj-rubyblock

""" TPOPE
" - endwise
" - surround

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Leader
let mapleader = ","

" open in scratch buffer, skip netrw (seems to clash with command-t)
" only works in macvim
:au GUIEnter * :bd

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=1000

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" show the cursor position all the time
set ruler

" Show (partial) command in the status line
set showcmd

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set guifont=Inconsolata-dz:h14
endif

" sane editing configuration
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
"set smartindent
set laststatus=2
set showmatch
set incsearch
"set nowrap
set cursorline     " highlight current line
set visualbell     " Don't beep
set encoding=utf-8
set nowrap

" whitespace stuff
set list listchars=tab:\ \ ,trail:·
if has("gui_running")
  set listchars=trail:·
else
  set listchars=trail:~
endif

" MacVIM - fullscreening
if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
  map <D-CR> :set invfu<cr>
endif

" display
set number
set numberwidth=4
set guioptions-=T  " no toolbar
set guioptions-=rL " no scrollbars
set guioptions-=e  " no gui tab bar
set showtabline=2  " Always show tab bar

" set the color scheme
if &t_Co == 256
  let g:solarized_termcolors=256
  set background=dark
  colorscheme solarized
endif

" Change background color when inserting.
" (Broken in terminal Vim: Solarized has a bug which makes it reload
" poorly.)
" http://www.reddit.com/r/vim/comments/ggbcp/solarized_color_scheme/
if has("gui_running")
  let g:insert_mode_background_color = "#18434E"
end

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=.git,*.rbc,*.class,.svn,vendor/gems/*

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" Sub
nmap <leader>s :%s/
vmap <leader>s :s/

" Split screen
:noremap <leader>v :vsp<CR>
:noremap <leader>h :split<CR>

" Make current window the only one (within tab)
:noremap <leader>o :only<CR>

" Buffer next,previous (ctrl-{n,p})
:noremap <c-N> :bn<CR>
:noremap <c-P> :bp<CR>

" Add new windows towards the right and bottom.
set splitbelow splitright

" GRB: Put useful info in status line
":set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
":hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,config.ru} set ft=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

au BufRead,BufNewFile *.txt call s:setupWrapping()

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" File Renaming (credit: garybernhardt)
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" misc shortcuts
imap <c-l> <space>=><space>
imap <c-c> <esc>
"map <Left> :echo "no!"<cr>
"map <Right> :echo "no!"<cr>
"map <Up> :echo "no!"<cr>
"map <Down> :echo "no!"<cr>
map Y y$   " Make Y consistent with D and C.
map <silent> <leader>y :<C-u>silent '<,'>w !pbcopy<CR>

"" Copy current file path to system pasteboard.
map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>

" (credit: garybernhardt)
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
  " :normal! <<
  " :normal! ilet(:
  " :normal! f 2cl) {
  " :normal! A }
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

" MacVIM shift+arrow-keys behavior (required in .vimrc)
" let macvim_hig_shift_movement = 1

" indent/unindent visual mode selection with tab/shift+tab
vmap <tab> >gv
vmap <s-tab> <gv

" Commentary (change default mappings)
xmap <leader>/  <Plug>Commentary
nmap <leader>/  <Plug>Commentary
nmap <leader>// <Plug>CommentaryLine

" set question mark to be part of a VIM word. in Ruby it is!
autocmd FileType ruby set iskeyword=@,48-57,_,?,!,192-255
autocmd FileType scss set iskeyword=@,48-57,_,-,?,!,192-255

" reload .vimrc
map <leader>rv :source ~/.vimrc<CR>

" Scroll faster.
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" strip trailing whitespace on save for code files
function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction
" rails
autocmd BufWritePre *.rb,*.yml,*.js,*.css,*.sass,*.scss,*.html,*.xml,*.erb,*.haml call StripTrailingWhitespace()
" misc
autocmd BufWritePre *.feature call StripTrailingWhitespace()

" Command-T
let g:CommandTMaxHeight=20
noremap <D-N> :CommandT<CR>
noremap <leader>f :CommandT<CR>

"""""""""""""""""""" EXPERIMENTAL

" ctags again with gemhome added
"map <leader>t :!/usr/local/bin/ctags -R --exclude=.git --exclude=log * `rvm gemhome`/*<CR>
"map <leader>T :!rdoc -f tags -o tags * `rvm gemhome` --exclude=.git --exclude=log

" CTags
"map <leader>rt :!ctags --extra=+f -R *<CR><CR>
"map <C-\> :tnext<CR>

" Map keys to go to specific files
"map <leader>gr :topleft :split config/routes.rb<cr>
"function! ShowRoutes()
"  " Requires 'scratch' plugin
"  :topleft 100 :split __Routes__
"  " Make sure Vim doesn't write __Routes__ as a file
"  :set buftype=nofile
"  " Delete everything
"  :normal 1GdG
"  " Put routes output in buffer
"  :0r! rake -s routes
"  " Size window to number of lines (1 plus rake output length)
"  :exec ":normal " . line("$") . "_ "
"  " Move cursor to bottom
"  :normal 1GG
"  " Delete empty trailing line
"  :normal dd
"endfunction
"map <leader>gR :call ShowRoutes()<cr>
"map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
"map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
"map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
"map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
"map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
"map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
"map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
"map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
"map <leader>gg :topleft 100 :split Gemfile<cr>
"map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
"map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
"nnoremap <leader><leader> <c-^>

" Disable middle mouse button (which is easy to hit by accident).
"map <MiddleMouse> <Nop>
"imap <MiddleMouse> <Nop>

" Remember last location in file
"if has("autocmd")
""  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
"   \| exe "normal g'\"" | endif
"endif

"" FuzzyFinder and switchback commands
"map <leader>e :e#<CR>
"map <leader>b :FufBuffer<CR>
"map <leader>f <Plug>PeepOpen
"map <leader><C-N> :FufFile **/<CR>
"map <D-e> :FufBuffer<CR>
"map <leader>n :FufFile **/<CR>
"map <D-N> :FufFile **/<CR>

" % to bounce from do to end etc.
"runtime! macros/matchit.vim
