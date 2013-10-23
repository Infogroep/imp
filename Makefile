SHELL=/bin/bash
docdir:
	mkdir -p doc

rdoc:	docdir
	rdoc -o doc/rdoc --include scripts,util -C9

epydoc: docdir
	{ \
		find -name '*.py' | grep -v '__init__.py'; \
		find * | xargs file -NF $$'\t' --mime-type | grep 'text/x-python' | cut -f 1; \
	} | xargs epydoc -o doc/epydoc

doc:	rdoc epydoc

.PHONY:	docdir rdoc epydoc doc



