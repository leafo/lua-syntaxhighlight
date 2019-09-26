local lpeg = require('lpeg')

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, R = lpeg.P, lpeg.S, lpeg.R

local lex = lexer.new('nginx')

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
	location server events
	on off
]]))


-- Libraries and deprecated libraries.
local library = token('library', word_match[[
	worker_connections
	include
	listen
	lua_code_cache
	alias
	content_by_lua
	worker_processes
	error_log
	daemon
	pid
]])

lex:add_rule('library', library)
lex:add_style('library', lexer.STYLE_TYPE)

lex:add_rule('variable', token(lexer.VARIABLE, '$' * (1 - lexer.space)^1))

return lex
