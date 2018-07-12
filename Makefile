build:
	dune build

test:
	dune runtest

clean:
	rm -rf _build

.PHONY: build test clean
