SRC=$2.markdown
DEPS="header.html before.html after.html filter.pl"

redo-ifchange "$SRC" $DEPS

./filter.pl "$SRC" |                         \
pandoc                                       \
    --to html5                               \
    --section-divs                           \
    --smart                                  \
    --standalone                             \
    --mathml                                 \
    --include-before    before-with-nav.html \
    --include-after     after.html           \
    --include-in-header header.html          \
    --css css/base.css                       \
    --out "$3"
