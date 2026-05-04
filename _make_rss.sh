#!/usr/bin/env sh

# Generate rss.xml for the 10 most recent posts. Reads site.yml for site
# metadata and _metadata_cache for the post list. Each item's description is
# rendered fresh from the post's Markdown via Pandoc.

get_yaml() {
    tmpl=$(mktemp)
    printf '$%s$' "$1" > "$tmpl"
    pandoc -f markdown -t markdown --wrap=none --metadata-file=site.yml --template="$tmpl" /dev/null
    rm -f "$tmpl"
}

ROOT=$(get_yaml root)
SITE_TITLE=$(get_yaml site-title)
SITE_RUBRIC=$(get_yaml site-rubric)
AUTHOR=$(get_yaml author)
COPYRIGHT=$(date +%Y)
BUILD_DATE=$(date -R)

tab=$(printf '\t')

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <atom:link href="${ROOT}/rss.xml" rel="self" type="application/rss+xml" />
    <title>${SITE_TITLE}</title>
    <link>${ROOT}</link>
    <description>${SITE_RUBRIC}</description>
    <language>en-us</language>
    <copyright>Copyright 2004-${COPYRIGHT} ${AUTHOR}</copyright>
    <lastBuildDate>${BUILD_DATE}</lastBuildDate>
    <ttl>40</ttl>
EOF

< _metadata_cache awk -F'\t' '$2 != ""' | sort -r -k2 | head -10 \
| while IFS="$tab" read -r pfile pdate ptitle pcategories; do
    fname=$(printf "%s\n" "$pfile" | sed -e 's/\.md$/.html/')
    fpath=$(dirname "$pfile")
    printf '<item>\n'
        printf '<title>%s</title>\n' "$ptitle"
        printf '<link>%s/%s</link>\n' "$ROOT" "$fname"
        printf '<description><![CDATA[\n'
        pandoc -f markdown -t html --no-highlight --wrap=none "$pfile" \
            | sed -e 's|src="\./|src="'"$ROOT"'/'"$fpath"'/|g'
        printf ']]></description>\n'
        printf '<pubDate>%s</pubDate>\n' "$(date -d"$pdate" -R)"
        printf '<guid>%s/%s</guid>\n' "$ROOT" "$fname"
    printf '</item>\n'
done

cat <<EOF
  </channel>
</rss>
EOF
