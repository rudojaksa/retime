PACKAGE	:= retime
VERSION	:= 0.1
AUTHORS	:= R.Jaksa 2024 GPLv3
SUBVERS	:= 

SHELL	:= /bin/bash
PATH	:= usr/bin:$(PATH)
PKGNAME	:= $(PACKAGE)-$(VERSION)$(SUBVERSION)
PROJECT := $(shell getversion -prj)
DATE	:= $(shell date '+%Y-%m-%d')

BIN	:= mtime retime
DOC	:= $(BIN:%=%.md)

all: $(BIN) $(DOC)

$(BIN): %: %.sh .version.sh .%.built.sh Makefile
	@echo -e '#!/bin/bash' > $@
	@echo -e "# $@ generated from $(PKGNAME)/$< $(DATE)\n\n" >> $@
	cat .version.sh >> $@
	cat .$*.built.sh >> $@
	cat $< >> $@
	@chmod 755 $@
	@sync
	@echo

$(DOC): %.md: %
	./$* -h | man2md > $@

.version.sh: Makefile
	@echo 'PACKAGE=$(PACKAGE)' > $@
	@echo 'VERSION=$(VERSION)' >> $@
	@echo 'AUTHOR="$(AUTHORS)"' >> $@
	@echo 'SUBVERSION="$(SUBVERS)"' >> $@
	@echo "make $@"

.PRECIOUS: .%.built.sh
.%.built.sh: %.sh .version.sh Makefile
	@echo 'BUILT=$(DATE)' > $@
	@echo "make $@"

# /map install
ifneq ($(wildcard /map),)
install: $(BIN) $(DOC) README.md
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) bin $(BIN)
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) doc $(DOC) README.md

# /usr/local install
else
install: $(BIN)
	install $^ /usr/local/bin
endif

clean:
	rm -f .version.sh
	rm -f .*.built.sh

mrproper: clean
	rm -f $(DOC)
	rm -f $(BIN)

-include ~/.github/Makefile.git
