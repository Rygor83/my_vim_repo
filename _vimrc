"--------------------------------------------------------------
"                        Rygor 2023
"--------------------------------------------------------------

"--------------------------------------------------------------
" Get the defaults that most users want.
"--------------------------------------------------------------
source $VIMRUNTIME/defaults.vim

"--------------------------------------------------------------
" General configuration
"--------------------------------------------------------------
set nocompatible                        " Set 'nocompatible' to ward off unexpected things that your distro might have made
set number                              " Add line numbers
set ruler                               " Always show current position
set cursorline                          " Highlight current line
set background=dark                     " Setting dark mode
set magic                               " For regular expressions turn magic on
set t_Co=256                            " Add true color support
set termguicolors                       " Add true color support
set magic                               " For regular expressions turn magic on
set nofoldenable                        " Do not fold code
set cmdheight=2                         " Set the command window height to 2 lines, to avoid many cases of having to press <Enter> to continue
set wildmenu                            " Better command-line completion
set showcmd                             " Show partial commands in the last line of the screen
set ignorecase                          " Use case insensitive search, 
set smartcase                           "    except when using capital letters
set pastetoggle=<F11>                   " Use <F11> to toggle between 'paste' and 'nopaste'
set hlsearch                            " Highlight searches (use <C-L> to temporarily turn off highlighting; see the mapping of <C-L> below)
set incsearch                           " search as characters are entered
set autoindent                          " When opening a new line and no filetype-specific indenting is enabled, keep the same indent as the line you're currently on. Useful for READMEs, etc.
set laststatus=2                        " Always display the status line, even if only one window is displayed
set showmatch                           " highlight matching [{()}]
set expandtab                           " Use spaces instead of tabs


" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif


"--------------------------------------------------------------
" Временные файлы (своп, бэкап, история) и пути их хранения
"--------------------------------------------------------------
" Swap files
set swapfile
set directory=~/.vim/tempfiles
" Backup files
set backup
set backupdir=~/.vim/tempfiles
" Undo files
set undofile
set undodir=~/.vim/tempfiles

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

"--------------------------------------------------------------
" Выключить звуковое сообщение про ошибках и включить мигание 
" экрана
"--------------------------------------------------------------
set visualbell

"--------------------------------------------------------------
" Позволяет переключать язык RU-EN только в VIM без смены в ОС.
" через сочетание CTRL-^ - переделал на F12
"--------------------------------------------------------------
set spelllang=ru_yo,en_us
set nospell
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" normal mode
map <F12> <C-^> 
" insert mode
imap <F12> <C-^> 
" command line
cmap <F12> <C-^>
" terminal-job
tmap <F12> <C-^>
" insert & command line
map! <F12> <C-^>
" insert, command-line, lang-arg
lmap <F12> <C-^>
" operator pending mode: when you type operator command, for example, d/c/f/t
omap <F12> <C-^>
"--------------------------------------------------------------

if has('packages')
        packadd! vim-airline
        packadd! vim-airline-themes
        packadd! gruvbox
        packadd! NERDTree
        packadd! tagbar
        packadd! vim-polyglot
        packadd! markdown-preview
        packadd! vim-markdown
        packadd! vim-markdown-toc
        packadd! vim-table-mode
        packadd! vim-voom
        packadd! vim-abolish
        packadd! vim-commentary
        packadd! vim-fugitive       
        packadd! vim-repeat
        packadd! vim-surround
        packadd! python-mode
        packadd! tasklist
        packadd! jedi-vim
else
        source $vim/vimfiles/pack/rygor/opt/vim-pathogen/autoload/pathogen.vim
        call pathogen#infect('pack/rygor/opt/{}')
endif






"--------------------------------------------------------------

let $LANG = 'en_US'
set guifont=Cascadia_Mono:h12


" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"--------------------------------------------------------------
" NERDTree 
"--------------------------------------------------------------
" toggle nerdtree display
map <F3> :NERDTreeToggle<CR><CR>
" open nerdtree with the current file selected
nmap ,t :NERDTreeFind<CR><CR>
" don;t show these file types

" auto open or close NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"--------------------------------------------------------------

"--- TagBar ---------------------------------------------------
nmap <F9> :TagbarToggle<CR>

"--------------------------------------------------------------


"--------------------------------------------------------------
" Markdown Plugin with Preview: https://github.com/iamcco/markdown-preview.nvim
" Назначение клавиш для работы с плагином
"--------------------------------------------------------------
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle
"--------------------------------------------------------------

" -------------  Airline config -------------------------------
colorscheme gruvbox
let g:airline_theme='gruvbox'

nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

"--------------------------------------------------------------

"------------------------------------------------------------
" General useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" TaskList настройки
map <F2> :TaskList<CR> 	   " отобразить список тасков на F2
"------------------------------------------------------------

"------------------------------------------------------------
"Cursor Mode Settings

let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

"Cursor settings:
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar


"-- PYTHON - :py3 for python3, :py for python2 --------------
" 1. Vim and Python have to be the same bits: x64
" 2. \\ for escaping backslash in Windows path
"------------------------------------------------------------
" HOW TO USE INTERNAL PYTHON:
" 1. To launch command to a visually selected text with replacement: 
"    :py3do return str.upper(line)
"    :py3do return line.upper()
" 2. To run current python file:
"    :py3file %
"    or
"    F8 key
"------------------------------------------------------------
set pythonhome=d:\\Programms\\Python27
set pythondll=d:\Programms\\Python27\\python27.dll
set pythonthreehome=d:\\Programms\\Python311
set pythonthreedll=d:\\Programms\\Python311\\python311.dll
set pyxversion=3
autocmd FileType python map <buffer> <F8> :w<CR>:py3f %<CR>
autocmd FileType python imap <buffer> <F8> <esc>:w<CR>:py3f %<CR>
"------------------------------------------------------------


"=====================================================
" Python-mode settings
"=====================================================
" отключаем автокомплит по коду (у нас вместо него используется jedi-vim)
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0

" документация
let g:pymode_doc = 0
let g:pymode_doc_key = 'K'
" проверка кода
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_ignore="E501,W601,C0110"
" провека кода после сохранения
let g:pymode_lint_write = 1

" поддержка virtualenv
let g:pymode_virtualenv = 1

" установка breakpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" подстветка синтаксиса
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" отключить autofold по коду
let g:pymode_folding = 0

" возможность запускать код
let g:pymode_run = 0
"-------------------------------------------------------------
" Jedi-vim
" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0
"-------------------------------------------------------------

