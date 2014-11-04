#version=RHEL7
auth --enableshadow --passalgo=sha512
install
cdrom
firstboot --enable
ignoredisk --only-use=sda
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
network  --bootproto=dhcp --hostname=localhost.localdomain
rootpw --plaintext vagrant
authconfig --enableshadow --passalgo=sha512
firewall --service=ssh
timezone America/Los_Angeles --isUtc
group --name=admin
user --name=vagrant --groups=admin --plaintext --password=vagrant
zerombr
clearpart --all --drives=sda
part /boot --fstype=ext4 --size=500
part pv.01 --grow --size=1
volgroup vg_main --pesize=4096 pv.01
logvol  /     --vgname=vg_main --size=8192 --name=lv_root
logvol  /var  --vgname=vg_main --size=4096 --name=lv_var
logvol  /tmp  --vgname=vg_main --size=2048 --name=lv_tmp
logvol  /home --vgname=vg_main --size=1    --name=lv_home --grow
logvol swap   --name=lv_swap   --size=2048 --vgname=vg_main

%packages --nobase --ignoremissing --excludedocs
openssh-clients
kernel-headers
kernel-devel
gcc
make
perl
bzip2
dkms
patch
net-tools
nfs-utils
-fprintd-pam
-intltool
-aic94xx-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
-@ Dialup Networking Support
-@ Editors
-@ Printing Support
-@ Additional Development
-@ E-mail server
%end

%post

exec < /dev/tty3 > /dev/tty3
chvt 3

# redirect output to ks-post.log including stdout and stderr
(
  yum update -y
  chkconfig sendmail off
  chkconfig vbox-add-x11 off
  chkconfig smartd off
  chkconfig ntpd off
  chkconfig cupsd off
  systemctl stop NetworkManager
  systemctl disable NetworkManager
  
  echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant

  restorecon -r /home/vagrant
  restorecon -r /etc/sudoers.d
  rm -rf /tmp/*
  yum clean all

) 2>&1 | /usr/bin/tee /root/ks-post.log

chvt 7

%end

reboot
