SRC=$2.markdown

redo-ifchange $SRC

pandoc                              \
    --to latex                      \
    --smart                         \
    --standalone                    \
    --listings                      \
    --out "$3"                      \
    "$SRC"
