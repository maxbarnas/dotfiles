" Jezen Thomas’ .vimrc
"   jezen@jezenthomas.com
"   jezenthomas.com

" Thanks to:
"   - Steve Losh
"   - Gary Bernhardt
"   - Amir Salihefendic
"   - Vincent Driessen
"   - Benjamin Reitzammer

" Init & Vundle ------------------------------------------------------------ {{{
set nocompatible
filetype off
set rtp+=~/dotfiles/vim/bundle/Vundle.vim
call vundle#begin()

" Need this for Vundle to work
Plugin 'gmarik/Vundle.vim'

" Gary Bernhardt’s colour scheme
Plugin 'quanganhdo/grb256'
set t_Co=256
colorscheme grb256

" Pimp my editor
Plugin 'bling/vim-airline'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'https://github.com/mileszs/ack.vim'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-fugitive'

" Language specific
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'kchmck/vim-coffee-script'
Plugin 'derekwyatt/vim-scala'
Plugin 'wavded/vim-stylus'
Plugin 'tpope/vim-fireplace'

call vundle#end()
filetype plugin indent on
" }}}
" Basic config ------------------------------------------------------------- {{{
" This makes RVM work inside Vim.
set shell=bash
set lazyredraw
set autoread
set hidden
set noesckeys
" set cryptmethod=blowfish2 " https://dgl.cx/2014/10/vim-blowfish
set exrc " Enable use of project-specific .vimrc
set secure " Only run autocommands owned by me
" }}}
" UI ----------------------------------------------------------------------- {{{
set number
set relativenumber                " Show relative line numbers
syntax on                         " Enable syntax highlighting
set ruler                         " Show current position in status bar
set cursorline                    " Highlight current line
set synmaxcol=800                 " Don’t highlight lines longer than 800 chars
set wrap                          " Soft-wrap long lines
set linebreak
set showbreak=↪                   " Prefix linebreaks with this fancy arrow
set scrolloff=5                   " Keep at least 5 lines above/below
set title                         " Change terminal title
set showmode                      " Always show current mode
set laststatus=2                  " Make sure airline isn’t hidden
let g:airline_powerline_fonts = 1 " Custom airline font
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
set shortmess=atI                 " Hide intro message
set showcmd                       " Show command as it’s being typed
set list                          " Show invisible characters
set noerrorbells                  " Disable bells
set wildmenu                      " Enhance command-line completion

" Default netrw to tree mode
let g:netrw_liststyle=3

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" }}}
" Editing ------------------------------------------------------------------ {{{
set clipboard=unnamed             " Use the system clipboard
set et                            " Pressing TAB creates spaces instead
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start    " Allow backspace in insert mode
set lcs=tab:▸\ ,extends:❯,precedes:❮,nbsp:.,trail:·,eol:¬
set nobackup                      " Disable backups
set nowb                          " Disable write backups
set noswapfile                    " Disable swap files
set completeopt-=preview          " Disable scratch preview buffer
set ttyfast
set encoding=utf-8 nobomb         " Use UTF-8 without BOM
set nojoinspaces                  " Don’t double space after join
set splitbelow                    " I always thought vim opened splits backwards
set splitright
" }}}
" Convenience mappings ----------------------------------------------------- {{{

" Please, do not use comma for leader. You need the comma for moving to a
" previous match from a linewise character search.
let mapleader="\<space>"

" Clean trailing whitespace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Since I remapped H and L to move to the beginning and end of the current
" line respectively, something in my subconscious made me start using K to
" move to the top of the buffer. By default, K will open the man page for the
" term under the cursor, which is completely useless to me.
nnoremap K <nop>

" Fast saving
nmap <leader>s :w!<cr>

" Save as super user
noremap <leader>S :w !sudo tee % > /dev/null<CR>

" Fast quit
nmap <leader>q :q<cr>

" Jump to first character or column
noremap <silent> H :call FirstCharOrFirstCol()<cr>
" Jump to end of line
noremap L $

function! FirstCharOrFirstCol()
  let current_col = virtcol('.')
  normal ^
  let first_char = virtcol('.')
  if current_col <= first_char
    normal 0
  endif
endfunction

