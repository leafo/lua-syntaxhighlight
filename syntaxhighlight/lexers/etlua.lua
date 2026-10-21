local lpeg = require('lpeg')
-- etlua template LPeg lexer, HTML with embedded Lua.
-- https://github.com/leafo/etlua

local lexer = require('syntaxhighlight.textadept.lexer')
local token = lexer.token
local P, S = lpeg.P, lpeg.S

local lex = lexer.new('etlua', {inherit = lexer.load('html')})

-- <% code %>, <%= escaped output %>, <%- raw output %>
local lua = lexer.load('lua')
local lua_start_rule = token('etlua_tag', '<%' * S('=-')^-1)
local lua_end_rule = token('etlua_tag', '%>')
lex:embed(lua, lua_start_rule, lua_end_rule)
lex:add_style('etlua_tag', lexer.STYLE_EMBEDDED)

lex:add_fold_point('etlua_tag', '<%', '%>')

return lex
