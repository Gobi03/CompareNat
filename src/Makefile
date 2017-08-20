OCAMLC = ocamlfind ocamlc
OCAMLDEP = ocamlfind ocamldep

OBJS = compareNat.cmi compareNat.cmo

.PHONY: all
all: compareNat.cma

compareNat.cma: ${OBJS}
	${OCAMLC} -a -o $@ ${filter %.cmo,$^}

.SUFFIXES: .ml .mli .cmi .cmo
%.cmi: %.mli
	${OCAMLC} $<
%.cmi: %.ml
	$(OCAMLC) -c $<
%.cmo: %.ml %.cmi
	$(OCAMLC) -c $<

.PHONY: clean
clean:
	${RM} *.cm[ioxat] *.cmti *.~