" Toggle alternate buffer
nnoremap <leader><leader> <c-^>

" Emoticons
iabbrev ldis ಠ_ಠ
iabbrev lsir ಠ_ರೃ
iabbrev lhap ツ
iabbrev fliptable （╯°□°）╯ ┻━┻
iabbrev *shrug* ¯\_(ツ)_/¯
iabbrev herewego ᕕ( ᐛ )ᕗ
iabbrev dealwithit (⌐■_■)
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>h :split<cr>
" }}}
" Searching ---------------------------------------------------------------- {{{
set showmatch                     " Show matching bracket when under cursor
set hlsearch                      " Highlight search results
set ignorecase                    " Ignore case when searching
set smartcase                     " Case-sensitive if pattern includes uppercase
set incsearch                     " Highlight dynamically while typing

" Clear the higlighted search results
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Keep search matches in middle of window
nnoremap n nzzzv
nnoremap N Nzzzv

" Ignore stuff from Command-T
set wildignore+=.hg,.git,.svn                                     " version control
set wildignore+=bower_components,_bower_components,node_modules   " frontend packages
set wildignore+=*.jpg,*.png,*.gif,pics                            " binary images
set wildignore+=core                                              " uxpin framework
set wildignore+=venv                                              " python
set wildignore+=*.eot,*.svg,*.ttf,*.woff                          " fonts
set wildignore+=dist                                              " generated distribution packages
set wildignore+=tmp,temp
set wildignore+=*.lock,*.db
set wildignore+=activator*
set wildignore+=app/assets/javascripts/lib/*
set wildignore+=*.pdf
set wildignore+=report
set wildignore+=*/target/*
set wildignore+=_site/*
set wildignore+=vendor
set wildignore+=*.pyc
set wildignore+=compiled
set wildignore+=*.www
" }}}
" Folding ------------------------------------------------------------------ {{{
set foldlevelstart=0
set foldmethod=marker " Use three curly braces
" Toggle folds with minus
nnoremap - za
vnoremap - za

" Focus current fold
nnoremap <leader>z zMzvzz

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()
" }}}
" Automatic commands ------------------------------------------------------- {{{
if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  au BufNewFile,BufRead *.json setfiletype json syntax=javascript
  au BufNewFile,BufRead *.cap setfiletype cap syntax=ruby
  au BufNewFile,BufRead *.txt,conf/messages.* call FoldParagraphs()
  au BufNewFile,BufRead *.md setlocal syntax=off tw=80
  " Automatically open quickfix window when calling :make, or close the
  " quickfix window if there are no errors to report
  au QuickFixCmdPost [^l]* nested cwindow
  au QuickFixCmdPost    l* nested lwindow
endif

function! FoldParagraphs()
  set foldmethod=expr
  set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
endfunction

" Make sure Vim returns to the same line when reopening a file
augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute 'normal! g`"zvzz' |
    \ endif
augroup END

" Auto-reload vim when vimrc changes
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" }}}
" Ruby on Rails ------------------------------------------------------------ {{{
" Fast-way to run rspec from vim, thanks to Gary Bernhardt
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        " First choice: project-specific test script
        if filereadable("script/test")
            exec ":!clear & script/test " . a:filename
        " Fall back to the .test-commands pipe if available, assuming someone
        " is reading the other side and running the commands
        elseif filewritable(".test-commands")
          let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
          exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

          " Write an empty string to block until the command completes
          sleep 100m " milliseconds
          :!echo > .test-commands
          redraw!
        " Fall back to a blocking test run with Bundler
        elseif filereadable("Gemfile")
            exec ":!clear & bundle exec rspec --color " . a:filename
        " Fall back to a normal blocking test run
        else
            exec ":!clear & rspec --color " . a:filename
        end
    end
endfunction

nnoremap <leader>a :call RunTests('')<cr>
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>rs :call SetTestFile()<cr>
nnoremap <leader>rt :call RunTestFile()<cr>

" Corresponds with G. Bernhardt’s Cucumber wrapper
nnoremap <leader>C :w\|:!clear & script/features --format progress<cr>
nnoremap <leader>c :w\|:!clear & script/features --profile wip --format pretty<cr>
"}}}
