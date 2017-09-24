OCAMLC   = ocamlfind ocamlc
OCAMLDEP = ocamlfind ocamldep

INCLUDES = -I src
OBJS = src/natCalc.cmo src/compareNat.cmo

.PHONY: all
all: compareNat.cma

compareNat.cma: ${OBJS}
	${OCAMLC} -a -o $@ $^
	cp src/compareNat.cmi .

# Common rules
.SUFFIXES: .ml .mli .cmi .cmo
%.cmi: %.mli
	${OCAMLC} ${INCLUDES} $<
%.cmi: %.ml
	$(OCAMLC) ${INCLUDES} -c $<
%.cmo: %.ml %.cmi
	$(OCAMLC) ${INCLUDES} -c $<

# Clean up
.PHONY: clean
clean:
	${RM} `find -name "*.cm[ioxat]" -or -name "*.cmti"`

# Dependencies
.PHONY: depend
depend:
	$(OCAMLDEP) $(INCLUDES) `find -name "*.mli" -or -name "*.ml"` > .depend

include .depend
