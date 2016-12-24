ESLINT = node_modules/.bin/eslint --config node_modules/sanctuary-style/eslint-es3.json --env es3
MOCHA = node_modules/.bin/mocha --reporter dot --ui tdd
NPM = npm
REMEMBER_BOWER = node_modules/.bin/remember-bower
TRANSCRIBE = node_modules/.bin/transcribe
XYZ = node_modules/.bin/xyz --repo git@github.com:sanctuary-js/sanctuary-type-identifiers.git --script scripts/prepublish


.PHONY: all
all: LICENSE README.md

.PHONY: LICENSE
LICENSE:
	cp -- '$@' '$@.orig'
	sed 's/Copyright (c) .* Sanctuary/Copyright (c) $(shell git log --date=format:%Y --pretty=format:%ad | sort -r | head -n 1) Sanctuary/' '$@.orig' >'$@'
	rm -- '$@.orig'

README.md: index.js
	$(TRANSCRIBE) \
	  --heading-level 4 \
	  --url 'https://github.com/sanctuary-js/sanctuary-type-identifiers/blob/v$(VERSION)/{filename}#L{line}' \
	  -- $^ \
	| LC_ALL=C sed 's/<h4 name="\(.*\)#\(.*\)">\(.*\)\1#\2/<h4 name="\1.prototype.\2">\3\1#\2/' >'$@'


.PHONY: lint
lint:
	$(ESLINT) \
	  --global define \
	  --global module \
	  --global self \
	  -- index.js
	$(ESLINT) \
	  --env node \
	  --global suite \
	  --global test \
	  -- test/index.js
	$(REMEMBER_BOWER) $(shell pwd)


.PHONY: release-major release-minor release-patch
release-major release-minor release-patch:
	@$(XYZ) --increment $(@:release-%=%)


.PHONY: setup
setup:
	$(NPM) install


.PHONY: test
test:
	$(MOCHA) -- test/index.js