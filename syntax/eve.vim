if exists("b:current_syntax")
    finish
endif

if get(g:, 'eve_highlight_markdown', 0)
    unlet! b:current_syntax
    runtime! syntax/markdown.vim

    unlet! b:current_syntax
    syntax include @markdown syntax/markdown.vim

    unlet! b:current_syntax
    syntax include @raweve syntax/raweve.vim

    syntax region eveLineCode start='^    ' end='$' containedin=@markdown contains=@raweve
    syntax region eveBlockCode start='^```' end='^```' containedin=@markdown contains=@raweve
else
    unlet! b:current_syntax
    syntax include @raweve syntax/raweve.vim

    syntax region eveMarkdownComment start="\%^" end="\%$" contains=eveEmptyMarkdown,eveBeginEndZone
    if get(g:, 'eve_fold_code', 0)
        setlocal foldmethod=syntax
        syntax region eveBeginEndZone start="^```" end="^```" transparent fold keepend contained contains=@raweve,eveMarkdownCommentMarkers
    else
        syntax region eveBeginEndZone start="^```" end="^```" keepend contained contains=@raweve,eveMarkdownCommentMarkers
    endif
    if get(g:, 'eve_fold_empty', 0)
        setlocal foldmethod=expr
        function! GetEveFold(lnum)
            if getline(a:lnum) !=# '```'
                return 0
            endif
            if getline(a:lnum - 1) ==# '```' || getline(a:lnum + 1) ==# '```'
                return 1
            endif
            return 0
        endfunction
        setlocal foldexpr=GetEveFold(v:lnum)
    endif
    syntax match eveMarkdownCommentMarkers "^```" contained

    highlight link eveMarkdownComment Comment
    highlight link eveMarkdownCommentMarkers Comment
endif

syntax sync fromstart

let b:current_syntax = 'eve'
