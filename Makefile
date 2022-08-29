.PHONY: test
test:
	$(MAKE) test -C lib/go
	cd tests && npm i && npm run test

.PHONY: ci
ci:
	$(MAKE) ci -C lib/go
	cd tests && npm i && npm run test
