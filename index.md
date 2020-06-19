TITLE(xSITE_TITLE)

# xSITE_TITLE

<em>xSITE_RUBRIC</em>

## Recent Entries

m4_esyscmd({"
< _metadata_cache sort -r -k2 | awk '
    BEGIN { FS="\t" }
    printed > 4 { exit }
    $1 !~ /index.md/ && $1 !~ /categories.md/ {
        sub(/\.md$/, ".html", $1)
        printf("- [%s](/%s)\n", $3, $1)
        printed += 1
    }'
"})

## Archives

m4_esyscmd({"
find . '(' -path '*.git' -o -path '*public' ')' -prune -o -type d -name '20*' -printf '%P\n' \
    | sort -n -r \
    | awk 'NR != 1 { printf(", ") } { printf("[%s](%s)", $0, $0) }'
"})

## About Me

* [Code](https://github.com/whiteinge/).
* [Presentations](https://github.com/whiteinge/presentations/#readme).
