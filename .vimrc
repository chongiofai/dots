" ~/.vimrc

" function
"
function! ExistPlugin(plugin)
    if isdirectory(expand("~/.vim/plugins/" . a:plugin))
        return 1
    endif
    return 0
endfunction

function! InitVim()
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory',
                \ 'undo': 'undodir'}
    for [dir_name, set_name] in items(dir_list)
        let dest_dir = expand('~/.vim/' . dir_name . '/')
        if !isdirectory(dest_dir)
            call mkdir(dest_dir)
        endif
        exec "set ". set_name . "=" .  dest_dir
    endfor
    set viewdir+=n~/.vim/history
    set viminfo+=n~/.vim/viminfo

endfunction

set nocompatible
let mapleader=','
call InitVim()

" plugin
"
if !filereadable(expand('~/.vim/autoload/plug.vim'))
    " exec '!curl -fLo ' . base_dir . 'autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    exec 'git clone https://github.com/junegunn/vim-plug/master/plug.vim.git ' . base_dir . 'autoload/vim-plug'
else
    call plug#begin(expand('~/.vim/plugins'))
    Plug 'flazz/vim-colorschemes'
    Plug 'itchyny/vim-gitbranch'
    Plug 'mbbill/undotree'
    Plug 'preservim/tagbar'
    Plug 'MattesGroeger/vim-bookmarks'
    Plug 'othree/eregex.vim'
    " Plug 'mileszs/ack.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'SirVer/ultisnips'
    Plug 'Chiel92/vim-autoformat'
    Plug 'dense-analysis/ale'
    if has("python") || has("python3")
        Plug 'Valloric/YouCompleteMe', {'do': '/bin/env python3 ./install.py'}
    endif
    Plug 'editorconfig/editorconfig-vim'
    Plug 'scrooloose/nerdcommenter'
    call plug#end()
endif

if ExistPlugin('vim-colorschemes')
    colorscheme synic
endif

if ExistPlugin('vim-gitbranch')
    function! GitBranchStatus() abort
        let l:branch=gitbranch#name()
        return l:branch == '' ? '' : '(' . l:branch . ')'
    endfunction
else
    function! GitBranchStatus() abort
        return '[!]'
    endfunction
endif

if ExistPlugin('tagbar')
    nnoremap <Leader>tt :TagbarToggle<CR>
endif

if ExistPlugin('undotree')
    nnoremap <Leader>uu :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
endif

if ExistPlugin('vim-bookmarks')
    let g:bookmark_no_default_key_mappings = 1
    nmap mm :BookmarkToggle<CR>
    nmap mi :BookmarkAnnotate<CR>
    nmap mn :BookmarkNext<CR>
    nmap mp :BookmarkPrev<CR>
    nmap ma :BookmarkShowAll<CR>
    nmap mc :BookmarkClear<CR>
    nmap mx :BookmarkClearAll<CR>
    nmap mk :BookmarkMoveUp<CR>
    nmap mj :BookmarkMoveDown<CR>
    nmap mg :BookmarkMoveToLine<Space>
    let g:bookmark_sign='b'
    let g:bookmark_annotation_sign='m'
    let g:bookmark_highlight_lines=1
    let g:bookmark_show_toggle_warning=0
    let g:bookmark_auto_save_file=expand('~/.vim/bookmarks')
endif

if ExistPlugin('ack.vim')
    if executable('rg')
        let g:ackprg='rg --vimgrep --sort path'
    elseif executable('ag')
        let g:ackprg='ag --vimgrep --no-heading'
    endif
    cnoreabbrev Ack Ack!
    " nnoremap <Leader>a :Ack!<Space>
endif

if ExistPlugin('fzf.vim')
    let g:fzf_command_prefix='Fzf'
    nnoremap <Leader>zc :FzfCommands<CR>
    nnoremap <Leader>zf :FzfRg<CR>
    nnoremap <Leader>zt :FzfTags<CR>
endif

if ExistPlugin('vim-autoformat')
    let g:autoformat_autoindent=0
    let g:autoformat_retab=0
    let g:autoformat_remove_trailing_spaces=0
    " python
    let g:formatters_python=['black', 'autopep8']
    let g:formatdef_black='"black --quiet --skip-string-normalization ".(&textwidth ? "-l".&textwidth : "")." -"'
    " go
    let g:formatters_go= ['gofmt']
    nnoremap <Leader>ff :Autoformat<CR>
endif

if ExistPlugin('ale')
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
                \ 'yaml': ['yamllint']}
    nnoremap <Leader>al :ALEToggle<CR>
    nnoremap <Leader>aj :ALENextWrap<CR>
    nnoremap <Leader>ak :ALEPreviousWrap<CR>
else
    function! LinterStatus() abort
        return '[!]'
    endfunction
endif

if ExistPlugin('YouCompleteMe')
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_server_python_interpreter = '/usr/bin/python3.9'
    " let g:ycm_server_python_interpreter = '/bin/env python3'
endif

if ExistPlugin('nerdcommenter')
    let g:NERDSpaceDelims = 1
endif

" general
"
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
