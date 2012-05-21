#!/usr/bin/env zsh

SRC=$2.markdown
DEPS=(header.html before.html after.html filter.pl)

redo-ifchange "$SRC" $DEPS

BEFORE="$(cat before.html)"

if [ $1 != "index.html" ]; then
    BEFORE="$BEFORE<div class=\"top-nav\"><a href=\"index.html\">← index</a></div>"
fi

./filter.pl "$SRC" |                    \
pandoc                                  \
    --to html5                          \
    --section-divs                      \
    --smart                             \
    --standalone                        \
    --mathml                            \
    --include-before    <(echo $BEFORE) \
    --include-after     after.html      \
    --include-in-header header.html     \
    --css css/base.css                  \
    --out "$3"
