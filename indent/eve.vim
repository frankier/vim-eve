" Indentation

setlocal nolisp " Make sure lisp indenting doesn't supersede us
setlocal autoindent " indentexpr isn't much help otherwise

setlocal indentexpr=GetEveIndent(v:lnum)
setlocal indentkeys+=[,],=,<:>,<space>,=search,=match,=commit,=bind

function! s:eveToEveCodeFenceJustInserted(lnum)
  " In the case we've just automatically inserted a code fence, hightlighting
  " has not yet had a chance to run
  if (a:lnum < 5)
    return 0
  endif
  if !VimEve_LineIsEve(a:lnum - 4)
    return 0
  endif
  if getline(a:lnum - 3) !=# '```'
    return 0
  endif
  if getline(a:lnum - 2) !=# '```'
    return 0
  endif
  return 1
endfunction

function! s:getMarkdownIndent(lnum)
  if a:lnum == 1
    return 0
  endif
  if getline(a:lnum - 1) ==# '```'
    return 0
  endif
  " TODO: Handle (nested) lists. Can another Markdown plugin be reused?
  return -1
endfunction

function! GetEveIndent(lnum)
  if ((!VimEve_LineIsEve(a:lnum)) && (!s:eveToEveCodeFenceJustInserted(a:lnum)))
    return s:getMarkdownIndent()
  end
  let plnum = prevnonblank(a:lnum - 1)
  if plnum == 0
    " Should be impossible
    return 0
  end
  let curline = getline(a:lnum)
  if VimEve_LineIsAction(curline)
    " Indent at same level as previous action
    while plnum >= 1
      let prevline = getline(plnum)
      if (VimEve_LineIsAction(prevline) && VimEve_LineIsEve(plnum))
        return indent(plnum)
      end
      let plnum -= 1
    endwhile
    " Otherwise leave it be
    return -1
  else
    if VimEve_LineIsAction(getline(plnum))
      return indent(plnum) + shiftwidth()
    end
    " Big TODO: [#big nested: [#records with] all sorts: [of: stuff]]
    " Should be able to crib off another plugin
    return -1
  end
endfunction
