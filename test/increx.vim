let s:suite = themis#suite('Test for increx.')
let s:assert = themis#helper('assert')

let s:test_cases = [
      \ { 'line': '0', 'col': 1, 'count': 1, 'want_line': '1', 'want_col': 1 },
      \ { 'line': '0', 'col': 1, 'count': -1, 'want_line': '-1', 'want_col': 2 },
      \ { 'line': '3', 'col': 1, 'count': -6, 'want_line': '-3', 'want_col': 2 },
      \ { 'line': '-3', 'col': 1, 'count': 6, 'want_line': '3', 'want_col': 1 },
      \ { 'line': '42', 'col': 1, 'count': 1, 'want_line': '43', 'want_col': 2 },
      \ { 'line': '42', 'col': 1, 'count': 10, 'want_line': '52', 'want_col': 2 },
      \ { 'line': '42', 'col': 1, 'count': -1, 'want_line': '41', 'want_col': 2 },
      \ { 'line': '42', 'col': 1, 'count': -10, 'want_line': '32', 'want_col': 2 },
      \ { 'line': '  42  ', 'col': 1, 'count': 3, 'want_line': '  45  ', 'want_col': 4 },
      \ { 'line': '  42  ', 'col': 1, 'count': -3, 'want_line': '  39  ', 'want_col': 4 },
      \ { 'line': '  42  ', 'col': 3, 'count': 1, 'want_line': '  43  ', 'want_col': 4 },
      \ { 'line': '  42  ', 'col': 4, 'count': 1, 'want_line': '  43  ', 'want_col': 4 },
      \ { 'line': '  42  ', 'col': 5, 'count': 1, 'want_line': '  42  ', 'want_col': 5 },
      \ { 'line': '  42  ', 'col': 6, 'count': 1, 'want_line': '  42  ', 'want_col': 6 },
      \ { 'line': '  -9  ', 'col': 1, 'count': 1, 'want_line': '  -8  ', 'want_col': 4 },
      \ { 'line': '  -9  ', 'col': 3, 'count': 18, 'want_line': '  9  ', 'want_col': 3 },
      \ { 'line': '  9m  ', 'col': 3, 'count': -18, 'want_line': '  -9m  ', 'want_col': 4 },
      \ { 'line': '0001', 'col': 1, 'count': 15, 'want_line': '0020', 'want_col': 4 },
      \ { 'line': '0001', 'col': 1, 'count': 255, 'want_line': '0400', 'want_col': 4 },
      \ { 'line': '0x00', 'col': 1, 'count': 255, 'want_line': '0xff', 'want_col': 4 },
      \ { 'line': '0x00', 'col': 2, 'count': 255, 'want_line': '0xff', 'want_col': 4 },
      \ { 'line': '0x00', 'col': 3, 'count': 255, 'want_line': '0xff', 'want_col': 4 },
      \ { 'line': '0xffff', 'col': 2, 'count': 1, 'want_line': '0x10000', 'want_col': 7 },
      \ { 'line': '  10-11  ', 'col': 3, 'count': 1, 'want_line': '  11-11  ', 'want_col': 4 },
      \ { 'line': '  10-11  ', 'col': 5, 'count': 1, 'want_line': '  10-12  ', 'want_col': 7 },
      \ { 'line': '  10-11  ', 'col': 6, 'count': -1, 'want_line': '  10-10  ', 'want_col': 7 },
      \ { 'line': '  10-11  ', 'col': 7, 'count': -1, 'want_line': '  10-10  ', 'want_col': 7 },
      \ { 'line': '  2024-9-9  ', 'col': 7, 'count': 1, 'want_line': '  2024-10-9  ', 'want_col': 9 },
      \ { 'line': 'true', 'col': 1, 'count': 1, 'want_line': 'false', 'want_col': 5 },
      \ { 'line': 'true', 'col': 4, 'count': 1, 'want_line': 'false', 'want_col': 5 },
      \ { 'line': '  true  ', 'col': 1, 'count': 1, 'want_line': '  false  ', 'want_col': 7 },
      \ { 'line': '  false  ', 'col': 7, 'count': 1, 'want_line': '  true  ', 'want_col': 6 },
      \ { 'line': '  true  ', 'col': 6, 'count': -1, 'want_line': '  false  ', 'want_col': 7 },
      \ { 'line': '  True  ', 'col': 1, 'count': 1, 'want_line': '  False  ', 'want_col': 7 },
      \ { 'line': '  FALSE  ', 'col': 7, 'count': 1, 'want_line': '  TRUE  ', 'want_col': 6 },
      \ { 'line': '  faLSE  ', 'col': 7, 'count': 1, 'want_line': '  faLSE  ', 'want_col': 7 },
      \ { 'line': '  ttruee  ', 'col': 1, 'count': 1, 'want_line': '  ttruee  ', 'want_col': 1 },
      \ { 'line': 'and', 'col': 1, 'count': 1, 'want_line': 'or', 'want_col': 2 },
      \ { 'line': 'and', 'col': 1, 'count': 2, 'want_line': 'and', 'want_col': 3 },
      \ { 'line': 'or', 'col': 1, 'count': 5, 'want_line': 'and', 'want_col': 3 },
      \ { 'line': 'or', 'col': 1, 'count': 8, 'want_line': 'or', 'want_col': 2 },
      \ { 'line': 'on', 'col': 1, 'count': 1, 'want_line': 'off', 'want_col': 3 },
      \ { 'line': 'off', 'col': 3, 'count': 1, 'want_line': 'on', 'want_col': 2 },
      \ { 'line': '&&', 'col': 1, 'count': 1, 'want_line': '||', 'want_col': 2 },
      \ { 'line': '   ||   ', 'col': 5, 'count': -1, 'want_line': '   &&   ', 'want_col': 5 },
      \ { 'line': '  true true true  ', 'col': 1, 'count': 1, 'want_line': '  false true true  ', 'want_col': 7 },
      \ { 'line': '  true true true  ', 'col': 6, 'count': 1, 'want_line': '  false true true  ', 'want_col': 7 },
      \ { 'line': '  true true true  ', 'col': 7, 'count': 1, 'want_line': '  true false true  ', 'want_col': 12 },
      \ { 'line': '  true true true  ', 'col': 11, 'count': 1, 'want_line': '  true false true  ', 'want_col': 12 },
      \ { 'line': '  true true true  ', 'col': 12, 'count': 1, 'want_line': '  true true false  ', 'want_col': 17 },
      \ { 'line': '  true true true  ', 'col': 16, 'count': 1, 'want_line': '  true true false  ', 'want_col': 17 },
      \ { 'line': '  true true true  ', 'col': 17, 'count': 1, 'want_line': '  true true true  ', 'want_col': 17 },
      \ { 'line': '  true 42 true  ', 'col': 6, 'count': 1, 'want_line': '  false 42 true  ', 'want_col': 7 },
      \ { 'line': '  true 42 true  ', 'col': 7, 'count': 1, 'want_line': '  true 43 true  ', 'want_col': 9 },
      \ { 'line': '  true 42 true  ', 'col': 9, 'count': 1, 'want_line': '  true 43 true  ', 'want_col': 9 },
      \ { 'line': '  true 42 true  ', 'col': 10, 'count': 1, 'want_line': '  true 42 false  ', 'want_col': 15 },
      \ { 'line': '  123 true 456  ', 'col': 1, 'count': 1, 'want_line': '  124 true 456  ', 'want_col': 5 },
      \ { 'line': '  123 true 456  ', 'col': 6, 'count': 1, 'want_line': '  123 false 456  ', 'want_col': 11 },
      \ ]

function! s:suite.__incr__()
  let child = themis#suite('incr')
  for test_case in s:test_cases
    let child[string(test_case)] = funcref('s:assert', [test_case])
  endfor
endfunction

function! s:assert(test_case)
  call setline(1, a:test_case.line)
  call cursor(1, a:test_case.col)
  call increx#incr(a:test_case.count)
  call s:assert.equals(getline(1), a:test_case.want_line)
  call s:assert.equals(col('.'), a:test_case.want_col)
endfunction
