

describe "syntaxhighlight", ->
  it "highlights moonscript", ->
    out = require("syntaxhighlight").highlight_to_html "moonscript", "print 'hello' for i=1,20"
    assert.same [[<pre class="sh_highlight"><span class="sh_function">print</span> <span class="sh_string">&#x27;hello&#x27;</span> <span class="sh_keyword">for</span> <span class="sh_identifier">i</span><span class="sh_operator">=</span><span class="sh_number">1</span><span class="sh_operator">,</span><span class="sh_number">20</span></pre>]], out

  it "highlights html", ->
    out = require("syntaxhighlight").highlight_to_html "moonscript", [[
      <!DOCTYPE HTML>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title></title>
      </head>
      <body>

      </body>
      </html>
    ]]

    assert.same [[<pre class="sh_highlight">      <span class="sh_operator">&lt;!</span><span class="sh_proper_ident sh_class">DOCTYPE</span> <span class="sh_proper_ident sh_class">HTML</span><span class="sh_operator">&gt;</span>
      <span class="sh_operator">&lt;</span><span class="sh_identifier">html</span> <span class="sh_identifier">lang</span><span class="sh_operator">=</span><span class="sh_string">&quot;en&quot;</span><span class="sh_operator">&gt;</span>
      <span class="sh_operator">&lt;</span><span class="sh_identifier">head</span><span class="sh_operator">&gt;</span>
        <span class="sh_operator">&lt;</span><span class="sh_identifier">meta</span> <span class="sh_identifier">charset</span><span class="sh_operator">=</span><span class="sh_string">&quot;UTF-8&quot;</span><span class="sh_operator">&gt;</span>
        <span class="sh_operator">&lt;</span><span class="sh_identifier">title</span><span class="sh_operator">&gt;&lt;/</span><span class="sh_identifier">title</span><span class="sh_operator">&gt;</span>
      <span class="sh_operator">&lt;/</span><span class="sh_identifier">head</span><span class="sh_operator">&gt;</span>
      <span class="sh_operator">&lt;</span><span class="sh_identifier">body</span><span class="sh_operator">&gt;</span>

      <span class="sh_operator">&lt;/</span><span class="sh_identifier">body</span><span class="sh_operator">&gt;</span>
      <span class="sh_operator">&lt;/</span><span class="sh_identifier">html</span><span class="sh_operator">&gt;</span>
    </pre>]], out

  it "highlights moonscript with custom changes", ->
    out = assert require("syntaxhighlight").highlight_to_html "moonscript", [[{for: @}]]
    assert.same [[<pre class="sh_highlight"><span class="sh_symbol sh_embedded">{</span><span class="sh_tbl_key sh_regex">for:</span> <span class="sh_self_ref sh_label">@</span><span class="sh_symbol sh_embedded">}</span></pre>]], out

  it "highlights html with css", ->
    out = assert require("syntaxhighlight").highlight_to_html "html", [[
      <!DOCTYPE HTML>
      <html lang="en">

      <style type="text/css">
        body {
          color: blue;
        }
      </style>
    ]]

    assert.same [[<pre class="sh_highlight">      <span class="sh_doctype sh_comment">&lt;!DOCTYPE HTML&gt;</span>
      <span class="sh_element sh_keyword">&lt;html</span> <span class="sh_attribute sh_type">lang</span><span class="sh_default">=</span><span class="sh_string">&quot;en&quot;</span><span class="sh_element sh_keyword">&gt;</span>

      <span class="sh_element sh_keyword">&lt;style</span> <span class="sh_attribute sh_type">type</span><span class="sh_operator">=</span><span class="sh_string">&quot;text/css&quot;</span><span class="sh_element sh_keyword">&gt;</span>
        <span class="sh_identifier">body</span> <span class="sh_operator">{</span>
          <span class="sh_property sh_keyword">color</span><span class="sh_operator">:</span> <span class="sh_value sh_constant">blue</span><span class="sh_operator">;</span>
        <span class="sh_operator">}</span>
      <span class="sh_element sh_keyword">&lt;/style&gt;</span>
    </pre>]], out

  it "highlights yaml", ->
    out = assert require("syntaxhighlight").highlight_to_html "yaml", [[
name: test

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
]]

    assert.same [[<pre class="sh_highlight"><span class="sh_keyword">name</span><span class="sh_operator">:</span> <span class="sh_literal sh_default">test</span>

<span class="sh_keyword">on</span><span class="sh_operator">:</span> <span class="sh_operator">[</span><span class="sh_literal sh_default">push</span><span class="sh_operator">]</span>

<span class="sh_keyword">jobs</span><span class="sh_operator">:</span>
  <span class="sh_keyword">test</span><span class="sh_operator">:</span>
    <span class="sh_keyword">runs-on</span><span class="sh_operator">:</span> <span class="sh_literal sh_default">ubuntu-latest</span>
</pre>]], out

  it "highlights nginx (a lexer only provided in this library)", ->
    out = require("syntaxhighlight").highlight_to_html "nginx", [[location /home { return 404; }]], bare: true
    assert.same [[<span class="sh_keyword">location</span><span class="sh_string"> /home</span><span class="sh_default"> { return </span><span class="sh_number">404</span><span class="sh_default">; }</span>]], out

  it "highlights vim", ->
    out = require("syntaxhighlight").highlight_to_html "nginx", [["hello"]], bare: true
    assert.same [[<span class="sh_string">&quot;hello&quot;</span>]], out

  it "highlights bare: true", ->
    out = require("syntaxhighlight").highlight_to_html "lua", [[print('hi')]], bare: true
    assert.same [[<span class="sh_function">print</span><span class="sh_operator">(</span><span class="sh_string">&#x27;hi&#x27;</span><span class="sh_operator">)</span>]], out

  it "highlights bare: true", ->
    out = require("syntaxhighlight").highlight_to_html "lua", [[print('hi')]], bare: true
    assert.same [[<span class="sh_function">print</span><span class="sh_operator">(</span><span class="sh_string">&#x27;hi&#x27;</span><span class="sh_operator">)</span>]], out

  it "highlights css_prefix: cool-", ->
    out = require("syntaxhighlight").highlight_to_html "lua", [[print('hi')]], class_prefix: "cool-"
    assert.same [[<pre class="cool-highlight"><span class="cool-function">print</span><span class="cool-operator">(</span><span class="cool-string">&#x27;hi&#x27;</span><span class="cool-operator">)</span></pre>]], out

  it "handles invalid lexer", ->
    assert.same {
      nil
      "failed to find lexer for fartlang"
    }, {
      require("syntaxhighlight").highlight_to_html "fartlang", "print 'hello'"
    }

describe "moonscript lexer", ->
  highlight = (code) ->
    require("syntaxhighlight").highlight_to_html "moonscript", code, bare: true

  it "highlights string interpolation", ->
    assert.same [[<span class="sh_function">print</span> <span class="sh_string">&quot;a </span><span class="sh_interpolation sh_embedded">#{</span><span class="sh_identifier">b</span><span class="sh_interpolation sh_embedded">}</span><span class="sh_string"> c&quot;</span>]],
      highlight [[print "a #{b} c"]]

  it "highlights nested string interpolation", ->
    assert.same [[<span class="sh_identifier">x</span> <span class="sh_operator">=</span> <span class="sh_string">&quot;</span><span class="sh_interpolation sh_embedded">#{</span><span class="sh_string">&quot;in </span><span class="sh_interpolation sh_embedded">#{</span><span class="sh_number">1</span><span class="sh_interpolation sh_embedded">}</span><span class="sh_string">&quot;</span><span class="sh_interpolation sh_embedded">}</span><span class="sh_string">&quot;</span> <span class="sh_operator">..</span> <span class="sh_identifier">y</span>]],
      highlight [[x = "#{"in #{1}"}" .. y]]

  it "matches braces inside of string interpolation", ->
    assert.same [[<span class="sh_identifier">x</span> <span class="sh_operator">=</span> <span class="sh_string">&quot;</span><span class="sh_interpolation sh_embedded">#{</span> <span class="sh_symbol sh_embedded">{</span><span class="sh_tbl_key sh_regex">a:</span> <span class="sh_string">&quot;}&quot;</span><span class="sh_symbol sh_embedded">}</span><span class="sh_operator">.</span><span class="sh_identifier">a</span> <span class="sh_interpolation sh_embedded">}</span><span class="sh_string">&quot;</span> <span class="sh_operator">..</span> <span class="sh_identifier">y</span>]],
      highlight [[x = "#{ {a: "}"}.a }" .. y]]

  it "only interpolates double quoted strings", ->
    assert.same [=[<span class="sh_identifier">x</span> <span class="sh_operator">=</span> <span class="sh_string">&#x27;no #{interp}&#x27;</span> <span class="sh_operator">..</span> <span class="sh_longstring sh_string">[[or #{here}]]</span> <span class="sh_operator">..</span> <span class="sh_string">&quot;#not {either}&quot;</span>]=],
      highlight [=[x = 'no #{interp}' .. [[or #{here}]] .. "#not {either}"]=]

  it "highlights self references", ->
    assert.same [[<span class="sh_identifier">selfish</span> <span class="sh_operator">=</span> <span class="sh_self_ref sh_label">self</span> <span class="sh_self_ref sh_label">@@count</span> <span class="sh_self_ref sh_label">@x</span>]],
      highlight [[selfish = self @@count @x]]

  it "highlights bitwise operators", ->
    assert.same [[<span class="sh_identifier">x</span> <span class="sh_operator">=</span> <span class="sh_identifier">a</span> <span class="sh_operator">~=</span> <span class="sh_identifier">b</span> <span class="sh_operator">|</span> <span class="sh_identifier">c</span> <span class="sh_operator">&amp;</span> <span class="sh_operator">~</span><span class="sh_identifier">d</span>]],
      highlight [[x = a ~= b | c & ~d]]

  it "highlights nil and booleans as constants", ->
    assert.same [[<span class="sh_identifier">x</span> <span class="sh_operator">=</span> <span class="sh_constant">nil</span> <span class="sh_keyword">or</span> <span class="sh_constant">true</span> <span class="sh_keyword">and</span> <span class="sh_constant">false</span>]],
      highlight [[x = nil or true and false]]

  it "doesn't treat moon module functions as library names", ->
    assert.same [[<span class="sh_identifier">p</span> <span class="sh_operator">=</span> <span class="sh_identifier">copy</span> <span class="sh_number">10LL</span>]],
      highlight [[p = copy 10LL]]
