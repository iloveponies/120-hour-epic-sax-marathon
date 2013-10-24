SRC=$(wildcard *.markdown)
DEPS=header.html before.html non-index-nav.html after.html filter.pl
HTML=${SRC:.markdown=.html}

all: ${HTML}

non-index-before.html: before.html non-index-nav.html
	cat before.html non-index-nav.html > non-index-before.html

index.html: index.markdown ${DEPS} before.html
	./make-html.sh $< before.html > $@

%.html: %.markdown ${DEPS} non-index-before.html
	./make-html.sh $< non-index-before.html > $@

clean:
	rm -f ${HTML}
	rm -f non-index-before.html
