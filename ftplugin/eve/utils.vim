function! VimEve_LineIsEve(lnum)
  let stack = synstack(a:lnum, 1)
  let isEve = len(stack) >= 2 && synIDattr(stack[1], "name") == "eveBeginEndZone"
  let isFence = VimEve_LineIsFence(getline(a:lnum))
  return isEve && !isFence
endfunction

function! VimEve_LineIsAction(line)
  return a:line =~# '\v^\s*(search|match|bind|commit)(\s+\@\S+)*\s*$'
endfunction

function! VimEve_LineIsFence(line)
  return a:line =~# '\v^\s*```\s*$'
endfunction
