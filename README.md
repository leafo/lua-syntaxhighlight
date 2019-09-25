
# syntaxhighlight

Highlights code into HTML using lexers from [Textadept](https://foicica.com/textadept/)


```lua
local sh = require("syntaxhighlight")

local html = sh.highlight_html("lua", [[

local function hello_world(times)
  for i=1,times do
    print("hello world")
  end
end

]])

print html
```


Output:


```html
<pre class="sh_highlight"><span class="sh_keyword">local</span> <span class="sh_keyword">function</span> <span class="sh_identifier">hello_world</span><span class="sh_operator">(</span><span class="sh_identifier">times</span><span class="sh_operator">)</span>
  <span class="sh_keyword">for</span> <span class="sh_identifier">i</span><span class="sh_operator">=</span><span class="sh_number">1</span><span class="sh_operator">,</span><span class="sh_identifier">times</span> <span class="sh_keyword">do</span>
    <span class="sh_function">print</span><span class="sh_operator">(</span><span class="sh_string">&quot;hello world&quot;</span><span class="sh_operator">)</span>
  <span class="sh_keyword">end</span>
<span class="sh_keyword">end</span>
</pre>
```

## Interface

### `highlight_html(language_name, code, opts={})`

Highlights code using the lexer for `language_name`. All input code is HTML escaped and is safe to embed directly into a page.

Options:

* `class_prefix` -- default `sh_`: Prefix put in front of every class name generated for each element
* `bare` -- default `false`: Set to `true` to not return the code wrapped in a `pre` tag

