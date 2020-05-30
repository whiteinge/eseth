# 2005

``` {.run}
#!/bin/sh
awk -F'\t' '
{ file=$1; date=$2; title=$3 }
date ~ /2005/ {
    printf("- [%s](/%s)\n", title, file)
}
' < _metadata_cache
```