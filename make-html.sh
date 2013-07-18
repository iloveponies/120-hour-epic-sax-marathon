#!/usr/bin/env bash

./filter.pl "$1" |                  \
pandoc                              \
    --to html5                      \
    --section-divs                  \
    --smart                         \
    --standalone                    \
    --mathjax                       \
    --include-before    "$2"        \
    --include-after     after.html  \
    --include-in-header header.html \
    --css css/base.css
