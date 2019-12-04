all: main.native

.PHONY: main.native
main.native:
	ocamlbuild main.native -use-menhir

.PHONY: clean
clean:
	ocamlbuild -clean
	rm -rf ./output