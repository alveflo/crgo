.PHONY: build

build:
	nim c -d:ssl ./src/crgo.nim

run: build
	./src/crgo.out add serde version 1.0 features "foo, bar"
