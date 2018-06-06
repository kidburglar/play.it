.PHONY: all

prefix = /usr/local
bindir = $(prefix)/games
datadir = $(prefix)/share/games
mandir = $(prefix)/share/man

all: libplayit2.sh

libplayit2.sh: play.it-2/src/*
	cat play.it-2/src/* > play.it-2/lib/libplayit2.sh

clean:
	rm -f play.it-2/lib/libplayit2.sh

install:
	mkdir -p $(DESTDIR)$(bindir)
	cp -a play.it $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(datadir)/play.it
	cp -a play.it-2/lib/libplayit2.sh play.it-2/games/* $(DESTDIR)$(datadir)/play.it
	mkdir -p $(DESTDIR)$(mandir)/man6
	gzip -c play.it.6 > $(DESTDIR)$(mandir)/man6/play.it.6.gz

uninstall:
	rm $(DESTDIR)$(bindir)/play.it
	rm -r $(DESTDIR)$(datadir)/play.it
	rm $(DESTDIR)$(mandir)/man6/play.it.6.gz
