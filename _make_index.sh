#!/usr/bin/env sh

# Generate Markdown for the home page (index.html). Reads _metadata_cache for
# the recent-entries list and globs the working directory for year archives.

get_yaml() {
    tmpl=$(mktemp)
    printf '$%s$' "$1" > "$tmpl"
    pandoc -f markdown -t markdown --wrap=none --metadata-file=site.yml --template="$tmpl" /dev/null
    rm -f "$tmpl"
}

site_title=$(get_yaml site-title)
site_rubric=$(get_yaml site-rubric)

printf -- '---\ntitle: "%s"\n---\n\n' "$site_title"

printf '# %s\n\n' "$site_title"
printf '<em>%s</em>\n\n' "$site_rubric"

printf '## Recent Entries\n\n'
< _metadata_cache sort -r -k2 | awk '
    BEGIN { FS="\t" }
    printed > 4 { exit }
    $1 !~ /index.md/ && $1 !~ /categories.md/ {
        sub(/\.md$/, ".html", $1)
        printf("- [%s](/%s)\n", $3, $1)
        printed += 1
    }'
printf '\n'

printf '[RSS Feed](/rss.xml).\n\n'

printf '## Archives\n\n'
find . '(' -path '*.git' -o -path '*public' ')' -prune -o -type d -name '20*' -printf '%P\n' \
    | sort -n -r \
    | awk 'NR != 1 { printf(", ") } { printf("[%s](%s)", $0, $0) }'
printf '\n\n'

printf '## About Me\n\n'
printf '* [Code](https://github.com/whiteinge/).\n'
printf '* [Presentations](https://github.com/whiteinge/presentations/#readme).\n'
