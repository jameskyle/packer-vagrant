#!/bin/bash
set -ex

MOUNTDIR=${MOUNTDIR:-/mnt/vmtools}
ISO=${ISO:-/tmp/linux.iso}
WORKDIR=${WORKDIR:-/home/vagrant/work}

mkdir ${MOUNTDIR}
mkdir -p ${WORKDIR}
mount -o loop ${ISO} ${MOUNTDIR}
yum install bzip2 \
			dkms \
			gcc \
			kernel-devel \
			kernel-headers \
			fuse-libs \
			fuse \
			perl \
			net-tools \
			patch -y

if [[ "${PACKER_BUILDER_TYPE}" =~ "virtualbox" ]]; then
  set +e
  sh ${MOUNTDIR}/VBoxLinuxAdditions.run --nox11
  set -e
else
	mkdir -p /mnt/floppy
	if [[ -e /etc/redhat-release ]]; then # 7.x has os-release
	    modprobe floppy
	fi
    mount -t vfat /dev/fd0 /mnt/floppy

	tar xzvf ${MOUNTDIR}/VMwareTools*.tar.gz -C ${WORKDIR}

	# Patch for vmhgfs on RHEL 7
	cd ${WORKDIR}/vmware-tools-distrib/lib/modules/source/
	tar xf vmhgfs.tar
	cd vmhgfs-only/shared/
	patch < /mnt/floppy/compat_dcache.h.patch
	cd ${WORKDIR}/vmware-tools-distrib/lib/modules/source/
	tar cf vmhgfs.tar vmhgfs-only
	cd ${WORKDIR}/vmware-tools-distrib
	./vmware-install.pl -default

	yum remove patch kernel-devel gcc kernel-headers -y
	umount ${MOUNTDIR}
	rmdir ${MOUNTDIR}
	rm -rf ${WORKDIR}/vmware-tools-distrib/
	cat <<EOF > /etc/sysconfig/modules/vmware.modules
#!/bin/bash
modprobe vmhgfs
modprobe vmxnet
EOF
	chmod +x /etc/sysconfig/modules/vmware.modules
fi