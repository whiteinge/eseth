# Static site generator using Make and Pandoc
#
# - Posts can be written in any format supported by Pandoc or in regular HTML.
# - If a post is converted from a supported format into HTML it will live
#   alongside the source file. This is for simplicity and expediency.
# - Generated files can be removed using the `clean` command.

.PHONY: metadata printline

# Tell Make about files it doesn't normally know about.
.SUFFIXES: .md .rst .html

RST_SRC_FILES = $(wildcard */*.rst)
MD_SRC_FILES = $(wildcard */*.md)
SRC_FILES = $(RST_SRC_FILES) $(MD_SRC_FILES)

ALL_SRC_FILES = $(filter-out 20%/index.md, $(SRC_FILES))
ALL_DST_FILES = $(addsuffix .html, $(basename $(ALL_SRC_FILES)))

YEAR_INDEXES = $(addsuffix /index.html, $(wildcard 20*))

ALL_GENERATED_FILES = $(ALL_DST_FILES)
ALL_GENERATED_FILES += _metadata_cache
ALL_GENERATED_FILES += $(YEAR_INDEXES)
ALL_GENERATED_FILES += resume.html categories.html index.html rss.xml

TEMPLATE_FILE = _template.html

# Tell Make how to transform rST to HTML.
.rst.html:
	pandoc \
            --from=rst \
            --to html \
            --lua-filter ./_title-to-meta-title.lua \
            --template ./$(TEMPLATE_FILE) \
            -c "../base.css" \
            -o "$@" "$<"

# Tell Make how to transform Markdown to HTML.
.md.html:
	pandoc \
            --from=markdown \
            --to html \
            --lua-filter ./_run.lua \
            --lua-filter ./_include.lua \
            --lua-filter ./_title-to-meta-title.lua \
            --template ./$(TEMPLATE_FILE) \
            -c "../base.css" \
            -o "$@" "$<"

all: init $(ALL_GENERATED_FILES)

index.html: index.md _template.html _metadata_cache

categories.html: _metadata_cache

$(YEAR_INDEXES): _metadata_cache

rss.xml: _metadata_cache
	./_make_rss.sh > $@

resume.html: resume.rst resume.css
	pandoc --section-divs -c ./resume.css -s -o "$@" "$<"

init:
	@command -v pandoc > /dev/null 2>&1 \
	    || (echo 'Missing Pandoc' && exit 1)

# Generate all the HTML files for the site if they haven't been created yet or
# if the template file has been updated.
$(ALL_DST_FILES): $(TEMPLATE_FILE)

# Remove all the generated HTML files.
# (Non-generated files will not be touched.)
clean:
	rm -rf $(ALL_GENERATED_FILES) _build

# Output source files and meta data for generating indexes.
_metadata_cache: $(ALL_DST_FILES)
	rm -f $@
	@for file in $^; do \
	    pandoc --template _metadata.tmpl --to plain $$file >> $@; \
	done

# FIXME: is there a way to commit these to gh-pages without changing branches?
deploy: $(ALL_GENERATED_FILES)
	git add -f $(ALL_GENERATED_FILES)
	git commit -m 'Generate site'
	git reset HEAD~1
	git checkout gh-pages
	git reset --hard HEAD~1
	git cherry-pick ORIG_HEAD
	git checkout master -- .
	git commit --amend

printline:
	@echo $(ALL_SRC_FILES)
