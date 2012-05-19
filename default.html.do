SRC=$2.markdown
DEPS="header.html before.html after.html"

redo-ifchange "$SRC" $DEPS

perl -p -e 's/<exercise>/<section class="alert alert-success">/;' \
        -e "s#</exercise>#\n</section>#"                          \
    "$SRC" | \
perl -p -e 's/<alert>/<section class="alert alert-error">/;'      \
        -e "s#</alert>#\n</section>#"                           | \
perl -p -e 's/<info>/<section class="alert alert-info">/;'      \
        -e "s#</info>#\n</section>#"                           | \
pandoc                                \
    --from markdown                   \
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
