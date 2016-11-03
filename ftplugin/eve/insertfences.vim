" Good (default) behaviour
" Delete all previous blank lines including leading whitespace
" From Eve,
" Search doesn't require a blank line
" Bind, commit require one blank line
" => Markdown requires two blank lines and is independent of content
" From Markdown
" Search, bind, commit require two blank lines

if get(g:, 'eve_insert_code_fence', 0)
  augroup eve_insert_code_fence
    autocmd! InsertLeave,TextChangedI,TextChanged,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,CompleteDone * call s:maybeInsertCodeFence()
  augroup END
endif

function! s:getBlankLines(lnum)
  let lines = 0
  let prev_lnum = a:lnum - 1
  while getline(prev_lnum) =~# '^\s*$' && prev_lnum >= 1
    let lines += 1
    let prev_lnum -= 1
  endwhile
  return lines
endfunction

function! s:deletePrevLines(lines)
  if a:lines == 0
    return
  endif
  execute "normal! mq" . a:lines . "k" . a:lines . "dd\<esc>`q"
endfunction

function! s:changeEveMarkdownBlock()
  execute "normal! mqO```\<esc>`q"
endfunction

function! s:newEveBlock()
  execute "normal! mqO```\<cr>```\<esc>`q"
  if get(g:, 'eve_fold_empty', 0)
    execute "normal! zx"
  endif
endfunction

function! s:getE2mBlanks()
  return get(g:, 'eve_e2m_blanks', 2)
endfunction

function! s:getM2eBlanks()
  return get(g:, 'eve_m2e_blanks', 2)
endfunction

function! s:getE2eBlanks()
  return get(g:, 'eve_e2e_blanks', 2)
endfunction

function! s:getE2eBlanksSearch()
  let e2eBlanks = s:getE2eBlanks()
  return get(g:, 'eve_e2e_blanks_search', e2eBlanks)
endfunction

function! s:maybeInsertCodeFence()
  let c_lnum = line('.')
  if c_lnum <= 1
    let curline = getline(c_lnum)
    if (!VimEve_LineIsAction(curline))
      return
    end
    " Special case -- starting a file with an Eve block
    execute "normal! mqO```\<esc>`q"
    return
  endif
  let numBlankLines = s:getBlankLines(c_lnum)
  let curline = getline(c_lnum)
  if strlen(curline) < 4
    return
  endif
  if VimEve_LineIsEve(c_lnum - 1)
    if VimEve_LineIsAction(curline)
      if curline =~# '\v^\s*search(\s+\@\S+)*\s*$'
        let e2eBlanksSearch = s:getE2eBlanksSearch()
        if e2eBlanksSearch == -1 || numBlankLines < e2eBlanksSearch
          return
        endif
      else
        let e2eBlanks = s:getE2eBlanks()
        if e2eBlanks == -1 || numBlankLines < e2eBlanks
          return
        endif
      endif
      " Too near the beginning of an Eve block to apply
      if c_lnum < 4 || !VimEve_LineIsEve(c_lnum - 2) || !VimEve_LineIsEve(c_lnum - 3)
        return
      endif
      " Eve block => new Eve block
      echom "Eve block => new Eve block"
      call s:deletePrevLines(numBlankLines)
      call s:newEveBlock()
    elseif curline =~# '\v ?\S+\s'
      let e2mBlanks = s:getE2mBlanks()
      if e2mBlanks == -1 || numBlankLines < e2mBlanks
        return
      endif
      " Eve block => Markdown block
      echom "Eve block => new Markdown block"
      call s:deletePrevLines(numBlankLines)
      call s:changeEveMarkdownBlock()
    endif
  elseif VimEve_LineIsAction(curline)
    let m2eBlanks = s:getM2eBlanks()
    if m2eBlanks == -1 || numBlankLines < m2eBlanks
      return
    endif
    " Markdown block => Eve block
    echom "Markdown block => new Eve block"
    call s:deletePrevLines(numBlankLines)
    call s:changeEveMarkdownBlock()
  endif
endfunction
