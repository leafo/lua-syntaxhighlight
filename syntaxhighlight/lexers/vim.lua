local lpeg = require('lpeg')

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, R = lpeg.P, lpeg.S, lpeg.R

local lex = lexer.new('vim')

lex:add_rule("fndef", token(lexer.KEYWORD, P"function" * P"!"^-1) * lexer.space^1 * token("fndef", (lexer.alnum + S('_'))^1))

lex:add_style("fndef", lexer.STYLE_PREPROCESSOR)

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
function endfunction
if endif
return
let
]]))

lex:add_rule('function', token(lexer.FUNCTION, word_match[[
empty chomp split len strlen join tolower toupper system substitute has
execute command echo map noremap imap
]]))


lex:add_rule("variable", token("variable", S("bwtglsav") * ":" * (lexer.alnum + S('_'))^1))
lex:add_style('variable', lexer.STYLE_LABEL)


lex:add_rule("command", token("command", P":" * (lexer.alnum + S('_'))^1))
lex:add_style("command", lexer.STYLE_KEYWORD)

local word = lexer.alpha * (lexer.alnum + S('_-'))^0
lex:add_rule('key', token("key", "<" * word * ">"))
lex:add_style('key', lexer.STYLE_OPERATOR)

local sq_str = lexer.range("'")

-- can't use range because range doesn't require ending delimiter
local dq_str = '"' * ([[\"]] + lexer.nonnewline - '"')^0 * '"'

lex:add_rule('string', token(lexer.STRING, sq_str + dq_str))
lex:add_rule('number', token(lexer.NUMBER, lexer.float + lexer.integer))
lex:add_rule('comment', token(lexer.COMMENT, lexer.to_eol('"')))

return lex
