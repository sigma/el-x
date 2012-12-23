PROJECT=el-x
VERSION=$(shell git describe --tags --dirty)
EMACS=emacs
SRC=lisp

ELS=$(wildcard $(SRC)/*.el)
ELCS=$(ELS:.el=.elc)
ELPA_FILES=$(ELS) $(PROJECT)-pkg.el

EFLAGS=
BATCH=$(EMACS) $(EFLAGS) -batch -q -no-site-file -eval \
  "(setq load-path (cons (expand-file-name \"$(SRC)\") load-path))"

%.elc: %.el
	$(BATCH) --eval '(byte-compile-file "$<")'

all: $(ELCS)

$(PROJECT)-pkg.el: $(PROJECT)-pkg.el.in
	sed -e s/@VERSION@/$(VERSION)/ < $< > $@

elpa: $(PROJECT)-$(VERSION).tar

$(PROJECT)-$(VERSION).tar: $(ELPA_FILES)
	mkdir $(PROJECT)-$(VERSION)
	cp $(ELPA_FILES) $(PROJECT)-$(VERSION)
	tar -cvf $(PROJECT)-$(VERSION).tar $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

clean:
	rm -f $(ELCS) $(PROJECT)-pkg.el
