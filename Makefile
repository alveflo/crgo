.PHONY: build

build:
	nim c -d:ssl ./src/crgo.nim

run: build
	./src/crgo.out add test