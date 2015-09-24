" =============================================================================
" Filename: autoload/increx.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/09/24 19:51:53.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:increx = [
      \ [ 'true', 'false' ],
      \ [ 'True', 'False' ],
      \ [ 'TRUE', 'FALSE' ],
      \ [ 'and', 'or' ],
      \ [ 'on', 'off' ],
      \ [ 'up', 'down' ],
      \ [ 'before', 'after' ],
      \ [ 'even', 'odd' ],
      \ [ 'left', 'right' ],
      \ [ 'height', 'width' ],
      \ [ '&&', '||' ],
      \ ]

function! increx#incr(count) abort
  let line = getline('.')
  let digitword = matchstr(line[:col('.') - 1], '[0-9a-fx]*$')
  let digitpos = match(line[col('.') - len(digitword) - 1:], '\d')
  let pos = digitpos >= 0 ? digitpos + col('.') - len(digitword) : -1
  let isdigit = digitpos >= 0
  let [ from, to ] = [ '', '' ]
  for words in get(g:, 'increx', s:increx)
    for word in words
      let pattern = '\C' . (word =~# '^\w' ? '\<' : '') . word . (word =~# '\w$' ? '\>' : '')
      let new = match(line[max([col('.') - len(word), 0]):], pattern)
      if new >= 0
        let newpos = max([col('.') - len(word), 0]) + new
        let pos = pos >= 0 ? min([pos, newpos]) : newpos
        if pos == newpos
          let [ from, to, isdigit ] = [ word, words[(index(words, word) + a:count) % len(words)], 0 ]
        endif
      endif
    endfor
  endfor
  if pos >= 0 && !isdigit
    silent! call setline('.', (pos > 0 ? line[:pos - 1] : '') . to . line[pos + len(from):])
    let curpos = getcurpos()
    let curpos[2] = pos + len(to)
    silent! call setpos('.', curpos)
  elseif isdigit
    execute 'normal! ' . abs(a:count) . (a:count > 0 ? "\<C-a>" : "\<C-x>")
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
