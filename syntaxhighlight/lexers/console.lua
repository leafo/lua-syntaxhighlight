local lpeg = require('lpeg')
-- Shell session LPeg lexer. Lines starting with a $ prompt are highlighted as
-- bash, every other line is program output.

local lexer = require('syntaxhighlight.textadept.lexer')
local token = lexer.token
local P, S = lpeg.P, lpeg.S

local lex = lexer.new('console')

local ws = token(lexer.WHITESPACE, lexer.space^1)

-- a command ends at the end of its line unless the line ends with a \
-- continuation
local line_end = lpeg.Cmt(lpeg.Cp() * S(' \t')^0 * '\n',
  function(input, index, start)
    if input:sub(start - 1, start - 1) ~= '\\' then return index end
  end)

local bash = lexer.load('bash')
local prompt = token('prompt', lexer.starts_line(S(' \t')^0 * '$' * S(' \t')^0))
lex:embed(bash, prompt, token(lexer.WHITESPACE, line_end))
lex:add_style('prompt', lexer.STYLE_KEYWORD)

lex:add_rule('whitespace', ws)
lex:add_rule('output', token('output', lexer.nonnewline^1))
lex:add_style('output', lexer.STYLE_COMMENT)

return lex
