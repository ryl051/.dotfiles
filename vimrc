let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
call plug#end()

" ^ plugin stuff

let mapleader = " "
 
nnoremap <F5> :w<CR>:!python3 %<CR>
nnoremap <F6> :w<CR>:!g++ -std=c++17 -O2 -Wall % -o %:r && ./%:r<CR>
nnoremap <leader><leader> :Files<CR>
nnoremap <leader>sg :Rg<CR>
nnoremap <leader>ss :LspDocumentSymbolSearch<CR>
nnoremap <leader>e :E<CR>
nnoremap H :bp<CR>
nnoremap L :bn<CR>

syntax on

set hls
set is
set cb=unnamed
set ts=4
set sw=4
set si
set backspace=indent,eol,start
set mouse=a
set ignorecase
set smartcase

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

" auto numbering system when going between insert and normal
set nu
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	" Jump to definition
	nmap <buffer> gd <plug>(lsp-definition)
	" Find references
	nmap <buffer> gr <plug>(lsp-references)
	" Rename symbol
	nmap <buffer> <f2> <plug>(lsp-rename)
	" Show hover documentation
	nmap <buffer> K <plug>(lsp-hover)
endfunction
 
augroup lsp_install
    au!
 	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

if executable('clip.exe')
    autocmd TextYankPost * if v:event.operator ==# 'y' | call system('clip.exe', @") | endif
endif
