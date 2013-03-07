#!/bin/sh

lein midje \
| egrep '[^"]*"[0-9]+' \
| sed -r 's|[^"]*"([0-9]+ [^"]+)".*|\1|g' \
| uniq
