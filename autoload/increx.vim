" =============================================================================
" Filename: autoload/increx.vim
" Author: itchyny
" License: MIT License
" Last Change: 2024/11/09 17:21:30.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:increx = [
      \ [ 'true', 'false' ],
      \ [ 'True', 'False' ],
      \ [ 'TRUE', 'FALSE' ],
      \ [ 'yes', 'no' ],
      \ [ 'on', 'off' ],
      \ [ 'and', 'or' ],
      \ [ '&&', '||' ],
      \ ]

function! increx#incr(count) abort
  let line = getline('.')
  let [pos, after] = [match(line, '\v\C%(\d+|0x\x+)%>.c|$'), '']
  for words in get(g:, 'increx', s:increx)
    let pattern = join(mapnew(words, 'v:val =~# "\\<.\\+\\>" ? "\\<" . v:val . "\\>" '
          \ . ': "[" . join(words, "") . "]\\@<!" . v:val . "[" . join(words, "") . "]\\@!"'), '\|')
    let [word, newpos, newendpos] = matchstrpos(line, '\m\C\%(' . pattern . '\)\%>.c')
    if 0 <= newpos && newpos < pos
      let [pos, endpos, after] = [newpos, newendpos, words[(index(words, word) + a:count) % len(words)]]
    endif
  endfor
  if after ==# ''
    execute 'normal! ' . abs(a:count) . (xor(a:count > 0, line =~# '\v\C<\d*%<.c\d-\d+%>.c') ? "\<C-a>" : "\<C-x>")
  else
    let curpos = getcurpos()
    let curpos[2] = pos + len(after)
    call setline('.', strpart(line, 0, pos) . after . strpart(line, endpos))
    call setpos('.', curpos)
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
