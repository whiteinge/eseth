#!/usr/bin/env sh
# Create the year index(es) as Markdown

sort -r -n -k 2 | awk -F'\t' '
{
    file=$1
    year=$2
    title=$3
    base_year=year
    sub(/-.*/, "", base_year)
}

NR == 1 {
    printf("\n# %s\n\n", base_year)
}

{
    printf("- [%s](/%s)\n", title, file)
}
'
