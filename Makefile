OCAMLC   = ocamlfind ocamlc
OCAMLDEP = ocamlfind ocamldep

INCLUDES = -I src
OBJS =  natCalc.cmi natCalc.cmo \
		compareNat.cmi compareNat.cmo

.PHONY: all
all: compareNat.cma

compareNat.cma: ${OBJS}
	${OCAMLC} -a -o $@ $(filter-out %.cmi,$^)

# Common rules
.SUFFIXES: .ml .mli .cmi .cmo .cmx
%.cmi: %.mli
	${OCAMLC} ${INCLUDES} $<
%.cmi: %.ml
	$(OCAMLC) ${INCLUDES} -c $<
%.cmo: %.ml %.cmi
	$(OCAMLC) ${INCLUDES} -c $<

# Clean up
.PHONY: clean
clean:
	${RM} *.cm[ioxat] *.cmti *.~

# Dependencies
.PHONY: depend
depend:
	$(OCAMLDEP) $(INCLUDES) `find -name "*.mli" -or -name "*.ml"` > .depend

include .depend
