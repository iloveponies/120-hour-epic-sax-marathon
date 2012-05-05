SRC=$2.markdown

redo-ifchange "$SRC"

pandoc                              \
    --to latex                      \
    --smart                         \
    --standalone                    \
    --out "$3"                      \
    -V documentclass:report         \
    -V mainfont:Ubuntu              \
    -V monofont:"Ubuntu Mono"       \
    -V geometry:margin=3cm          \
    -V lang:english                 \
    "$SRC"
