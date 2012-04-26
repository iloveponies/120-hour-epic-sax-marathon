ALL: training-day.html basic-tools.html

%.html: %.markdown
	pandoc                              \
		--to html5                      \
		--standalone                    \
		--mathml                        \
		--include-in-header header.html \
		--include-before before.html    \
		--include-after after.html      \
		--css css/base.css              \
		--out $@                        \
		$<
