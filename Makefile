PACKAGE ?= Example
VERSION ?= $(shell hg log --template '{latesttag}-{latesttagdistance}-{node|short}' -r . || echo unknown)
VERSION ?= $(shell git describe --always --tags --dirty || echo unknown)

PROGRAM = example
SOURCES = example.c
DEPENDS = .depends

CC       ?= gcc
CFLAGS   ?= -g -O2
CFLAGS   += -std=c99 -Wall -Wextra -pedantic
CPPFLAGS ?= 
CPPFLAGS += 
LDLIBS   += -lm
LDLIBS   += -lpthread
LDLIBS   += $(shell ncursesw5-config --cflags --libs)

INSTALL     = install
INSTALL_BIN = $(INSTALL) -D -m 755
INSTALL_MAN = $(INSTALL) -D -m 644

PREFIX   = /usr/local

BIN_DIR  = $(PREFIX)/bin
MAN_DIR  = $(PREFIX)/share/man
MAN1_DIR = $(MAN_DIR)/man1
MAN6_DIR = $(MAN_DIR)/man6

debug ?= 0

ifeq ($(debug),1)
CPPFLAGS += -DDEBUG -O0
endif

CPPFLAGS += -DPREFIX=$(PREFIX)   \
            -DPACKAGE=$(PACKAGE) \
            -DPROGRAM=$(PROGRAM) \
            -DVERSION=$(VERSION)

all: $(DEPENDS) $(PROGRAM)
.PHONY: all

$(PROGRAM): $(SOURCES)

clean:
	$(RM) *.o
.PHONY: clean

clobber: clean
	$(RM) $(PROGRAM)
.PHONY: clobber

install: $(PROGRAM)
	$(INSTALL_BIN) $(PROGRAM) $(DESTDIR)$(BIN_DIR)/$(PROGRAM)
.PHONY: install

install-strip:
	$(MAKE) INSTALL_BIN='$(INSTALL_BIN) -s' install
.PHONY: install-strip

uninstall:
	$(RM) $(DESTDIR)$(BIN_DIR)/$(PROGRAM)
.PHONY: uninstall

depend:
	$(RM) $(DEPENDS)
	make $(DEPENDS)
.PHONY: depend

$(DEPENDS):
	touch $(DEPENDS)
	makedepend -Y -f $(DEPENDS) -- $(CFLAGS) $(CPPFLAGS) -- $(SRCS) >&/dev/null

sinclude $(DEPENDS)
