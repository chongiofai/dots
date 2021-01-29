" ~/.vimrc

set nocompatible

" function
"
function SafeMkdir(target)
    if !isdirectory(a:target)
        call mkdir(a:target)
    endif
    if !isdirectory(a:target)
        echo 'Unable create directory ' . a:target
    endif
endfunction

function DownloadPluginManager()
    " exec '!curl -fLo ' . base_dir . 'autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    exec 'git clone https://github.com/junegunn/vim-plug/master/plug.vim ' . base_dir . 'autoload/vim-plug'
endfunction

" variable
"
let base_dir=$HOME . '/.vim/'
call SafeMkdir(base_dir)
let plugin_dir=base_dir . 'plugins/'
call SafeMkdir(plugin_dir)

let backup_dir=base_dir . "backup/"
call SafeMkdir(backup_dir)
exec "set backupdir=" . backup_dir
let view_dir=base_dir . "view/"
call SafeMkdir(view_dir)
exec "set viewdir=" . view_dir
let swap_dir=base_dir . "swap/"
call SafeMkdir(swap_dir)
exec "set directory=" . swap_dir
if has('persistent_undo')
    let undo_dir=base_dir . "undo/"
    call SafeMkdir(undo_dir)
    exec "set undodir=" . undo_dir
endif
exec "set viewdir+=n" . base_dir . "history"

" plugin
"
let plugin_script=base_dir . 'autoload/vim-plug/plug.vim'
if filereadable(plugin_script)
    call plug#begin(plugin_dir)
    Plug 'flazz/vim-colorschemes'
    Plug 'itchyny/vim-gitbranch'
    Plug 'luochen1990/rainbow'
    Plug 'MattesGroeger/vim-bookmarks'
    Plug 'othree/eregex.vim'
    Plug 'mileszs/ack.vim'
    Plug 'junegunn/fzf'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'Chiel92/vim-autoformat'
    Plug 'scrooloose/nerdcommenter'
    Plug 'dense-analysis/ale'
    Plug 'Valloric/YouCompleteMe', {'do': '/bin/env python ./install.py --go-completer'}
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    call plug#end()
endif

if isdirectory(plugin_dir . 'vim-colorschemes')
    colorscheme synic
endif

if isdirectory(plugin_dir . 'vim-gitbranch')
    function! GitBranchStatus() abort
        let l:branch=gitbranch#name()
        return l:branch == '' ? '' : '(' . l:branch . ')'
    endfunction
else
    function! GitBranchStatus() abort
        return '[!]'
    endfunction
endif

if isdirectory(plugin_dir . 'vim-bookmarks')
    highlight BookmarkSign ctermbg=NONE ctermfg=160
    highlight BookmarkLine ctermbg=194 ctermfg=NONE
    let g:bookmark_sign='B'
    let g:bookmark_auto_save_file=base_dir . 'bookmarks'
endif

if isdirectory(plugin_dir . 'ack.vim')
    if executable('rg')
        let g:ackprg='rg --vimgrep --sort path'
    elseif executable('ag')
        let g:ackprg='ag --vimgrep --no-heading'
    endif
endif

if isdirectory(plugin_dir . 'vim-autoformat')
    let g:autoformat_autoindent=0
    let g:autoformat_retab=0
    let g:autoformat_remove_trailing_spaces=0
    let g:formatters_python=['black', 'autopep8', 'yapf']
    let g:formatters_black='"black --quiet --skip-string-normalization ".(&textwidth ? "-l".&textwidth : "")." -"'
    let g:formatters_go= ['gofmt']
    nnoremap <leader>f :Autoformat<CR>
endif

if isdirectory(plugin_dir . 'ale')
    function! LinterStatus() abort
        let l:counts=ale#statusline#Count(bufnr(''))
        let l:all_errors=l:counts.error + l:counts.style_error
        let l:all_non_errors=l:counts.total - l:all_errors
        return printf(
                    \   '[%dW%dE]',
                    \   all_non_errors,
                    \   all_errors
                    \)
    endfunction
    highlight ALEWarningSign ctermfg=11 ctermbg=15 guifg=#ED6237 guibg=#F5F5F5
    highlight ALEErrorSign ctermfg=9 ctermbg=15 guifg=#C30500 guibg=#F5F5F5
    let g:ale_enabled=1
    let g:ale_set_highlights=1
    let g:ale_sign_column_always=1
    let g:ale_sign_error='E'
    let g:ale_sign_warning='W'
    let g:ale_echo_msg_error_str='E'
    let g:ale_echo_msg_warning_str='W'
    let g:ale_echo_msg_format='[%severity%][%linter%]%s: %code%'
    let g:ale_set_loclist=1
    let g:ale_set_quickfix=1
    let g:ale_open_list=0
    let g:ale_keep_list_window_open=1
    let g:ale_lint_delay=200
    let g:ale_lint_on_text_changed=1
    let g:ale_lint_on_insert_leave=1
    let g:ale_lint_on_save=1
    let g:ale_lint_on_filetype_changed=1
    "let g:ale_lint_on_insert_leave=0
    let g:ale_completion_enabled=1
    let g:ale_linters_explicit=1
    let g:ale_linters={
                \ 'go': ['gofmt', 'golint', 'govet'],
                \ 'python': ['flake8', 'mypy'],
                \ 'yaml': ['yamllint']
                \ }
    nnoremap <leader>l :ALEToggle<CR>
    nnoremap <leader>c :ALELint<CR>
    nnoremap <leader>j :ALENextWrap<CR>
    nnoremap <leader>k :ALEPreviousWrap<CR>
else
    function! LinterStatus() abort
        return '[!]'
    endfunction
endif

if isdirectory(plugin_dir . 'YouCompleteMe')
    "let g:ycm_global_ycm_extra_conf = '/path/to/the/file'
    let g:ycm_confirm_extra_conf = 0
endif

" general
"
" let mapleader=';'
set mouse=i
set undofile
syntax on
set t_Co=256
set encoding=utf-8
set autoindent
set tabstop=4
set linespace=0
set list
set listchars=tab:»\ ,trail:¨
" set listchars=tab:⇒\ ,trail:→
set showmatch
set cursorline
set cursorcolumn
set nowrap
set number
set showcmd
set showmode
set ruler
set rulerformat=%=0x%B\ %c,%l/%L\ %V\ %P
set laststatus=2
set statusline=%y%{LinterStatus()}%m%r%h%w%q%k%.20F%{GitBranchStatus()}%=0x%B\ %c,%l/%L\ %V\ %P
set foldenable
set foldmethod=indent
