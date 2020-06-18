#!/usr/bin/env sh

tab=$(printf '\t')

printf '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <atom:link href="xROOT/rss.xml" rel="self" type="application/rss+xml" />
    <title>xSITE_TITLE</title>
    <link>xROOT</link>
    <description>xSITE_RUBRIC</description>
    <language>en-us</language>
    <copyright>Copyright 2004-xCOPYRIGHT xAUTHOR</copyright>
    <lastBuildDate>%s</lastBuildDate>
    <ttl>40</ttl>
' "$(date -R)"

< _metadata_cache sort -r -k2 | head -10 \
| while IFS="$tab" read -r pfile pdate ptitle pcategories; do
    printf '<item>\n'
        printf '<title>%s</title>\n' "$ptitle"
        printf '<link>xROOT/%s</link>\n' "$pfile"
        printf '<description><![CDATA[\n'
	PANDOC_PREFIX="xROOT/${pfile%/*}" pandoc \
            --from=markdown \
            --to html \
            --lua-filter ./_absolute_links.lua \
            --lua-filter ./_run.lua \
            --lua-filter ./_include.lua \
            --lua-filter ./_title-to-meta-title.lua \
            $(printf "$pfile" | sed -e 's/\.html$/.md/')
        printf ']]></description>\n'
        printf '<pubDate>%s</pubDate>\n' "$(date -d"$pdate" -R)"
        printf '<guid>xROOT/%s</guid>\n' "$pfile"
    printf '</item>\n'
done

printf '
  </channel>
</rss>
'
