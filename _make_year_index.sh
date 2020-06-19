#!/usr/bin/env sh

awk -v year="${1:?'Missing year.'}" '
    BEGIN { FS="\t" }
    { file=$1; sub(/\.md/, ".html", file); date=$2; title=$3 }
    date ~ year {
        printf("- [%s](/%s)\n", title, file)
    }
' < _metadata_cache
