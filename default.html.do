SRC=$2.markdown
DEPS="header.html before.html after.html"

redo-ifchange "$SRC" $DEPS

pandoc                              \
    --to html5                      \
    --standalone                    \
    --mathml                        \
    --include-in-header header.html \
    --include-before    before.html \
    --include-after     after.html  \
    --css css/base.css              \
    --out "$3"                      \
    "$SRC"
