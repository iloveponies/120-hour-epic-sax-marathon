header := header.html
before := before.html
after := after.html
templates := $(header) $(before) $(after)

ALL: training-day.html basic-tools.html

%.html: %.markdown $(templates)
	pandoc                              \
		--to html5                      \
		--standalone                    \
		--mathml                        \
		--include-in-header $(header)   \
		--include-before    $(before)   \
		--include-after     $(after)    \
		--css css/base.css              \
		--out $@                        \
		$<
