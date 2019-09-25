local lexer_mod
local lexers = setmetatable({ }, {
  __index = function(self, name)
    local prev_mod = package.loaded.lexer
    if not (lexer_mod) then
      lexer_mod = require("syntaxhighlight.textadept.lexer")
    end
    package.loaded.lexer = lexer_mod
    local success, mod = pcall(function()
      return require("syntaxhighlight.textadept." .. tostring(name))
    end)
    package.loaded.lexer = prev_mod
    self[name] = mod or false
    return self[name]
  end
})
local tag_tokens
tag_tokens = function(source, tokens)
  local position = 1
  local current_type
  return (function()
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #tokens do
      local _continue_0 = false
      repeat
        local token = tokens[_index_0]
        local _exp_0 = type(token)
        if "number" == _exp_0 then
          local chunk = source:sub(position, token - 1)
          position = token
          _accum_0[_len_0] = {
            (assert(current_type, "got position without type")),
            chunk
          }
        elseif "string" == _exp_0 then
          current_type = token
          _continue_0 = true
          break
        else
          _accum_0[_len_0] = error("unknown token type: " .. tostring(type(token)))
        end
        _len_0 = _len_0 + 1
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    return _accum_0
  end)()
end
local parse_extra_styles
parse_extra_styles = function(s)
  local _accum_0 = { }
  local _len_0 = 1
  for t in s:gmatch("%$%(style%.([^)]+)%)") do
    _accum_0[_len_0] = t
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local classes_for_chunk_type
classes_for_chunk_type = function(lex, chunk_type, alias_cache)
  do
    local out = alias_cache and alias_cache[chunk_type]
    if out then
      return out
    end
  end
  local out
  if lex._EXTRASTYLES and lex._EXTRASTYLES[chunk_type] then
    local other_tags = parse_extra_styles(lex._EXTRASTYLES[chunk_type])
    out = {
      chunk_type,
      unpack(other_tags)
    }
  else
    out = {
      chunk_type
    }
  end
  if alias_cache then
    alias_cache[chunk_type] = out
  end
  return out
end
local merge_adjacent
merge_adjacent = function(tuples)
  local out = { }
  for _index_0 = 1, #tuples do
    local t = tuples[_index_0]
    local last = out[#out]
    if last and last[1] == t[1] then
      out[#out] = {
        last[1],
        last[2] .. t[2]
      }
    else
      table.insert(out, t)
    end
  end
  return out
end
local highlight_html
highlight_html = function(language, code, opts)
  if opts == nil then
    opts = { }
  end
  local lex = lexers[language]
  local class_prefix = opts.class_prefix or "sh_"
  if not (lex) then
    return nil, "failed to find lexer for " .. tostring(language)
  end
  local tokens, err = lex:lex(code)
  if not (tokens) then
    return nil, err
  end
  local cache = { }
  local tagged_tokens = merge_adjacent(tag_tokens(code, tokens))
  local escape_text
  escape_text = require("web_sanitize.html").escape_text
  local buffer = { }
  if not (opts.bare) then
    table.insert(buffer, '<pre class="sh_highlight">')
  end
  for _index_0 = 1, #tagged_tokens do
    local _des_0 = tagged_tokens[_index_0]
    local chunk_type, chunk
    chunk_type, chunk = _des_0[1], _des_0[2]
    if chunk_type == "whitespace" then
      table.insert(buffer, escape_text:match(chunk))
    else
      local classes = classes_for_chunk_type(lex, chunk_type, cache)
      table.insert(buffer, '<span class="')
      for idx, c in ipairs(classes) do
        if idx > 1 then
          table.insert(buffer, ' ')
        end
        table.insert(buffer, escape_text:match(class_prefix .. c))
      end
      table.insert(buffer, '">')
      table.insert(buffer, escape_text:match(chunk))
      table.insert(buffer, '</span>')
    end
  end
  if not (opts.bare) then
    table.insert(buffer, '</pre>')
  end
  return table.concat(buffer)
end
return {
  lexers = lexers,
  highlight_html = highlight_html
}
