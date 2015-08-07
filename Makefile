PACKAGE ?= Example
VERSION ?= $(shell hg log --template '{latesttag}-{latesttagdistance}-{node|short}' -r . || echo unknown)
VERSION ?= $(shell git describe --always --tags --dirty || echo unknown)

PROGRAM = example
SOURCES = example.c

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

bin_dir  = $(PREFIX)/bin
man_dir  = $(PREFIX)/share/man
man1_dir = $(man_dir)/man1
man6_dir = $(man_dir)/man6

debug ?= 0

ifeq ($(debug),1)
CPPFLAGS += -DDEBUG -O0
endif

CPPFLAGS += -DPREFIX=$(PREFIX)   \
            -DPACKAGE=$(PACKAGE) \
            -DPROGRAM=$(PROGRAM) \
            -DVERSION=$(VERSION)

all: $(PROGRAM)
.PHONY: all

$(PROGRAM): $(SOURCES)

clean:
	$(RM) *.o
.PHONY: clean

clobber: clean
	$(RM) $(PROGRAM)
.PHONY: clobber

install: $(PROGRAM)
	$(INSTALL_BIN) $(PROGRAM) $(DESTDIR)$(bin_dir)/$(PROGRAM)
.PHONY: install

install-strip:
	$(MAKE) INSTALL_BIN='$(INSTALL_BIN) -s' install
.PHONY: install-strip

uninstall:
	$(RM) $(DESTDIR)$(bin_dir)/$(PROGRAM)
.PHONY: uninstall
