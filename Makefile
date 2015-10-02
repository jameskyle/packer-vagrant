TEMPLATESDIR ?= templates
DOMAIN ?= boxes.att.io
BASE_URL ?= http://$(DOMAIN)

version: check-version
	ssh boxes.att.io mkdir -p /var/boxes/centos/boxes/centos-7.0-x86_64/versions/$(VERSION)/providers/
	ssh boxes.att.io mkdir -p /var/boxes/centos/boxes/centos-6.5-x86_64/versions/$(VERSION)/providers/
	ssh boxes.att.io mkdir -p /var/boxes/ubuntu/boxes/ubuntu-14.04-amd64/versions/$(VERSION)/providers/
	ssh boxes.att.io mkdir -p /var/boxes/ubuntu/boxes/ubuntu-15.04-amd64/versions/$(VERSION)/providers/

upload: version upload_centos7 upload_centos6 upload_trusty

upload_centos7:
	@scp boxes/virtualbox/centos-7.0-x86_64.box boxes.att.io:/var/boxes/centos/boxes/centos-7.0-x86_64/versions/$(VERSION)/providers/virtualbox.box >/dev/null 2>&1
	@echo Uploaded: $(BASE_URL)/centos/boxes/centos-7.0-x86_64/versions/$(VERSION)/providers/virtualbox.box
	@scp boxes/vmware/centos-7.0-x86_64.box boxes.att.io:/var/boxes/centos/boxes/centos-7.0-x86_64/versions/$(VERSION)/providers/vmware_desktop.box >/dev/null 2>&1
	@echo Uploaded: $(BASE_URL)/centos/boxes/centos-7.0-x86_64/versions/$(VERSION)/providers/vmware_desktop.box

upload_centos6:
	@scp boxes/virtualbox/centos-6.5-x86_64.box boxes.att.io:/var/boxes/centos/boxes/centos-6.5-x86_64/versions/$(VERSION)/providers/virtualbox.box >/dev/null 2>&1
	@echo Uploaded: $(BASE_URL)/centos/boxes/centos-6.5-x86_64/versions/$(VERSION)/providers/virtualbox.box
	@scp boxes/vmware/centos-6.5-x86_64.box boxes.att.io:/var/boxes/centos/boxes/centos-6.5-x86_64/versions/$(VERSION)/providers/vmware_desktop.box >/dev/null 2>&1
	@echo Uploaded: $(BASE_URL)/centos/boxes/centos-6.5-x86_64/versions/$(VERSION)/providers/vmware_desktop.box

upload_trusty:
	@scp boxes/virtualbox/ubuntu-14.04-amd64.box boxes.att.io:/var/boxes/ubuntu/boxes/ubuntu-14.04-amd64/versions/$(VERSION)/providers/virtualbox.box >/dev/null 2>&1
	@echo Uploaded: $(BASE_URL)/ubuntu/boxes/ubuntu-14.04-amd64/versions/$(VERSION)/providers/virtualbox.box
	@scp boxes/vmware/ubuntu-14.04-amd64.box boxes.att.io:/var/boxes/ubuntu/boxes/ubuntu-14.04-amd64/versions/$(VERSION)/providers/vmware_desktop.box >/dev/null 2>&1
	@echo Uploaded: $(BASE_URL)/ubuntu/boxes/ubuntu-14.04-amd64/versions/$(VERSION)/providers/vmware_desktop.box

%: $(TEMPLATESDIR)/%.json
	packer build $(TEMPLATESDIR)/$*.json

clean:
	rm -rf packer_cache

distclean: vagrant_clean_vmware vagrant_clean_vbox clean

vagrant_clean_vmware:
	vagrant box remove jkyle/centos-7.0-x86_64  --provider vmware_desktop
	vagrant box remove jkyle/centos-6.5-x86_64  --provider vmware_desktop
	vagrant box remove jkyle/ubuntu-14.04-amd64 --provider vmware_desktop

vagrant_clean_vbox:
	vagrant box remove jkyle/centos-7.0-x86_64  --provider virtualbox
	vagrant box remove jkyle/centos-6.5-x86_64  --provider virtualbox
	vagrant box remove jkyle/ubuntu-14.04-amd64 --provider virtualbox

vagrant_add_vmware:
	vagrant box add jkyle/centos-7.0-x86_64  boxes/vmware/centos-7.0-x86_64.box
	vagrant box add jkyle/centos-6.5-x86_64  boxes/vmware/centos-6.5-x86_64.box 
	vagrant box add jkyle/ubuntu-14.04-amd64 boxes/vmware/ubuntu-14.04-amd64.box

vagrant_add_vbox:
	vagrant box add jkyle/centos-7.0-x86_64  boxes/virtualbox/centos-7.0-x86_64.box
	vagrant box add jkyle/centos-6.5-x86_64  boxes/virtualbox/centos-6.5-x86_64.box 
	vagrant box add jkyle/ubuntu-14.04-amd64 boxes/virtualbox/ubuntu-14.04-amd64.box

vagrant_vmware: vagrant_clean_vmware vagrant_add_vmware
vagrant_vbox: vagrant_clean_vbox vagrant_add_vbox

vagrant: vagrant_vmware vagrant_vbox

check-version:
ifndef VERSION
	$(error VERSION environment must be set!)
endif

.PHONY: boxes distclean boxclean clean vagrant vagrant_add_vmware \
	    vagrant_add_vbox vagrant_clean_vmware vagrant_clean_vbox \
		upload version
