#!/bin/bash
set -ex
WORKDIR=${WORKDIR:-/home/vagrant/work}

rm -rf ${WORKDIR}

yum remove gcc kernel-devel kernel-headers bzip2 perl -y
yum clean all -y

find /var/log -type f | while read f;do echo -ne '' > $f;done
rm -rf /tmp/*

set +e
dd if=/dev/zero of=/EMPTY bs=1M
set -e
rm -f /EMPTY
sync