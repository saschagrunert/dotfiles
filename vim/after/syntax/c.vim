" Custom comments
syn region myCComment start="/\*" end="\*/" fold keepend transparent

" Keywords
syn keyword cType u8 u16 u32 u64
syn keyword cBoolean true false TRUE FALSE

" Operators
syn match cOperator "\(<<\|>>\|[-+*/%&^|<>!=]\)="
syn match cOperator "<<\|>>\|&&\|||\|++\|--\|->"
syn match cOperator "[.!~*&%<>^|=,+-]"
syn match cOperator "/[^/*=]"me=e-1
syn match cOperator "/$"
syn match cOperator "&&\|||"
syn match cOperator "[][]"

" Preprocs
syn keyword cDefined defined contained containedin=cDefine
syn match cDefineRef "\v\w@<!(\u|_+[A-Z0-9])[A-Z0-9_]*\w@!"
hi def link cDefined cDefine

" Functions
syn match cUserFunction "\<\h\w*\>\(\s\|\n\)*("me=e-1 contains=cType,cDelimiter,cDefine
syn match cUserFunctionPointer "(\s*\*\s*\h\w*\s*)\(\s\|\n\)*(" contains=cDelimiter,cOperator
hi def link cUserFunction cFunction
hi def link cUserFunctionPointer cFunction

" Delimiters
syn match cDelimiter    "[();\\]"
syn match cBraces display "[{}]"

" Links
hi def link cFunction Function
hi def link cIdentifier Identifier
hi def link cDelimiter Delimiter
hi def link cBraces Delimiter
hi def link cBoolean Boolean
hi def link cDefineRef Constant
