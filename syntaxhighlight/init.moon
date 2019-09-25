local lexer_mod
 
lexers = setmetatable {}, {
  __index: (name) =>
    prev_mod = package.loaded.lexer
    unless lexer_mod
      lexer_mod = require "syntaxhighlight.textadept.lexer"

    package.loaded.lexer = lexer_mod
    success, mod = pcall ->
      require("syntaxhighlight.textadept.#{name}")
    package.loaded.lexer = prev_mod

    if success
      @[name] = mod
      @[name]
    else
      @[name] = false
      false
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


highlight_html = (language, code, opts={}) ->
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
    table.insert buffer, '<pre class="sh_highlight">'

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
  :highlight_html
}


