

describe "syntaxhighlight", ->
  it "highlights moonscript", ->
    out = require("syntaxhighlight").highlight_to_html "moonscript", "print 'hello' for i=1,20"
    assert.same [[<pre class="sh_highlight"><span class="sh_function">print</span><span class="sh_moonscript_whitespace sh_whitespace"> </span><span class="sh_string">&#x27;hello&#x27;</span><span class="sh_moonscript_whitespace sh_whitespace"> </span><span class="sh_keyword">for</span><span class="sh_moonscript_whitespace sh_whitespace"> </span><span class="sh_identifier">i</span><span class="sh_operator">=</span><span class="sh_number">1</span><span class="sh_operator">,</span><span class="sh_number">20</span></pre>]], out

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

    assert.same [[<pre class="sh_highlight"><span class="sh_moonscript_whitespace sh_whitespace">      </span><span class="sh_operator">&lt;!</span><span class="sh_proper_ident sh_class">DOCTYPE</span><span class="sh_moonscript_whitespace sh_whitespace"> </span><span class="sh_proper_ident sh_class">HTML</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
      </span><span class="sh_operator">&lt;</span><span class="sh_identifier">html</span><span class="sh_moonscript_whitespace sh_whitespace"> </span><span class="sh_identifier">lang</span><span class="sh_operator">=</span><span class="sh_string">&quot;en&quot;</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
      </span><span class="sh_operator">&lt;</span><span class="sh_identifier">head</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
        </span><span class="sh_operator">&lt;</span><span class="sh_identifier">meta</span><span class="sh_moonscript_whitespace sh_whitespace"> </span><span class="sh_identifier">charset</span><span class="sh_operator">=</span><span class="sh_string">&quot;UTF-8&quot;</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
        </span><span class="sh_operator">&lt;</span><span class="sh_identifier">title</span><span class="sh_operator">&gt;&lt;/</span><span class="sh_identifier">title</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
      </span><span class="sh_operator">&lt;/</span><span class="sh_identifier">head</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
      </span><span class="sh_operator">&lt;</span><span class="sh_identifier">body</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">

      </span><span class="sh_operator">&lt;/</span><span class="sh_identifier">body</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
      </span><span class="sh_operator">&lt;/</span><span class="sh_identifier">html</span><span class="sh_operator">&gt;</span><span class="sh_moonscript_whitespace sh_whitespace">
    </span></pre>]], out

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

    assert.same [[<pre class="sh_highlight"><span class="sh_html_whitespace sh_whitespace">      </span><span class="sh_doctype sh_comment">&lt;!DOCTYPE HTML&gt;</span><span class="sh_html_whitespace sh_whitespace">
      </span><span class="sh_element sh_keyword">&lt;html</span><span class="sh_html_whitespace sh_whitespace"> </span><span class="sh_attribute sh_type">lang</span><span class="sh_default">=</span><span class="sh_string">&quot;en&quot;</span><span class="sh_element sh_keyword">&gt;</span><span class="sh_html_whitespace sh_whitespace">

      </span><span class="sh_element sh_keyword">&lt;style</span><span class="sh_html_whitespace sh_whitespace"> </span><span class="sh_attribute sh_type">type</span><span class="sh_operator">=</span><span class="sh_string">&quot;text/css&quot;</span><span class="sh_element sh_keyword">&gt;</span><span class="sh_css_whitespace sh_whitespace">
        </span><span class="sh_identifier">body</span><span class="sh_css_whitespace sh_whitespace"> </span><span class="sh_operator">{</span><span class="sh_css_whitespace sh_whitespace">
          </span><span class="sh_property sh_keyword">color</span><span class="sh_operator">:</span><span class="sh_css_whitespace sh_whitespace"> </span><span class="sh_value sh_constant">blue</span><span class="sh_operator">;</span><span class="sh_css_whitespace sh_whitespace">
        </span><span class="sh_operator">}</span><span class="sh_css_whitespace sh_whitespace">
      </span><span class="sh_element sh_keyword">&lt;/style&gt;</span><span class="sh_html_whitespace sh_whitespace">
    </span></pre>]], out

  it "highlights yaml", ->
    out = assert require("syntaxhighlight").highlight_to_html "yaml", [[
name: test

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
]]

    assert.same [[<pre class="sh_highlight"><span class="sh_keyword">name</span><span class="sh_operator">:</span><span class="sh_yaml_whitespace sh_whitespace"> </span><span class="sh_literal sh_default">test</span><span class="sh_yaml_whitespace sh_whitespace">

</span><span class="sh_keyword">on</span><span class="sh_operator">:</span><span class="sh_yaml_whitespace sh_whitespace"> </span><span class="sh_operator">[</span><span class="sh_literal sh_default">push</span><span class="sh_operator">]</span><span class="sh_yaml_whitespace sh_whitespace">

</span><span class="sh_keyword">jobs</span><span class="sh_operator">:</span><span class="sh_yaml_whitespace sh_whitespace">
  </span><span class="sh_keyword">test</span><span class="sh_operator">:</span><span class="sh_yaml_whitespace sh_whitespace">
    </span><span class="sh_keyword">runs-on</span><span class="sh_operator">:</span><span class="sh_yaml_whitespace sh_whitespace"> </span><span class="sh_literal sh_default">ubuntu-latest</span><span class="sh_yaml_whitespace sh_whitespace">
</span></pre>]], out

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
