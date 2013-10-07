SRC=$2.latex

redo-ifchange "$SRC"

lualatex -jobname="$3" "$SRC" >/dev/null

mv "$3.pdf" "$3"
