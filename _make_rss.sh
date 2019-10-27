#!/usr/bin/env sh

printf '<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <atom:link href="https://www.eseth.org/rss.xml" rel="self" type="application/rss+xml" />
    <title>Esoteric Rubbish</title>
    <link>https://www.eseth.org</link>
    <description>Rambling so utterly bereft of purpose or brevity or praticality or utility or decorum.</description>
    <language>en-us</language>
    <copyright>Copyright 2004-2019 Seth House</copyright>
    <lastBuildDate>%s</lastBuildDate>
    <ttl>40</ttl>
' "$(date -R)"

< _metadata_cache sort -n -r -k2 | head -10 \
| while read -r pfile pdate ptitle pcategories; do
    printf '<item>\n'
        printf '<title>%s</title>\n' "$ptitle"
        printf '<link>https://www.eseth.org/%s</link>\n' "$pfile"
        printf '<description><![CDATA[\n'
	PANDOC_PREFIX="https://www.eseth.org/${pfile%/*}" pandoc \
            --from=markdown \
            --to html \
            --lua-filter ./_absolute_links.lua \
            --lua-filter ./_run.lua \
            --lua-filter ./_include.lua \
            --lua-filter ./_title-to-meta-title.lua \
            $(printf "$pfile" | sed -e 's/\.html$/.md/')
        printf ']]></description>\n'
        printf '<pubDate>%s</pubDate>\n' "$(date -d"$pdate" -R)"
        printf '<guid>https://www.eseth.org/%s</guid>\n' "$pfile"
    printf '</item>\n'
done

printf '
  </channel>
</rss>
'
