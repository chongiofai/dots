" ~/.vimrc
"
" MAINTAINER: c1f<chongiofai@gmail.com>


"
" function
"
function! HandleVimFiles()
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

function! PlugDownload()
    if !filereadable(expand('~/.vim/autoload/plug.vim'))
        exec '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endfunction

function! PlugExist(plugin)
    if isdirectory(expand("~/.vim/plugins/" . a:plugin))
        return 1
    endif
    return 0
endfunction

function! ToggleLocationList()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        lopen
    else
        lclose
    endif
endfunction

function! ToggleQuickFixList()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

function! LFMode()
    " TODO Large File Mode
    syntax off
    let g:ale_enabled=0
endfunction

command! PlugDownload call PlugDownload()
command! PlugExist call PlugExist()
command! ToggleLocationList call ToggleLocationList()
command! ToggleQuickFixList call ToggleQuickFixList()
command! LFMode call LFMode()

"
" general
"
call HandleVimFiles()
autocmd QuitPre * if empty(&bt) | lclose | endif
autocmd QuitPre * if empty(&bt) | cclose | endif
set nocompatible
noremap \ ;
let mapleader=';'
" set timeout
" set timeoutlen=3000
" set ttimeoutlen=100
syntax on
set undofile
set mouse=i
set t_Co=256
set encoding=utf-8
set nowrap
set autoindent
set tabstop=4
set linespace=0
set list
set listchars=tab:⇒\ ,trail:→
" set listchars=tab:»\ ,trail:¨
highlight NonText ctermfg=grey
highlight SpecialKey ctermfg=grey
set number
set cursorline
set cursorcolumn
set showcmd
set showmode
set showmatch
set ruler
set rulerformat=%=%V\ 0x%B\ %c,%l/%L\ %P
set laststatus=2
set statusline=
set statusline+=%y%r%{LinterStatus()}%m%.30F%{GitBranchStatus()}
set statusline+=%=%V\ 0x%B\ %c,%l/%L\ %P
set foldenable
set foldmethod=indent

"
" plugin
"
if filereadable(expand('~/.vim/autoload/plug.vim'))
    call plug#begin(expand('~/.vim/plugins'))
    Plug 'flazz/vim-colorschemes'
    Plug 'itchyny/vim-gitbranch'
    " Plug 'airblade/vim-gitgutter'
    " Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'mbbill/undotree'
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-easytags'
    Plug 'preservim/tagbar'
    Plug 'MattesGroeger/vim-bookmarks'
    Plug 'othree/eregex.vim'
    Plug 'mileszs/ack.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " Plug 'honza/vim-snippets'
    Plug 'dense-analysis/ale'
    Plug 'jiangmiao/auto-pairs'
    if has("python3")
        Plug 'Valloric/YouCompleteMe', {'do': 'python3 ./install.py --all'}
        " Plug 'SirVer/ultisnips'
    endif
    Plug 'editorconfig/editorconfig-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
    call plug#end()
endif

if PlugExist('vim-colorschemes')
    colorscheme synic
endif

if PlugExist('vim-gitbranch')
    function! GitBranchStatus() abort
        let l:branch=gitbranch#name()
        return l:branch == '' ? '' : '(' . l:branch . ')'
    endfunction
else
    function! GitBranchStatus() abort
        return '[!]'
    endfunction
endif

if PlugExist('easytags')
    let g:easytags_cmd='ctags-universal'
    let g:easytags_file='~/.vim/tags'
endif

if PlugExist('tagbar')
    nnoremap <Leader>tb :TagbarToggle<CR>
endif

if PlugExist('nerdtree')
    nnoremap <Leader>ft :NERDTreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
endif

if PlugExist('undotree')
    nnoremap <Leader>ut :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
endif

if PlugExist('vim-bookmarks')
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
    let g:bookmark_show_toggle_warning=0
    let g:bookmark_auto_save_file=expand('~/.vim/bookmarks')

    let g:bookmark_sign='b'
    highlight BookmarkSign term=bold ctermfg=white ctermbg=blue
    highlight BookmarkLine term=bold ctermfg=white ctermbg=blue

    let g:bookmark_annotation_sign='m'
    highlight BookmarkAnnotationSign term=bold ctermfg=white ctermbg=green
    highlight BookmarkAnnotationLine term=bold ctermfg=white ctermbg=green

    let g:bookmark_highlight_lines=0
