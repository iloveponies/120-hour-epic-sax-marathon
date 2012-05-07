SRC=$2.markdown

redo-ifchange "$SRC"

pandoc                              \
    --to epub                       \
    --section-divs                  \
    --smart                         \
    --standalone                    \
    --out "$3"                      \
    "$SRC"
