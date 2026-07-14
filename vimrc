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

filetype plugin indent on

nnoremap <F5> :w<CR>:!python3 %<CR>
nnoremap <F6> :w<CR>:!g++ -std=c++17 -O2 -Wall % -o %:r && ./%:r<CR>

autocmd BufRead,BufNewFile *.v,*.sv set filetype=verilog

set hls
set is
set cb=unnamed
set ts=4
set sw=4
set si
set backspace=indent,eol,start
set mouse=a

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}
autocmd filetype verilog inoremap begin<CR> begin<CR>end<Esc>O
autocmd filetype cpp nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $
autocmd filetype python nnoremap <C-C> :s/^\(\s*\)/\1#/<CR> :s/^\(\s*\)##/\1/<CR> $

set nu
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

set diffexpr=MyDiff()
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
