" Reopen in last edited place
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Load indentation rules according to the detected filetype.
if has("autocmd")
  filetype indent on
endif

set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set incsearch
set confirm
set complete=.,w,k
set keywordprg=dict
set pastetoggle=<F9>
let username = $USER
let hostname = system('hostname')
set statusline=%-3.60([%F]%)%(%r%m%h%w%y%)%=[0x%02B(%03b)][line\ %l\ of\ %L][%c/%v][%P][%{username}@%{hostname}]
set laststatus=2 " show status line always
set wildmenu
set hlsearch
syntax on

function! ToggleOption (option)
    execute 'set ' . a:option . '!'
    execute 'echo "' . a:option . ':" strpart("offon",3*&' . a:option .  ',3)'
endfunction
nnoremap <C-N> :next<Enter>
nnoremap <C-P> :prev<Enter>
autocmd BufNewFile,BufRead *.psp setlocal filetype=python
au BufEnter *.py set sw=4 sts=4 et ai
au BufEnter *.zcml set sw=4 sts=4 et ai filetype=xml
au BufEnter *.xml set sw=4 sts=4 et ai
au BufEnter *.c set sw=4 sts=4 et ai
au BufEnter *.conf set sw=4 sts=4 filetype=conf
au BufEnter *.html set sw=4 sts=4 et ai filetype=htmldjango
au BufEnter *.pt set sw=2 sts=2 et ai filetype=html
au BufEnter *.js set sw=4 sts=4 et ai cindent formatoptions=acroq textwidth=70
au BufEnter *.pas set sw=4 sts=4 et ai
au BufEnter *.rb set sw=4 sts=4 et ai
au BufEnter *.c set sw=4 sts=4 et ai
au BufEnter *.erl set sw=4 sts=4 et ai
au BufEnter *.java set sw=4 sts=4 et ai cindent formatoptions=acroq textwidth=70
colorscheme ron
