" =============================================================================
" Filename: autoload/increx.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/05/26 16:31:50.
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
  let digitpos = match(line[max([col('.') - len(digitword) - 1, 0]):], '\d')
  let pos = digitpos >= 0 ? digitpos + col('.') - len(digitword) : -1
  let isdigit = digitpos >= 0
  let [from, to] = ['', '']
  for words in get(g:, 'increx', s:increx)
    for word in words
      let pattern = '\C' . (word =~# '^\w' ? '\<' : '') . word . (word =~# '\w$' ? '\>' : '')
      let new = match(line[max([col('.') - len(word), 0]):], pattern)
      if new >= 0
        let newpos = max([col('.') - len(word), 0]) + new
        if pos < 0 || newpos < pos
          let [pos, from, to, isdigit] = [newpos, word, words[(index(words, word) + a:count) % len(words)], 0]
        endif
      endif
    endfor
  endfor
  if pos < 0
    return
  elseif isdigit
    let start = col('.') - len(matchstr(line[:col('.') - 1], '[-0-9]*$'))
    let reverse = line[start:] =~# '^\v\d+-\d+' && len(matchstr(line[start:], '^\v\d+')) < col('.') - start
    execute 'normal! ' . abs(a:count) . (xor(a:count > 0, reverse) ? "\<C-a>" : "\<C-x>")
  else
    silent! call setline('.', (pos > 0 ? line[:pos - 1] : '') . to . line[pos + len(from):])
    let curpos = getcurpos()
    let curpos[2] = pos + len(to)
    silent! call setpos('.', curpos)
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
