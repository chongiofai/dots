" ~/.vimrc

" function
"
function! ExistPlugin(plugin)
    if isdirectory(expand("~/.vim/plugins/" . a:plugin))
        return 1
    endif
    return 0
endfunction

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

function! ToggleLocList()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        lopen
    else
        lclose
    endif
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

function! PlugDownload()
    if !filereadable(expand('~/.vim/autoload/plug.vim'))
        exec '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endfunction
command! PlugDownload call PlugDownload()

" general
"
set nocompatible
" nnoremap , ;
" vnoremap , ;
nnoremap \ ;
vnoremap \ ;
set timeout
set timeoutlen=3000
set ttimeoutlen=100
let mapleader=';'
call InitVim()
syntax on
set undofile
set mouse=i
set t_Co=256
set encoding=utf-8
set autoindent
set tabstop=4
set linespace=0
set list
" set listchars=tab:»\ ,trail:¨
set listchars=tab:⇒\ ,trail:→
set showmatch
set cursorline
set cursorcolumn
set nowrap
set number
set showcmd
set showmode
set ruler
set rulerformat=%=%V\ 0x%B\ %c,%l/%L\ %P
set laststatus=2
set statusline=
set statusline+=%y%r%{LinterStatus()}%m%.30F%{GitBranchStatus()}
set statusline+=%=%V\ 0x%B\ %c,%l/%L\ %P
set foldenable
set foldmethod=indent

" plugin
"
if filereadable(expand('~/.vim/autoload/plug.vim'))
    call plug#begin(expand('~/.vim/plugins'))
    Plug 'flazz/vim-colorschemes'
    Plug 'itchyny/vim-gitbranch'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
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
    Plug 'honza/vim-snippets'
    Plug 'dense-analysis/ale'
    " Plug 'jiangmiao/auto-pairs'
    if has("python3")
        Plug 'Valloric/YouCompleteMe', {'do': '/bin/env python3 ./install.py --all'}
        Plug 'SirVer/ultisnips'
    endif
    Plug 'editorconfig/editorconfig-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'fatih/vim-go'
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

if ExistPlugin('easytags')
    let g:easytags_cmd='ctags-universal'
    let g:easytags_file='~/.vim/tags'
endif

if ExistPlugin('tagbar')
    nnoremap <Leader>tb :TagbarToggle<CR>
endif

if ExistPlugin('nerdtree')
    nnoremap <Leader>ft :NERDTreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
endif

if ExistPlugin('undotree')
    nnoremap <Leader>ut :UndotreeToggle<CR>
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
    highlight BookmarkSign term=bold ctermfg=white ctermbg=blue
    highlight BookmarkLine term=bold ctermfg=white ctermbg=blue
    highlight BookmarkAnnotationSign term=bold ctermfg=white ctermbg=green
    highlight BookmarkAnnotationLine term=bold ctermfg=white ctermbg=green
endif

if ExistPlugin('ack.vim')
    if executable('rg')
        let g:ackprg='rg --vimgrep --sort path'
    elseif executable('ag')
        let g:ackprg='ag --vimgrep --no-heading'
    endif
    cnoreabbrev Ack Ack!
    nnoremap <Leader>a :Ack!<Space>
endif

if ExistPlugin('fzf.vim')
    let g:fzf_tags_command='ctags-universal -R'

    let g:fzf_command_prefix='Fzf'
    nnoremap <Leader>m :FzfCommands<CR>
endif

if ExistPlugin('ultisnips')
    let g:UltiSnipsExpandTrigger="<Leader>i"
    let g:UltiSnipsJumpForwardTrigger="<Leader>n"
    let g:UltiSnipsJumpBackwardTrigger="<Leader>p"
    let g:UltiSnipsEditSplit="vertical"
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
    nnoremap <Leader>f :Autoformat<CR>
endif

if ExistPlugin('ale')
    function! LinterStatus() abort
        let l:counts=ale#statusline#Count(bufnr(''))
        let l:all_errors=l:counts.error + l:counts.style_error
        let l:all_non_errors=l:counts.total - l:all_errors
        return printf(
                    \   '[%de%dw]',
                    \   all_errors,
                    \   all_non_errors
                    \)
    endfunction

    let g:ale_enabled=1
    let g:ale_set_signs=1
    let g:ale_sign_column_always=1
    let g:ale_sign_error='E'
    let g:ale_sign_warning='W'
    let g:ale_echo_msg_error_str='Error'
    let g:ale_echo_msg_warning_str='Warning'
    let g:ale_echo_msg_format='[%severity%][%linter%]%code% %s'
    let g:ale_open_list='on_save'
    let g:ale_keep_list_window_open=0
    let g:ale_set_loclist=1
    let g:ale_loclist_msg_format='[%linter%]%code% %s'
    let g:ale_set_quickfix=1
    let g:ale_lint_delay=200
    let g:ale_lint_on_text_changed=1
    let g:ale_lint_on_insert_leave=1
    let g:ale_lint_on_filetype_changed=1
    let g:ale_lint_on_save=1
    let g:ale_completion_enabled=0
    let g:ale_linters_explicit=1
    let g:ale_linters={
                \ 'sh': ['shellcheck'],
                \ 'dockerfile': ['dockerfile_lint'],
                \ 'go': ['gofmt', 'golint', 'govet'],
                \ 'python': ['flake8', 'mypy'],
                \ 'javascript': ['eslint', 'standard'],
                \ 'yaml': ['yamllint'],
                \ 'markdown': ['markdownlint'],
                \ }
    let b:ale_fixers={
                \ 'sh': ['shfmt'],
                \ 'go': ['gofmt'],
                \ 'json': ['jq'],
                \ 'python': ['trim_whitespace', 'remove_trailing_lines', 'black'],
                \ }
    " shell
    let g:ale_sh_shfmt_options="-i 4"
    " python
    let g:ale_python_flake8_options="--ignore=E501,E126,W503"
    let g:ale_python_mypy_options="--ignore-missing-imports"
    let g:ale_python_black_options="--skip-string-normalization"

    let g:ale_set_highlights=0
    highlight ALEError term=bold ctermfg=white ctermbg=red
    highlight ALEErrorLine term=bold ctermfg=white ctermbg=red
    highlight ALEErrorSign term=bold ctermfg=white ctermbg=red
    highlight ALEErrorSignLineNr term=bold ctermfg=white ctermbg=red
    highlight ALEWarning term=bold ctermfg=white ctermbg=yellow
    highlight ALEWarningLine term=bold ctermfg=white ctermbg=yellow
    highlight ALEWarningSign term=bold ctermfg=white ctermbg=yellow
    highlight ALEWarningSignLineNr term=bold ctermfg=white ctermbg=yellow

    nnoremap <Leader>f :ALEFix<CR>
    nnoremap <Leader>l :call ToggleQuickFix()<CR>
    nnoremap <Leader>j :ALENextWrap<CR>
    nnoremap <Leader>k :ALEPreviousWrap<CR>
    autocmd QuitPre * if empty(&bt) | lclose | endif
    autocmd QuitPre * if empty(&bt) | cclose | endif
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
    " let g:NERDSpaceDelims = 1
endif
