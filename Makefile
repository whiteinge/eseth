# Static site generator using Make and Pandoc.
#
# Each post is plain Markdown with YAML frontmatter. Pandoc renders the body
# into _template.html for the final page and into _meta.tmpl for a one-line
# tab-separated metadata cache used by the index, categories, year-index, and
# RSS pages.

.PHONY: init deploy clean
.PRECIOUS: %.meta

SRC = $(filter-out 20%/index.md, $(wildcard 20*/*.md))
DST = $(SRC:%.md=%.html)
META = $(SRC:%.md=%.meta)
IDX = index.html categories.html $(addsuffix /index.html, $(wildcard 20*))

FILTERS = _title_from_h1.lua _inline_toc.lua
DEPS = _template.html site.yml $(FILTERS)

PANDOC = pandoc -f markdown -t html --no-highlight --wrap=none \
    $(addprefix --lua-filter=,$(FILTERS)) \
    --template=_template.html --metadata-file=site.yml

all: init $(DST) _metadata_cache $(IDX) rss.xml

%.html: %.md $(DEPS)
	$(PANDOC) --metadata=outfile="$@" "$<" -o "$@"

%.meta: %.md _meta.tmpl _title_from_h1.lua
	pandoc -f markdown -t plain --wrap=none \
	    --lua-filter=_title_from_h1.lua \
	    --template=_meta.tmpl \
	    "$<" -o "$@"

_metadata_cache: $(META)
	cat $^ > $@

index.html: _make_index.sh _metadata_cache $(DEPS)
	./_make_index.sh | $(PANDOC) --metadata=outfile="$@" -o "$@"

categories.html: _make_categories.sh _metadata_cache $(DEPS)
	./_make_categories.sh | $(PANDOC) --metadata=outfile="$@" -o "$@"

20%/index.html: _make_year_index.sh _metadata_cache $(DEPS)
	./_make_year_index.sh "20$*" | $(PANDOC) --metadata=outfile="$@" -o "$@"

rss.xml: _make_rss.sh _metadata_cache site.yml $(DST)
	./_make_rss.sh > "$@"

deploy: all
	mkdir -p public
	cp -r base.css categories.html index.html rss.xml 20* public
	git checkout --orphan glpages gitlab/glpages-init
	git add public
	git commit -m "Add site build"
	git checkout master
	git push -f gitlab glpages
	git branch -D glpages

init:
	@command -v pandoc > /dev/null 2>&1 \
	    || (echo 'Missing pandoc' && exit 1)

clean:
	rm -f $(DST) $(META) \
	    $(IDX) \
	    _metadata_cache rss.xml
	rm -rf public
