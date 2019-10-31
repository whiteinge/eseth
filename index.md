# Esoteric Rubbish

::: {.rubric}
_Rambling so utterly bereft of purpose or brevity_  
_or praticality or utility or decorum._
:::

## Recent Entries

``` {.run}
#!/bin/sh
< _metadata_cache sort -r -k2 \
    | head -4 \
    | awk -F'\t' '{ printf("- [%s](/%s)\n", $3, $1) }'
```

## Archives

``` {.run}
#!/bin/sh
ffind . -type d -name '20*' -printf '%P\n' \
    | sort -n -r \
    | awk 'NR != 1 { printf(", ") } { printf("[%s](%s)", $0, $0) }'
```

## About Me

* [Code](https://github.com/whiteinge/).
* [Presentations](https://github.com/whiteinge/presentations/#readme).
