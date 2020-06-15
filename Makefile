# Static site generator using Make and m4
#
# Workflow -> .md -> .mdhtml/.m4f -> .html
#
# The intermediary step provides an opportunity to use m4 to _generate_
# markdown before converting it to HTML and then uses m4 again to insert the
# new HTML into the site template. The frozen m4 files cache metadata to avoid
# needing to reprocess the whole file.

.PHONY: init printline public
.SUFFIXES: .m4f .mdhtml .md .rst .html
.PRECIOUS: %.mdhtml

SRC = $(filter-out 20%/index.md, $(wildcard 20*/*.md))
INT = $(SRC:%.md=%.mdhtml)
MTA = $(SRC:%.md=%.m4f)
DST = $(SRC:%.md=%.html)
IDX = index.html categories.html $(addsuffix /index.html, $(wildcard 20*))

all: init $(DST) _metadata_cache $(IDX) rss.xml

%.html: %.mdhtml %.m4f _template.html
	m4 -R "$(F).m4f" _template.m4 "$(F).mdhtml" > "$@"

%.mdhtml %.m4f: %.md
	m4 -P _macros.m4 "$^" -F "$(F).m4f" \
	| markdown -f fencedcode > "$(F).mdhtml"
%.m4f: %.mdhtml

%.html %.mdhtml %.m4f: F = $(basename $@)

_metadata_cache: $(MTA)
	rm -f $@
	for file in $^; do \
	    m4 -R $$file _metadata_cache.m4 >> _metadata_cache; \
	done

$(IDX): _metadata_cache

rss.xml: _metadata_cache
	./_make_rss.sh | m4 -P _macros.m4 - > $@

# resume.html: resume.rst resume.css
# 	pandoc --section-divs -c ./resume.css -s -o "$@" "$<"

public: all
	mkdir -p public
	cp -r base.css categories.html index.html rss.xml 20* public

init:
	@command -v m4 > /dev/null 2>&1 \
	    || (echo 'Missing m4' && exit 1)

clean:
	rm -f $(DST) $(INT) $(MTA) \
	    $(IDX) $(IDX:%.html=%.m4f) $(IDX:%.html=%.mdhtml) \
	    _metadata_cache rss.xml

printline:
	@echo $(INT)
