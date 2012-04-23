ALL: training-day.html

%.html: %.markdown
	pandoc --standalone --to html5 --include-before before.html --include-after after.html --css css/base.css --out $@ $<
