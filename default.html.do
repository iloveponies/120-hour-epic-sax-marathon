SRC=$2.markdown
DEPS="header.html before.html after.html"
FILTER_SOURCES=$(echo filters/*.hs)
FILTER_BINS=$(echo $FILTER_SOURCES | sed 's/.hs//g')
FILTEREXPR=$(echo $FILTER_BINS | tr ' ' '|')

redo-ifchange "$SRC" $DEPS $FILTER_BINS

pandoc --to json "$SRC" |           \
$SHELL -c "$FILTEREXPR" |           \
pandoc                              \
    --from json                     \
    --to html5                      \
    --section-divs                  \
    --smart                         \
    --standalone                    \
    --mathml                        \
    --include-in-header header.html \
    --include-before    before.html \
    --include-after     after.html  \
    --css css/base.css              \
    --out "$3"
