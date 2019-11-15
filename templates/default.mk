build:
	dune build

test:
	dune runtest

install:
	dune install

clean:
	rm -rf _build

.PHONY: build test clean install
