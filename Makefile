.PHONY: all

prefix = /usr/local
bindir = $(prefix)/games
datadir = $(prefix)/share/games

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

uninstall:
	rm $(DESTDIR)$(bindir)/play.it
	rm -r $(DESTDIR)$(datadir)/play.it
