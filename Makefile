
.PHONY: local vendor

vendor: 
	-rm -r tmp
	mkdir tmp
	cd tmp; curl -L -O https://github.com/orbitalquark/scintillua/releases/download/scintillua_5.3/scintillua_5.3.zip
	cd tmp; unzip scintillua_5.3.zip
	mkdir -p syntaxhighlight/textadept
	cp tmp/scintillua_5.3*/lexers/*.lua syntaxhighlight/textadept
	sed -i -e "s/require('lexer')/require('syntaxhighlight.textadept.lexer')/" syntaxhighlight/textadept/*.lua
	sed -i -e "1ilocal lpeg = require('lpeg')" $$(find syntaxhighlight/textadept/*.lua | grep -v '/lexer.lua')
	cp tmp/scintillua_5.3*/LICENSE syntaxhighlight/textadept

local: build
	luarocks make --lua-version=5.1 --local syntaxhighlight-dev-1.rockspec

build:
	moonc syntaxhighlight
