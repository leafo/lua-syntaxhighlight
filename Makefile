
.PHONY: local vendor

vendor: 
	-rm -r tmp
	mkdir tmp
	cd tmp; curl -O https://foicica.com/textadept/download/textadept_NIGHTLY.x86_64.tgz
	cd tmp; tar xzf textadept_NIGHTLY.x86_64.tgz
	mkdir -p syntaxhighlight/textadept
	cp tmp/textadept_NIGHTLY*/lexers/*.lua syntaxhighlight/textadept
	sed -i -e "s/require('lexer')/require('syntaxhighlight.textadept.lexer')/" syntaxhighlight/textadept/*.lua
	sed -i -e "1ilocal lpeg = require('lpeg')" $$(find syntaxhighlight/textadept/*.lua | grep -v '/lexer.lua')
	cp tmp/textadept_NIGHTLY*/LICENSE syntaxhighlight/textadept

local: build
	luarocks make --lua-version=5.1 --local syntaxhighlight-dev-1.rockspec

build:
	moonc syntaxhighlight
