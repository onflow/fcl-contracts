.PHONY: test
test:
	$(MAKE) test -C lib/go
	sh -c "cd tests && npm i && npm run test -- --runInBand --testTimeout=600000" || exit 255

.PHONY: ci
ci:
	$(MAKE) ci -C lib/go
	sh -c "cd tests && npm i && npm run test -- --runInBand --testTimeout=600000" || exit 255
