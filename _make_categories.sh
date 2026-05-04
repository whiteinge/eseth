#!/usr/bin/env sh

# Generate Markdown for the categories page (categories.html). Reads
# _metadata_cache and groups posts by category.

printf -- '---\ntitle: "Posts by Category"\n---\n\n# Posts by Category\n\n[TOC]\n'

awk '
BEGIN { FS="\t" }
{
    file=$1; sub(/\.md$/, ".html", file)
    date=$2
    title=$3
    split($4, categories, ", ")

    file_index[file] = title

    for (c in categories) {
        cate_index[categories[c]][file] = date
    }
}

END {
    asorti(cate_index, cate_index_sorted)

    for (j in cate_index_sorted) {
        catname = cate_index_sorted[j]
        printf("\n## %s\n\n", catname == "" ? "Uncategorized" : catname)

        asorti(cate_index[catname], cat_sorted, "@val_str_desc")
        for (k = 1; k <= length(cat_sorted); k += 1) {
            fpath = cat_sorted[k]
            ftitle = file_index[fpath]
            printf("- [%s](%s)\n", ftitle, fpath)
        }
    }
}
' < _metadata_cache
