.PHONY: all

all: libplayit2.sh

libplayit2.sh: play.it-2/src/*
	cat play.it-2/src/* > play.it-2/lib/libplayit2.sh

clean:
	rm -f play.it-2/lib/libplayit2.sh

install:
	mkdir -p ~/.local/share/play.it/
	[ -e play.it-1 ] && cp -a play.it-1 ~/.local/share/play.it/ || true
	[ -e play.it-2 ] && cp -a play.it-2 ~/.local/share/play.it/ || true
	ln -fs play.it-2/lib/libplayit2.sh ~/.local/share/play.it/
	mkdir -p ~/bin
	cp -a play.it ~/bin

uninstall:
	rm -f ~/.local/share/play.it/libplayit2.sh
	rm -rf ~/.local/share/play.it/play.it-1
	rm -rf ~/.local/share/play.it/play.it-2
	rm -f ~/bin/play.it
