
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


