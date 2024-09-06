"--------------------------------------------------------------
"                        Rygor 2023
"--------------------------------------------------------------

"--------------------------------------------------------------
" Get the defaults that most users want.
"--------------------------------------------------------------
" source $VIMRUNTIME/defaults.vim

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
set visualbell                          " Выключить звуковое сообщение про ошибках и включить мигание экрана
set autochdir                           " automatically change the current directory to the directory of the current file
set list "Show special signs: Tabs, End Of Line, Nonbreaking space, etc
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵
set noexpandtab                         " Inset TAB as TAB and no space substitution
set tildeop                             " make ~ as ~{motion}, so we can use {motion} with ~
" Enable syntax highlighting
if has('syntax')
  syntax on
endif

"--------------------------------------------------------------
" Временные файлы (своп, бэкап, история) и пути их хранения
"--------------------------------------------------------------
let $backup_folder=$vim . '\vimfiles\temp' " Environment variable starts with $, so you can assign it to :set param=$env_var
" Swap files folder: *.swp, *.swo
set swapfile
set directory=$backup_folder
" Backup files folder: *~
set backup
set backupdir=$backup_folder
" Undo files folder: same as initial file
set undofile
set undodir=$backup_folder

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
" Позволяет переключать язык RU-EN только в VIM без смены в ОС.
" через сочетание CTRL-^ - переделал на F2
"--------------------------------------------------------------
set spelllang=ru,en,de
set nospell
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" normal mode
noremap <F2> <C-^> 
" insert mode
inoremap <F2> <C-^> 
" command line
cnoremap <F2> <C-^>
" terminal-job
tnoremap <F2> <C-^>
" insert & command line
noremap! <F2> <C-^>
" insert, command-line, lang-arg
lnoremap <F2> <C-^>
" operator pending mode: when you type operator command, for example, d/c/f/t
onoremap <F2> <C-^>
"--------------------------------------------------------------

" ----- PLUGINS -----------------------------------------------
if has('packages')
        packadd! gruvbox
        " packadd! jedi-vim    " troubles with hotkeys
        packadd! markdown-preview
        packadd! NERDTree
        " packadd! python-mode
        packadd! tagbar
        packadd! tasklist
        packadd! tlib_vim
        packadd! vim-addon-mw-utils
        packadd! vim-airline
        packadd! vim-airline-themes
        packadd! vim-markdown
        packadd! vim-markdown-toc
        packadd! vim-polyglot
        " packadd! vim-snipmate " troubles with hotkeys
        packadd! vim-table-mode
        packadd! vim-voom
        " There are other plugins in 'pack/rygor/start/' folder

else
        source $vim/vimfiles/pack/rygor/opt/vim-pathogen/autoload/pathogen.vim
        call pathogen#infect('pack/rygor/opt/{}')
endif

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

"--------------------------------------------------------------

let $LANG = 'en_US'
set guifont=Cascadia_Mono:h12


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
noremap <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nnoremap ,t :NERDTreeFind<CR>
" don;t show these file types
set wildignore+=*.lnk,.*
let NERDTreeRespectWildIgnore=1

" auto open or close NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"--------------------------------------------------------------

"--- TagBar ---------------------------------------------------
nnoremap <F9> :TagbarToggle<CR>

"--------------------------------------------------------------

"--------------------------------------------------------------
" Markdown Plugin with Preview: https://github.com/iamcco/markdown-preview.nvim
" Назначение клавиш для работы с плагином
"--------------------------------------------------------------
nnoremap <C-s> <Plug>MarkdownPreview
nnoremap <M-s> <Plug>MarkdownPreviewStop
nnoremap <C-p> <Plug>MarkdownPreviewToggle
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
"------------------------------------------------------------
"Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy, which is the default
noremap Y y$
"Map <C-L> (redraw screen) to also turn off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>
"Scroll up in INSERT mode & Scroll down in INSERT mod
inoremap <C-E> <C-X><C-E>
inoremap <C-Y> <C-X><C-Y>
"Отобразить список тасков на F2
noremap <F7> :TaskList<CR>
"If you like the scrolling to go a bit smoother, you can use these mappings make sure the '<' flag is not in 'cpoptions'
noremap <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
noremap <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>
noremap <leader>ev :tabe $MYVIMRC<CR>
noremap <leader>sv :source $MYVIMRC<CR>


"------------------------------------------------------------

"------------------------------------------------------------
" Cursor Mode Settings
"------------------------------------------------------------
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
"-------------------------------------------------------------


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
set pythonthreehome=d:\\Programms\\Python311
set pythonthreedll=d:\\Programms\\Python311\\python311.dll
set pyxversion=3
" set pythonhome=d:\\Programms\\Python27
" set pythondll=d:\Programms\\Python27\\python27.dll
autocmd FileType python noremap <buffer> <F8> :w<CR>:py3f %<CR>
autocmd FileType python inoremap <buffer> <F8> <esc>:w<CR>:py3f %<CR>
"------------------------------------------------------------


"=====================================================
" Python-mode settings
"=====================================================
let g:pymode = 1
" отключаем автокомплит по коду (у нас вместо него используется jedi-vim)
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0

" документация
let g:pymode_doc = 1
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
let g:pymode_run = 1
let g:pymode_run_bind = '<leader>r'
"-----------------------------------------------------

"=====================================================
" Jedi-vim 
"=====================================================
" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0
"-----------------------------------------------------

"=====================================================
" VoOM - outliner 
"=====================================================
" VOOM use only python3
let g:voom_python_versions = [3]
autocmd FileType markdown nnoremap <buffer> <F4> :VoomToggle markdown <CR>
autocmd FileType *.txt nnoremap <buffer> <F4> :VoomToggle vimoutliner <CR>
" autocmd FileType python nnoremap <buffer> <F4> :VoomToogle python <CR>
"-----------------------------------------------------

"=====================================================
" SnipMate 
"=====================================================
let g:snipMate = { 'snippet_version' : 1 }
"-----------------------------------------------------

"=====================================================
" Vim-Abolish
"=====================================================
" Here lies abbreviation for Abolish
let g:abolish_save_file = '$vim\vimfiles\after\plugin\abolish.vim'
"-----------------------------------------------------

"=====================================================
" HelpMe
"=====================================================
let g:HelpMeItems = [
    \ "Fx shortcuts:",
    \ "<F2>                               Language switch RU-EN",
    \ "<F3>                               NerdTree",
    \ "<F4>                               Outliner",
    \ "<F7>                               Task List",
    \ "<F8>                               Execute python Vim Std",
    \ "\\r                                 Execute python Python-mode",
    \ "<F9>                               Tags Toggle",
    \ "<F11>                              Paste mode",
    \ "",
    \ "Completion in Insert mode:",
    \ "Ctrl-X, Ctrl-I                     <I>nsert words from file",
    \ "Ctrl-X, Ctrl-F                     <F>ile's path insert",
    \ "Ctrl-X, Ctrl-L                     <L>ine start from file",
    \ "Ctrl-X, Ctrl-D                     <D>ifinition of func from file",
    \ "Ctrl-N                             <N>ext item in completion mode",
    \ "Ctrl-P                             <P>revious item in completion mode",
    \ "",
    \ "i_Ctrl-T or >> / i_Ctrl-D or <<    Indent / Unindent",
    \ "Ctrl-Q, I, Ctrl-T/Ctrl-D           Indent / Unindent in Visual mode",
    \ ]

