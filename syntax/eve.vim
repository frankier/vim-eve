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

    syntax region eveMarkdownComment start="\%^" end="\%$" contains=eveBeginEndZone
    syntax region eveBeginEndZone start="^```" end="^```" keepend contained contains=@raweve,eveLiterateCommentMarkers
    syntax match eveMarkdownCommentMarkers "^```" contained

    highlight link eveMarkdownComment Comment
    highlight link eveMarkdownCommentMarkers Comment
endif

let b:current_syntax = 'eve'
