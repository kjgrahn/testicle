# $Id$
#
# Makefile
#
# Copyright (c) 2007, 2008 J�rgen Grahn.
# All rights reserved.

SHELL=/bin/sh
INSTALLBASE=/usr/local

CXXFLAGS=-W -Wall -pedantic -std=c++98 -g -Os
CFLAGS=-W -Wall -pedantic -std=c99 -g -Os
CPPFLAGS=-I.

.PHONY: all
all:

# Note that the building of example unit tests is a bit extra
# complicated since it cannot use a properly installed testicle.
# See the manual for a suggested Makefile entry.

.PHONY: check checkv
check: example
	./example
checkv: example
	valgrind -q ./example -v

test.cc: libtests.a testicle
	./testicle -o$@ libtests.a

example: test.o libtests.a
	$(CXX) $(CXXFLAGS) -o $@ test.o -L. -ltests

libtests.a: example.o
libtests.a: example0.o
	$(AR) -r $@ $^

example.o: testicle.h
example0.o: testicle.h

.PHONY: install
install: testicle testicle.h testicle.1
	install -m755 testicle $(INSTALLBASE)/bin/
	install -m644 testicle.1 $(INSTALLBASE)/man/man1/
	install -m644 testicle.h $(INSTALLBASE)/include/

.PHONY: clean
clean:
	$(RM) *.pyc *.pyo
	$(RM) example test.cc *.[oa]

love:
	@echo "not war?"
