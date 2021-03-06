all: filters/pandoc-amsthm.py includes/default.tex includes/common.css includes/default.html includes/default.css bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py

# amsthm and other includes
filters/pandoc-amsthm.py: submodule/markdown-latex-css/submodule/pandoc-amsthm/bin/pandoc-amsthm.py
	mkdir -p filters
	cp $< $@
includes/default.tex: includes/hypersetup.latex includes/usepackage.latex submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.latex includes/ucharclasses.latex
	cat $+ > $@
## The followings are for HTML output:
### needed by default.html/css. Basically is default.css without amsthm
includes/common.css: submodule/markdown-latex-css/css/_system-fonts-lmodern.css submodule/markdown-latex-css/css/_mmdc-print.css submodule/markdown-latex-css/css/_list.css submodule/markdown-latex-css/css/_table.css
	cat $+ | sed 's/@charset "UTF-8";//g' > $@
### template snippet (pandoc.sh uses this)
includes/default.html: includes/common.css submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html submodule/markdown-latex-css/js/setup-mathjax-cdn.html
	echo '<style type="text/css">' > $@
	cat $< >> $@
	sed -e 's/<style type="text\/css">//g' -e 's/<\/style>//g' submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html >> $@
	echo '</style>' >> $@
	cat submodule/markdown-latex-css/js/setup-mathjax-cdn.html >> $@
### (marked uses this)
includes/default.css: includes/common.css submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/default.html
	cat $< > $@
	sed -e 's/<style type="text\/css">//g' -e 's/<\/style>//g' submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/default.html >> $@
	csso $@ $@
	cssnano $@ $@

# Criticmarkdup
bin/pandoc-criticmarkup.sh: submodule/pandoc-criticmarkup/pandoc-criticmarkup.sh
	mkdir -p bin
	cp $< $@
bin/criticmarkup-reject.py: submodule/pandoc-criticmarkup/criticmarkup-reject.py
	mkdir -p bin
	cp $< $@
bin/criticmarkup-accept.py: submodule/pandoc-criticmarkup/criticmarkup-accept.py
	mkdir -p bin
	cp $< $@

# Submodule
init:
	git submodule update --init --recursive
update:
	git submodule update --recursive --remote

clean:
	rm -f filters/pandoc-amsthm.py includes/default.tex includes/common.css includes/default.html includes/default.css bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py
