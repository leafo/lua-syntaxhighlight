
vendor: 
	-rm -r tmp
	mkdir tmp
	cd tmp; curl -O https://foicica.com/textadept/download/textadept_NIGHTLY.x86_64.tgz
	cd tmp; tar xzf textadept_NIGHTLY.x86_64.tgz
	mkdir -p syntaxhighlight/textadept
	cp tmp/textadept_NIGHTLY*/lexers/*.lua syntaxhighlight/textadept
	cp tmp/textadept_NIGHTLY*/LICENSE syntaxhighlight/textadept
