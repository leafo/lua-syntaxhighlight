local lpeg = require('lpeg')

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, V = lpeg.P, lpeg.S, lpeg.V

local lex = lexer.new('nginx')

-- created before loading the lua lexer, which changes lexer.WHITESPACE
local ws = token(lexer.WHITESPACE, lexer.space^1)

-- Lua code embedded in *_by_lua_block directives and lapis config template
-- tags. Braces are matched so a table's closing brace doesn't end the block
local lua_token = lexer.load('lua'):join_tokens()
local lua_code = P{
  'code',
  code = (V('braces') + -S('{}') * lua_token)^0,
  braces = token(lexer.OPERATOR, '{') * V('code') * token(lexer.OPERATOR, '}')^-1,
}

-- the first word of a statement names the directive, > is the end of a
-- template tag
local directive_start = lexer.last_char_includes('{};>')

lex:add_rule('whitespace', ws)
lex:add_rule('comment', token(lexer.COMMENT, lexer.to_eol('#')))

local lua_block_name = lpeg.Cmt(lexer.word, function(input, index, word)
  if word:match('_by_lua_block$') then return index end
end)

lex:add_rule('lua_block', directive_start * token(lexer.FUNCTION, lua_block_name) *
  ws^-1 * token(lexer.OPERATOR, '{') * lua_code * token(lexer.OPERATOR, '}')^-1)

lex:add_rule('template_tag', token('template_tag', '<%' * S('=-')^-1) *
  (-P('%>') * lua_token)^0 * token('template_tag', '%>')^-1)
lex:add_style('template_tag', lexer.STYLE_EMBEDDED)

local named_location = token('named_location', '@' * lexer.word)
lex:add_style('named_location', lexer.STYLE_PREPROCESSOR)

-- the path or pattern of a location is everything up to the opening brace
lex:add_rule('location', directive_start * token(lexer.KEYWORD, 'location') * ws *
  (named_location + token(lexer.STRING, (1 - lexer.space^0 * '{')^1)))

lex:add_rule('block', directive_start * token(lexer.KEYWORD, word_match[[
  http mail stream events server match types upstream charset_map limit_except
  if geo map split_clients
]]))

lex:add_rule('directive', directive_start * token(lexer.FUNCTION, lexer.word))

lex:add_rule('named_location', named_location)

-- $var, $1 regex captures, ${var}, and ${{var}} from lapis config templates
lex:add_rule('variable', token(lexer.VARIABLE, '$' *
  ('{{' * (1 - P('}}'))^0 * '}}' + '{' * lexer.word * '}' + (lexer.alnum + '_')^1)))
lex:add_style('variable', lexer.STYLE_LABEL)

local sq_str = lexer.range("'")
local dq_str = lexer.range('"')
lex:add_rule('string', token(lexer.STRING, sq_str + dq_str))

lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[on off]]))

-- sizes and times can have a unit suffix, eg. 10m or 30s
lex:add_rule('number', token(lexer.NUMBER, lexer.digit^1 * ('.' * lexer.digit^1)^-1 *
  S('kKmMgGsShdwy')^-1 * -(lexer.alnum + S('._/:'))))

lex:add_rule('operator', token(lexer.OPERATOR, S('{};()=~!')))

-- any other argument: paths, hosts, file names
lex:add_rule('value', token(lexer.IDENTIFIER, (1 - lexer.space - S(';{}#"\'$()'))^1))

return lex
