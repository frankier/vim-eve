if exists("b:current_syntax")
    finish
endif

syntax keyword eveClauseKeyword match search bind commit
syntax keyword eveConditional if then else
syntax keyword evePrefixOp not is
syntax region eveString start=/\v"/ skip=/\v\\./ end=/\v"/

syntax match eveTag "\v#[-0-9A-Za-z_]+"
syntax match eveInt "\v\-?[0-9]+(\.[0-9]+)?"
syntax match eveDatabase "\v\@[-0-9A-Za-z_]+"
syntax match eveFunction "\v[-0-9A-Za-z_]+\["he=e-1

syntax match eveUpdate '\v\+\='
syntax match eveUpdate '\v:\='
syntax match eveUpdate '\v\-\='
syntax match eveUpdate '\v<\-'
syntax match eveUpdate '\v\+\='

syntax match eveArith '\v( \+ )'
syntax match eveArith '\v( \- )'
syntax match eveArith '\v( / )'
syntax match eveArith '\v( \* )'

syntax match eveIneq '\v\<='
syntax match eveIneq '\v\>='
syntax match eveIneq '\v!='
syntax match eveIneq '\v\<'
syntax match eveIneq '\v\>'

syntax match eveEq '\v\='
syntax match eveEq '\v:'

highlight link eveClauseKeyword Keyword
highlight link eveConditional Conditional
highlight link eveString String
highlight link eveTag String
highlight link eveInt Number
highlight link eveDatabase Constant
highlight link eveFunction Function

highlight link eveArith Operator
highlight link eveEq Operator
highlight link eveIneq Operator
highlight link eveUpdate Operator
highlight link evePrefixOp Operator

let b:current_syntax = "raweve"