endif

if PlugExist('ack.vim')
    if executable('rg')
        let g:ackprg='rg --vimgrep --sort path'
    elseif executable('ag')
        let g:ackprg='ag --vimgrep --no-heading'
    endif
    cnoreabbrev Ack Ack!
    nnoremap <Leader>a :Ack!<Space>
endif

if PlugExist('fzf.vim')
    let g:fzf_tags_command='ctags-universal -R'
    " let g:fzf_command_prefix='Fzf'
    nnoremap <Leader>m :Commands<CR>
endif

if PlugExist('ultisnips')
    let g:UltiSnipsExpandTrigger="<Leader>i"
    let g:UltiSnipsJumpForwardTrigger="<Leader>n"
    let g:UltiSnipsJumpBackwardTrigger="<Leader>p"
    let g:UltiSnipsEditSplit="vertical"
endif

if PlugExist('nerdcommenter')
    " let g:NERDSpaceDelims = 1
endif

if PlugExist('ale')
    function! LinterStatus() abort
        let l:counts=ale#statusline#Count(bufnr(''))
        let l:all_errors=l:counts.error + l:counts.style_error
        let l:all_non_errors=l:counts.total - l:all_errors
        return printf(
                    \   '[%dE%dW]',
                    \   all_errors,
                    \   all_non_errors
                    \)
    endfunction

    " let g:ale_completion_enabled=0

    let g:ale_linters_explicit=1
    let g:ale_linters={
                \ 'sh': ['shellcheck'],
                \ 'go': ['gofmt', 'golint', 'govet', 'gopls'],
                \ 'python': ['flake8', 'mypy'],
                \ 'markdown': ['markdownlint'],
                \ }
    " python linter
    let g:ale_python_flake8_options="--ignore=E501,E126,W503 --max-length=80"
    let g:ale_python_mypy_options="--ignore-missing-imports"

    let b:ale_fixers={
                \ 'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
                \ 'go': ['gofmt', 'goimports', 'trim_whitespace', 'remove_trailing_lines'],
                \ 'json': ['jq', 'trim_whitespace', 'remove_trailing_lines'],
                \ 'python': ['black', 'trim_whitespace', 'remove_trailing_lines'],
                \ }
    " shell formatter
    let g:ale_sh_shfmt_options="-i 4"
    " python formatter
    let g:ale_python_black_options="--skip-string-normalization --max-length=80"

    let g:ale_enabled=0
    let g:ale_lint_on_text_changed=1
    let g:ale_lint_on_insert_leave=1
    let g:ale_lint_on_filetype_changed=1
    let g:ale_lint_on_save=1
    let g:ale_lint_delay=500
    let g:ale_set_signs=1
    let g:ale_sign_column_always=0
    let g:ale_echo_msg_format='[%severity%][%linter%]%code% %s'
    let g:ale_open_list='on_save'
    let g:ale_keep_list_window_open=0
    let g:ale_loclist_msg_format='[%linter%]%code% %s'
    let g:ale_set_highlights=0

    let g:ale_sign_error='E'
    let g:ale_echo_msg_error_str='Error'
    highlight ALEError term=bold ctermfg=white ctermbg=red
    highlight ALEErrorSign term=bold ctermfg=white ctermbg=red
    " highlight ALEErrorLine term=bold ctermfg=white ctermbg=red

    let g:ale_sign_warning='W'
    let g:ale_echo_msg_warning_str='Warning'
    highlight ALEWarning term=bold ctermfg=white ctermbg=yellow
    highlight ALEWarningSign term=bold ctermfg=white ctermbg=yellow
    " highlight ALEWarningLine term=bold ctermfg=white ctermbg=yellow

    nnoremap <Leader>f :ALEFix<CR>
    nnoremap <Leader>l :ALEToggle<CR>
    nnoremap <Leader>j :ALENextWrap<CR>
    nnoremap <Leader>k :ALEPreviousWrap<CR>
else
    function! LinterStatus() abort
        return '[!]'
    endfunction
endif

if PlugExist('YouCompleteMe')
    let g:ycm_confirm_extra_conf = 0
    " XXX: ycm python3 execute command
    let g:ycm_server_python_interpreter = '/usr/bin/python3.9'
endif

if PlugExist('auto-pair')
    " g:AutoPairsShortcutToggle = ''
endif

if PlugExist('vim-go')
endif
