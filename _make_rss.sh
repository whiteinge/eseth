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

< _metadata_cache sort -r -k2 | grep -v xDATE | head -10 \
| while IFS="$tab" read -r pfile pdate ptitle pcategories; do
    fname=$(printf "%s\n" "$pfile" | sed -e 's/\.md$/.html/')
    iname=$(printf "%s\n" "$pfile" | sed -e 's/\.md$/.mdhtml/')
    fpath=$(dirname "$pfile")
    printf '<item>\n'
        printf '<title>%s</title>\n' "$ptitle"
        printf '<link>xROOT/%s</link>\n' "$pfile"
        printf '<description><![CDATA[\n'
        cat "$iname" \
            | sed -e 's/src="\.\//src="xROOT\/'"$fpath"'\//g'
        printf ']]></description>\n'
        printf '<pubDate>%s</pubDate>\n' "$(date -d"$pdate" -R)"
        printf '<guid>xROOT/%s</guid>\n' "$fname"
    printf '</item>\n'
done

printf '
  </channel>
</rss>
'
