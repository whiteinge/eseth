#!/usr/bin/env sh

year=${1:?'Missing year.'}

printf -- '---\ntitle: "Blog posts from %s"\n---\n\n# %s\n\n' "$year" "$year"

awk -v year="$year" '
    BEGIN { FS="\t" }
    { file=$1; sub(/\.md/, ".html", file); date=$2; title=$3 }
    date ~ year {
        printf("- [%s](/%s)\n", title, file)
    }
' < _metadata_cache
