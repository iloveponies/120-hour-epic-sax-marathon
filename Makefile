SRC=$(wildcard *.markdown)
DEPS=header.html after.html filter.pl
HTML=${SRC:.markdown=.html}

all: ${HTML}

non-index-before.html: before.html
	echo '<div class=\"top-nav\"><a href=\"index.html\">← index</a></div>' | \
	cat $< - > $@

index.html: index.markdown ${DEPS} before.html
	./make-html.sh $< before.html > $@

%.html: %.markdown ${DEPS} non-index-before.html
	./make-html.sh $< non-index-before.html > $@

clean:
	rm -f ${HTML}
	rm -f non-index-before.html
