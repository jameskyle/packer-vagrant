

centos70:
	packer build templates/centos70.json

clean:
	rm -rf packer_cache

distclean: clean
	rm -rf boxes
