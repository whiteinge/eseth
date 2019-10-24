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
YEAR_DIRS = $(wildcard 20*)

ALL_SRC_FILES += $(RST_SRC_FILES)
ALL_SRC_FILES += $(MD_SRC_FILES)

ALL_DST_FILES = $(addsuffix .html, $(basename $(ALL_SRC_FILES)))
ALL_YEAR_FILES = $(addsuffix /index.html, $(YEAR_DIRS))

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
            --lua-filter ./_title-to-meta-title.lua \
            --template ./$(TEMPLATE_FILE) \
            -c "../base.css" \
            -o "$@" "$<"

all: init $(ALL_DST_FILES) resume.html categories.html index.html $(ALL_YEAR_FILES) years.html

index.html: index.md _template.html

resume.html: resume.rst resume.css
	pandoc --section-divs -c ./resume.css -s -o "$@" "$<"

years.html: $(YEAR_DIRS)
	$(shell { printf '# Posts by Year\n\n'; \
	    printf '%s\n' $(addprefix "- ", $(join \
		$(patsubst %, "[%]", $(YEAR_DIRS)), \
		$(patsubst %, "(%)", $(YEAR_DIRS)) \
	    )); } | sort -r -n | pandoc \
		--from=markdown \
		--to html \
		--lua-filter ./_title-to-meta-title.lua \
		--template ./_template.html \
		-c "./base.css" \
		-o "$@" )

categories.html: _meta_by_category.sh _metadata.tmpl _template.html $(ALL_SRC_FILES)
	./_meta_by_category.sh | pandoc \
            --from=markdown \
            --to html \
            --lua-filter ./_title-to-meta-title.lua \
            --template ./_template.html \
            -c "./base.css" \
            -o "$@"

# By-year index files.
%/index.html: %/*.html
	$(shell printf '%s\n' $^ \
	    | xargs -L1 pandoc \
		--lua-filter _title-to-meta-title.lua \
		--template _metadata.tmpl \
		--to plain \
	    | ./_meta_by_year.sh \
	    | pandoc \
		--from=markdown \
		--to html \
		--lua-filter ./_title-to-meta-title.lua \
		--template ./_template.html \
		-c "../base.css" \
		-o "$@" )

init:
	@command -v pandoc > /dev/null 2>&1 \
	    || (echo 'Missing Pandoc' && exit 1)

# Generate all the HTML files for the site if they haven't been created yet or
# if the template file has been updated.
$(ALL_DST_FILES): $(TEMPLATE_FILE)

# Remove all the generated HTML files.
# (Non-generated files will not be touched.)
clean:
	rm -f $(ALL_DST_FILES) resume.html categories.html $(ALL_YEAR_FILES) years.html

# Print defined variables for debugging.
printline:
	@echo $(ALL_YEAR_FILES)

# Output source files and meta data for generating indexes.
metadata:
	@for file in $(ALL_DST_FILES); do \
	    pandoc \
		--lua-filter _title-to-meta-title.lua \
		--template _metadata.tmpl \
		--to plain \
		$$file ; \
	done
