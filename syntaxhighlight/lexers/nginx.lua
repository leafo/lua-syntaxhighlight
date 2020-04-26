local lpeg = require('lpeg')

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, R = lpeg.P, lpeg.S, lpeg.R

local lex = lexer.new('nginx')

local named_location = token("named_location", P"@" * lexer.word)
lex:add_rule("named_location", named_location)
lex:add_style("named_location", lexer.STYLE_PREPROCESSOR)

lex:add_rule('comment', token(lexer.COMMENT, lexer.to_eol('#')))

start_of_block = lexer.space^0 * P"{"
end_of_line = lexer.space^0 * P";"

lex:add_rule('location', token(lexer.KEYWORD, "location") * lexer.space^1 * (named_location + token(lexer.STRING, (1 - start_of_block)^1)))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
  http mail events server match types upstream charset_map limit_except if geo map split_clients
  on off
  set
]]))

-- https://github.com/chr4/nginx.vim/blob/master/syntax/nginx.vim
lex:add_rule('function', token(lexer.FUNCTION, word_match[[
  lua_use_default_type
  lua_malloc_trim
  lua_code_cache
  lua_regex_cache_max_entries
  lua_regex_match_limit
  lua_package_path
  lua_package_cpath
  init_by_lua
  init_by_lua_file
  init_worker_by_lua
  init_worker_by_lua_file
  set_by_lua
  set_by_lua_file
  content_by_lua
  content_by_lua_file
  rewrite_by_lua
  rewrite_by_lua_file
  access_by_lua
  access_by_lua_file
  header_filter_by_lua
  header_filter_by_lua_file
  body_filter_by_lua
  body_filter_by_lua_file
  log_by_lua
  log_by_lua_file
  balancer_by_lua_file
  lua_need_request_body
  ssl_certificate_by_lua_file
  ssl_session_fetch_by_lua_file
  ssl_session_store_by_lua_file
  lua_shared_dict
  lua_socket_connect_timeout
  lua_socket_send_timeout
  lua_socket_send_lowat
  lua_socket_read_timeout
  lua_socket_buffer_size
  lua_socket_pool_size
  lua_socket_keepalive_timeout
  lua_socket_log_errors
  lua_ssl_ciphers
  lua_ssl_crl
  lua_ssl_protocols
  lua_ssl_trusted_certificate
  lua_ssl_verify_depth
  lua_http10_buffering
  rewrite_by_lua_no_postpone
  access_by_lua_no_postpone
  lua_transform_underscores_in_response_headers
  lua_check_client_abort
  lua_max_pending_timers
  lua_max_running_timers
]]))


lex:add_rule('library_arg', token(lexer.FUNCTION, word_match[[
  alias
  include
  pid
]]) * lexer.space^1 * token(lexer.STRING, (1 - end_of_line)^1))


-- Libraries and deprecated libraries.
lex:add_rule('library', token(lexer.FUNCTION, word_match[[
  worker_connections
  listen
  default_type
  lua_code_cache
  content_by_lua
  content_by_lua_block
  worker_processes
  error_log
  daemon
  deny allow
  server_name
  access_log
  gzip
  gzip_proxied
  add_header
  ssi
  root
  try_files
  set_md5

  proxy_set_header
  proxy_pass
  proxy_cache_path
  proxy_cache
  proxy_cache_valid
  proxy_cache_use_stale
  proxy_cache_lock
  proxy_cache_bypass
]]))

lex:add_style('library', lexer.STYLE_TYPE)

lex:add_rule('variable', token(lexer.VARIABLE, '$' * (1 - lexer.space)^1))
lex:add_style('variable', lexer.STYLE_LABEL)

local sq_str = lexer.range("'")
local dq_str = lexer.range('"')
lex:add_rule('string', token(lexer.STRING, sq_str + dq_str))

lex:add_rule('number', token(lexer.NUMBER, lexer.float + lexer.integer))

return lex
