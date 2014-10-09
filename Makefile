TEMPLATESDIR ?= templates

boxes/vmware/%.box: $(TEMPLATESDIR)/%.json
	packer build --force $(TEMPLATESDIR)/$*.json

boxes/virtualbox/%.box: $(TEMPLATESDIR)/%.json
	packer build --force $(TEMPLATESDIR)/$*.json

clean:
	rm -rf packer_cache

distclean: clean
	rm -rf boxes
