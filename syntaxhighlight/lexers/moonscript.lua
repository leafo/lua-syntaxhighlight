local lpeg = require('lpeg')
-- Copyright 2016-2020 Alejandro Baez (https://keybase.io/baez). See License.txt.
-- Moonscript LPeg lexer.

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, R, V = lpeg.P, lpeg.S, lpeg.R, lpeg.V

local lex = lexer.new('moonscript', {fold_by_indentation = true})

-- Whitespace.
local ws = token(lexer.WHITESPACE, lexer.space^1)
lex:add_rule('whitespace', ws)

-- table keys have higher precedence than keywords
local tbl_key = token('tbl_key', lexer.word * ':' + ':' * lexer.word )
lex:add_rule('tbl_key', tbl_key)
lex:add_style('tbl_key', lexer.STYLE_REGEX)

-- Keywords.
local keyword = token(lexer.KEYWORD, word_match[[
  -- Lua.
  and break do else elseif for if in local not or return then while
  -- Moonscript.
  continue class export extends from import super switch unless using when with
]])
lex:add_rule('keyword', keyword)

-- Error words.
local error_word = token(lexer.ERROR, word_match[[function end]])
lex:add_rule('error', error_word)

-- Self reference.
local self_ref = token('self_ref',
  '@@' * lexer.word^-1 + '@' * lexer.word^-1 + word_match[[self]])
lex:add_rule('self_ref', self_ref)
lex:add_style('self_ref', lexer.STYLE_LABEL)

-- Functions.
local func = token(lexer.FUNCTION, word_match[[
  assert collectgarbage dofile error getmetatable ipairs load loadfile next
  pairs pcall print rawequal rawget rawset require select setmetatable tonumber
  tostring type xpcall
  -- Added in 5.2.
  rawlen
]])
lex:add_rule('function', func)

-- Constants.
local constant = token(lexer.CONSTANT, word_match[[
  nil true false
  _G _VERSION
  -- Added in 5.2.
  _ENV
]])
lex:add_rule('constant', constant)

-- Libraries.
local library = token('library', word_match[[
  -- Coroutine.
  coroutine coroutine.create coroutine.resume coroutine.running coroutine.status
  coroutine.wrap coroutine.yield
  -- Coroutine added in 5.3.
  coroutine.isyieldable
  -- Module.
  package package.cpath package.loaded package.loadlib package.path
  package.preload
  -- Module added in 5.2.
  package.config package.searchers package.searchpath
  -- UTF-8 added in 5.3.
  utf8 utf8.char utf8.charpattern utf8.codepoint utf8.codes utf8.len utf8.offset
  -- String.
  string string.byte string.char string.dump string.find string.format
  string.gmatch string.gsub string.len string.lower string.match string.rep
  string.reverse string.sub string.upper
  -- String added in 5.3.
  string.pack string.packsize string.unpack
  -- Table.
  table table.concat table.insert table.remove table.sort
  -- Table added in 5.2.
  table.pack table.unpack
  -- Table added in 5.3.
  table.move
  -- Math.
  math math.abs math.acos math.asin math.atan math.ceil math.cos math.deg
  math.exp math.floor math.fmod math.huge math.log math.max math.min math.modf
  math.pi math.rad math.random math.randomseed math.sin math.sqrt math.tan
  -- Math added in 5.3.
  math.maxinteger math.mininteger math.tointeger math.type math.ult
  -- IO.
  io io.close io.flush io.input io.lines io.open io.output io.popen io.read
  io.stderr io.stdin io.stdout io.tmpfile io.type io.write
  -- OS.
  os os.clock os.date os.difftime os.execute os.exit os.getenv os.remove
  os.rename os.setlocale os.time os.tmpname
  -- Debug.
  debug debug.debug debug.gethook debug.getinfo debug.getlocal
  debug.getmetatable debug.getregistry debug.getupvalue debug.sethook
  debug.setlocal debug.setmetatable debug.setupvalue debug.traceback
  -- Debug added in 5.2.
  debug.getuservalue debug.setuservalue debug.upvalueid debug.upvaluejoin
]])
lex:add_rule('library', library)
lex:add_style('library', lexer.STYLE_TYPE)

-- Identifiers.
local identifier = token(lexer.IDENTIFIER, lexer.word)
local proper_ident = token('proper_ident', R('AZ') * lexer.word)
lex:add_rule('identifier', proper_ident + identifier)
lex:add_style('proper_ident', lexer.STYLE_CLASS)

local longstring = lpeg.Cmt('[' * lpeg.C(P('=')^0) * '[',
  function(input, index, eq)
    local _, e = input:find(']' .. eq .. ']', index, true)
    return (e or #input) + 1
  end)

local comment = token(lexer.COMMENT, '--' * longstring + lexer.to_eol('--'))
-- LuaJIT 64 bit integer literals take a LL or ULL suffix
local number = token(lexer.NUMBER, lexer.number * (S('uU')^-1 * S('lL') * S('lL'))^-1)
local fndef = token('fndef', P('->') + '=>')
local operator = token(lexer.OPERATOR, S('+-*!\\/%^#=<>;:,.~|&'))

-- braces are separate tokens so an interpolation can find its closing brace
local paren = token('symbol', S('()[]'))
local brace_open = token('symbol', '{')
local brace_close = token('symbol', '}')

-- Strings. A double quoted string can interpolate any expression with #{},
-- including other strings, so it needs a recursive grammar that reuses the
-- token patterns above for the embedded code
local sq_str = token(lexer.STRING, lexer.range("'"))
local long_str = token('longstring', longstring)
local dq_char = '\\' * P(1) + (1 - S('"\\#')) + '#' * -P('{')

local dq_str = P{
  'dq_str',
  dq_str = token(lexer.STRING, '"') *
    (V('interpolation') + token(lexer.STRING, dq_char^1))^0 *
    token(lexer.STRING, P('"')^-1),
  interpolation = token('interpolation', '#{') * V('code')^0 *
    token('interpolation', '}')^-1,
  braces = brace_open * V('code')^0 * brace_close^-1,
  code = ws + tbl_key + keyword + error_word + self_ref + func + constant +
    library + proper_ident + identifier + sq_str + V('dq_str') + long_str +
    comment + number + fndef + operator + paren + V('braces'),
}

lex:add_rule('string', sq_str + dq_str + long_str)
lex:add_style('longstring', lexer.STYLE_STRING)
lex:add_style('interpolation', lexer.STYLE_EMBEDDED)

-- Comments.
lex:add_rule('comment', comment)

-- Numbers.
lex:add_rule('number', number)

-- Function definition.
lex:add_rule('fndef', fndef)
lex:add_style('fndef', lexer.STYLE_PREPROCESSOR)

-- Operators.
lex:add_rule('operator', operator)
lex:add_rule('symbol', paren + brace_open + brace_close)
lex:add_style('symbol', lexer.STYLE_EMBEDDED)

return lex
