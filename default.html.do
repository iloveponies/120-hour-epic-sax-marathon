SRC=$2.markdown
DEPS="header.html before.html after.html"
FILTER_SOURCES=$(echo filters/*.hs)
FILTER_BINS=$(echo $FILTER_SOURCES | sed 's/.hs//g')
FILTEREXPR=$(echo $FILTER_BINS | tr ' ' '|')

redo-ifchange "$SRC" $DEPS $FILTER_BINS

perl -p -e 's/<exercise>/<section class="alert alert-success">/;' \
        -e "s#</exercise>#\n</section>#"                          \
    "$SRC" | \
perl -p -e 's/<alert>/<section class="alert alert-error">/;'      \
        -e "s#</alert>#\n</section>#"                           | \
perl -p -e 's/<info>/<section class="alert alert-info">/;'      \
        -e "s#</info>#\n</section>#"                           | \
pandoc --to json        |             \
$SHELL -c "$FILTEREXPR" |             \
pandoc                                \
    --from json                       \
    --to html5                        \
    --section-divs                    \
    --smart                           \
    --standalone                      \
    --mathml                          \
    --include-before   before.html    \
    --include-after    after.html     \
    --include-in-header header.html   \
    --css css/base.css                \
    --out "$3"
