m4TITLE({"Posts by Category"})

# Posts by Category

m4_esyscmd({"
awk '
BEGIN { FS="\t" }
{
    file=$1; sub(/\.md$/, ".html", file)
    title=$3
    split($4, categories, ", ")

    file_index[file] = title

    for (c in categories) {
        cate_index[categories[c]][file] = title
    }
}

END {
    asorti(cate_index, cate_index_sorted)

    for (j in cate_index_sorted) {
        catname = cate_index_sorted[j]
        printf("\n## %s\n\n", catname == "" ? "Uncategorized" : catname)

        asorti(cate_index[catname], cat_sorted)
        for (k = length(cat_sorted); k > 0; k -= 1) {
            fpath = cat_sorted[k]
            ftitle = file_index[fpath]
            printf("- [%s](%s)\n", ftitle, fpath)
        }
    }
}
' < _metadata_cache
"})
