

describe "syntaxhighlight", ->
  it "highlights html", ->
    out = require("syntaxhighlight").highlight_html "moonscript", "print 'hello' for i=1,20"
    assert.same [[<pre class="sh_highlight"><span class="sh_function">print</span> <span class="sh_string">&#x27;hello&#x27;</span> <span class="sh_keyword">for</span> <span class="sh_identifier">i</span><span class="sh_operator">=</span><span class="sh_number">1</span><span class="sh_operator">,</span><span class="sh_number">20</span></pre>]], out


  it "handles invalid lexer", ->
    assert.same {
      nil
      "failed to find lexer for fartlang"
    }, {
      require("syntaxhighlight").highlight_html "fartlang", "print 'hello'"
    }
