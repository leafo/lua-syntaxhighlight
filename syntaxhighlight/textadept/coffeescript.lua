-- Copyright 2006-2019 Mitchell mitchell.att.foicica.com. See License.txt.
-- CoffeeScript LPeg lexer.

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S = lpeg.P, lpeg.S

local lex = lexer.new('coffeescript', {fold_by_indentation = true})

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
  all and bind break by case catch class const continue default delete do each
  else enum export extends false finally for function if import in instanceof is
  isnt let loop native new no not of off on or return super switch then this
  throw true try typeof unless until var void when while with yes
]]))

-- Fields: object properties and methods.
lex:add_rule('field', token(lexer.FUNCTION, '.' * (S('_$') + lexer.alpha) *
                                            (S('_$') + lexer.alnum)^0))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Strings.
local regex_str = #P('/') * lexer.last_char_includes('+-*%<>!=^&|?~:;,([{') *
                  lexer.delimited_range('/', true) * S('igm')^0
lex:add_rule('string', token(lexer.STRING, lexer.delimited_range("'") +
                                           lexer.delimited_range('"')) +
                       token(lexer.REGEX, regex_str))

-- Comments.
local block_comment = '###' * (lexer.any - '###')^0 * P('###')^-1
local line_comment = '#' * lexer.nonnewline_esc^0
lex:add_rule('comment', token(lexer.COMMENT, block_comment + line_comment))

-- Numbers.
lex:add_rule('number', token(lexer.NUMBER, lexer.float + lexer.integer))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('+-/*%<>!=^&|?~:;,.()[]{}')))

return lex
