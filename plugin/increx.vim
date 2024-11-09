" =============================================================================
" Filename: plugin/increx.vim
" Author: itchyny
" License: MIT License
" Last Change: 2024/11/09 17:02:34.
" =============================================================================

if exists('g:loaded_increx') || v:version < 900
  finish
endif
let g:loaded_increx = 1

let s:save_cpo = &cpo
set cpo&vim

nnoremap <silent> <Plug>(increx-incr) :<C-u>call increx#incr(v:count1)<CR>
nnoremap <silent> <Plug>(increx-decr) :<C-u>call increx#incr(-v:count1)<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
