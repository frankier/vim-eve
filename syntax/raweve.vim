if exists("b:current_syntax")
    finish
endif

syntax keyword eveAction match search bind commit
syntax keyword eveConditional if then else
syntax keyword evePrefixOp not is
syntax region eveString start=/\v"/ skip=/\v\\./ end=/\v"/ oneline contains=eveInterpolatedStatement
syntax region eveInterpolatedStatement start=/{{/hs=s+2 end=/}}/he=e-2 contains=@raweve

syntax match eveTag "\v#[-\0-9A-Za-z/]+"
syntax match eveInt "\v\W\-?[0-9]+(\.[0-9]+)?"
syntax match eveFunction "\v[-0-9A-Za-z_/]+\["he=e-1

syntax match eveIneq '\v\<\='
syntax match eveIneq '\v\>\='
syntax match eveIneq '\v!\='
syntax match eveIneq '\v\<'
syntax match eveIneq '\v\>'

syntax match eveEq '\v\='
syntax match eveEq '\v:'

syntax match eveUpdate '\v\+\='
syntax match eveUpdate '\v:\='
syntax match eveUpdate '\v\-\='
syntax match eveUpdate '\v\<\-'
syntax match eveUpdate '\v\+\='

syntax match eveArith '\v( \+ )'
syntax match eveArith '\v( \- )'
syntax match eveArith '\v( / )'
syntax match eveArith '\v( \* )'

syntax match eveComment "\v//.*$"

highlight link eveAction Keyword
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

highlight link eveComment Comment

let b:current_syntax = "raweve"


