#!/bin/bash
set -ex

MOUNTDIR=${MOUNTDIR:-/mnt/vmtools}
ISO=${ISO:-/home/vagrant/linux.iso}
WORKDIR=${WORKDIR:-/home/vagrant/work}

mkdir -p ${MOUNTDIR}
mkdir -p ${WORKDIR}
mount -o loop ${ISO} ${MOUNTDIR}

function redhat() {
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
}

function debian() {
  apt-get install build-essential linux-headers-server -y
}

function redhat_finish() {
  yum remove patch kernel-devel gcc kernel-headers -y
	cat <<EOF > /etc/sysconfig/modules/vmware.modules
#!/bin/bash
modprobe vmhgfs
modprobe vmxnet
EOF
	chmod +x /etc/sysconfig/modules/vmware.modules
}

function debian_finish() {
  apt-get purge linux-headers-server build-essential -y
}

function init() {
  if [[ $OS_FAMILY == "RedHat" ]]; then
    redhat
  elif [[ $OS_FAMILY == "Debian" ]]; then
    debian
  fi
}

function finish() {
	umount ${MOUNTDIR}
	rmdir ${MOUNTDIR}
	rm -rf ${WORKDIR}/vmware-tools-distrib/
  rm -f  ${ISO}
  if [[ $OS_FAMILY == "RedHat" ]]; then
    redhat_finish
  elif [[ $OS_FAMILY == "Debian" ]]; then
    debian_finish
  fi
}

function common() {
  if [[ "${PACKER_BUILDER_TYPE}" =~ "virtualbox" ]]; then
    set +e
    sh ${MOUNTDIR}/VBoxLinuxAdditions.run --nox11
    set -e
  else
    tar xzvf ${MOUNTDIR}/VMwareTools*.tar.gz -C ${WORKDIR}

    # Patch for vmhgfs on RHEL 7
    cd ${WORKDIR}/vmware-tools-distrib/lib/modules/source/
    tar xf vmhgfs.tar
    cd vmhgfs-only/shared/
    cat <<EOF > /tmp/compat_dcache.h.patch
--- compat_dcache.h	2014-09-07 18:33:57.939430889 +0700
+++ compat_dcache.patch.h	2014-09-07 18:34:40.186450921 +0700
@@ -53,6 +53,8 @@
  */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 11, 0)
 #define compat_d_count(dentry) d_count(dentry)
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(3, 10, 0)
+#define compat_d_count(dentry) d_count(dentry)
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 38)
 #define compat_d_count(dentry) dentry->d_count
 #else 
EOF
    
    patch < /tmp/compat_dcache.h.patch
    cd ${WORKDIR}/vmware-tools-distrib/lib/modules/source/
    tar cf vmhgfs.tar vmhgfs-only
    cd ${WORKDIR}/vmware-tools-distrib
    ./vmware-install.pl -default
  fi
}


function main() {
  init
  common
  finish
}

main