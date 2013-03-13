#!/bin/sh

lein midje \
| egrep '[^F]*FAIL[^"]*"[0-9]+' \
| sed -r 's|[^"]*"([0-9]+ [^"]+)".*|\1|g' \
| uniq
