#!/bin/bash
set -ex

if [[ $OS_FAMILY = "RedHat" ]]; then
	rpm -ivh $PUPPET_REPO
	yum install puppet -y
elif [[ $OS_FAMILY = "Debian" ]]; then
	mkdir -p /tmp/puppet/
	cd /tmp/puppet
	curl -O $PUPPET_REPO
	dpkg -i *.deb
	apt-get update
	apt-get install puppet -y
fi
