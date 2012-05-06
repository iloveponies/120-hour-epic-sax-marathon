redo-ifchange "$2.hs"

ghc --make "$2.hs" -o "$3" >&2
