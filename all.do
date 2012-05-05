FORMATS="html pdf"
FILES="$(ls *.markdown)"

for format in $FORMATS; do
    for file in $FILES; do
        echo "${file%%.markdown}.$format"
    done
done | redo-ifchange
