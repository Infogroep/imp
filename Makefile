SHELL=/bin/bash
docdir:
	mkdir -p doc

rdoc:	docdir
	rdoc -o doc/rdoc -C9 -x bin -x config -x db -x doc -x tmp

epydoc: docdir
	{ \
		find -name '*.py' | grep -v '__init__.py'; \
		find * | xargs file -NF $$'\t' --mime-type | grep 'text/x-python' | cut -f 1; \
	} | xargs epydoc -o doc/epydoc

doc:	rdoc epydoc

test:
	( \
		shopt -s globstar; \
		for file in test/**/*.test; do \
			chmod +x "$$file"; \
			"$$file"; \
		done \
	)

.PHONY:	docdir rdoc epydoc doc test



