SRC=$2.markdown
DEPS="header.html template.html"
FILTER_SOURCES=$(echo filters/*.hs)
FILTER_BINS=$(echo $FILTER_SOURCES | sed 's/.hs//g')
FILTEREXPR=$(echo $FILTER_BINS | tr ' ' '|')

redo-ifchange "$SRC" $DEPS $FILTER_BINS

perl -p -e 's/<exercise>/<section class="alert alert-success">/;' \
        -e "s#</exercise>#\n</section>#"                          \
    "$SRC" | \
pandoc --to json        |             \
$SHELL -c "$FILTEREXPR" |             \
pandoc                                \
    --from json                       \
    --to html5                        \
    --section-divs                    \
    --smart                           \
    --standalone                      \
    --mathml                          \
    --table-of-contents               \
    --template          template.html \
    --include-in-header header.html   \
    --css css/base.css                \
    --out "$3"
