
unpack = unpack or table.unpack

lexer_search_path = do
  parts = for part in package.path\gmatch '[^;]+'
    -- no lexers use the init syntax
    unless part\match "%?%.lua$"
      continue

    part\gsub "%?%.lua", "syntaxhighlight/textadept/?.lua"

  table.concat parts, ";"

-- this is adapted from the lexer module
searchpath = (name, path) ->
  tried = {}
  for part in path\gmatch "[^;]+"
    filename = part\gsub "%?", name

    if loadfile filename
      return filename

    tried[#tried + 1] = string.format "no file '%s'", filename

  nil, table.concat tried, "\n"

local lexer_mod

load_lexer = ->
  return if lexer_mod
  lexer_mod = require "syntaxhighlight.textadept.lexer"

  -- initialize the package path like lexer would do, but using our custom path
  lexer_mod.property = {
    "lexer.lpeg.home": lexer_search_path\gsub "/%?%.lua", ""
  }

  lexer_mod.property_int = setmetatable {}, {
    __index: (k) => tonumber(lexer_mod.property[k]) or 0
    __newindex: => error "read-only property"
  }

lexers = setmetatable {}, {
  __index: (name) =>
    unless lexer_mod
      load_lexer!

    -- see if the module exists
    -- package.searchpath is defined in lexer.lua for lua 5.1
    source_path = searchpath name, lexer_search_path

    mod = if source_path
      require("syntaxhighlight.textadept.#{name}")
    else
      false

    @[name] = mod
    @[name]
}

tag_tokens = (source, tokens) ->
  position = 1
  local current_type

  return for token in *tokens
    switch type token
      when "number"
        chunk = source\sub position, token - 1
        position = token
        {
          (assert current_type, "got position without type")
          chunk
        }
      when "string"
        current_type = token
        continue
      else
        error "unknown token type: #{type token}"

parse_extra_styles = (s) ->
  [t for t in s\gmatch "%$%(style%.([^)]+)%)"]

classes_for_chunk_type = (lex, chunk_type, alias_cache) ->
  if out = alias_cache and alias_cache[chunk_type]
    return out
  
  out = if lex._EXTRASTYLES and lex._EXTRASTYLES[chunk_type]
    other_tags = parse_extra_styles lex._EXTRASTYLES[chunk_type]
    { chunk_type, unpack other_tags }
  else
    { chunk_type }

  if alias_cache
    alias_cache[chunk_type] = out

  out

merge_adjacent = (tuples) ->
  out = {}
  for t in *tuples
    last = out[#out]
    if last and last[1] == t[1]
      out[#out] = {
        last[1]
        last[2] .. t[2]
      }
    else
      table.insert out, t

  out


highlight_to_html = (language, code, opts={}) ->
  lex = lexers[language]

  class_prefix = opts.class_prefix or "sh_"

  unless lex
    return nil, "failed to find lexer for #{language}"

  tokens, err = lex\lex code
  unless tokens
    return nil, err

  cache = {}

  tagged_tokens = merge_adjacent tag_tokens code, tokens

  import escape_text from require "web_sanitize.html"

  buffer = {}

  unless opts.bare
    table.insert buffer, '<pre class="'
    table.insert buffer, escape_text\match class_prefix
    table.insert buffer, 'highlight">'

  for {chunk_type, chunk} in *tagged_tokens
    if chunk_type == "whitespace"
      table.insert buffer, escape_text\match chunk
    else
      classes = classes_for_chunk_type lex, chunk_type, cache

      table.insert buffer, '<span class="'
      for idx, c in ipairs classes
        if idx > 1
          table.insert buffer, ' '
        table.insert buffer, escape_text\match class_prefix .. c

      table.insert buffer, '">'
      table.insert buffer, escape_text\match chunk
      table.insert buffer, '</span>'

  unless opts.bare
    table.insert buffer, '</pre>'

  table.concat buffer

{
  :lexers
  :highlight_to_html
}


