
# syntaxhighlight

![test](https://github.com/leafo/lua-syntaxhighlight/workflows/test/badge.svg)

Highlights code into HTML using lexers from [Textadept](https://foicica.com/textadept/).


```lua
local sh = require("syntaxhighlight")

local html = sh.highlight_to_html("lua", [[

local function hello_world(times)
  for i=1,times do
    print("hello world")
  end
end

]])

print(html)
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

### `highlight_to_html(language_name, code, opts={})`

Highlights code using the lexer for `language_name`. All input code is HTML escaped and is safe to embed directly into a page.

Options:

* `class_prefix` -- default `sh_`: Prefix put in front of every class name generated for each element
* `bare` -- default `false`: Set to `true` to not return the code wrapped in a `pre` tag


## License

### Files located in `syntaxhighlight/textadept/`

*See respective authors on top of each file*

The MIT License

Copyright (c) 2007-2019 Mitchell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

### Everything else

The MIT License

Copyright (c) 2020 Leaf Corcoran

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

