Packer Vagrant
==============

Collection of packer templates and provisioning scripts for creating vagrant 
boxes.

Supported Targets
=================

- CentOS 6.5
- CentOS 7.0
- Ubuntu 14.04

Supported Providers
===================

- Vmware Fusion
- Virtualbox

Examples
========

    packer build templates/centos-7.0-x86_64.json
    packer build templates/centos-6.5-x86_64.json
    packer build templates/ubuntu-14.04-amd64.json
    make DOMAIN=boxes.att.io VERSION=1.0 upload

    ssh boxes.att.io mkdir -p /var/boxes/centos/boxes/centos-7.0-x86_64/versions/1.1/providers/
    ssh boxes.att.io mkdir -p /var/boxes/centos/boxes/centos-6.5-x86_64/versions/1.1/providers/
    ssh boxes.att.io mkdir -p /var/boxes/ubuntu/boxes/ubuntu-14.04-amd64/versions/1.1/providers/
    Uploaded: http://boxes.att.io/centos/boxes/centos-7.0-x86_64/versions/1.1/providers/virtualbox.box
    Uploaded: http://boxes.att.io/centos/boxes/centos-7.0-x86_64/versions/1.1/providers/vmware_desktop.box
    Uploaded: http://boxes.att.io/centos/boxes/centos-6.5-x86_64/versions/1.1/providers/virtualbox.box
    Uploaded: http://boxes.att.io/centos/boxes/centos-6.5-x86_64/versions/1.1/providers/vmware_desktop.box
    Uploaded: http://boxes.att.io/ubuntu/boxes/ubuntu-14.04-amd64/versions/1.1/providers/virtualbox.box
    Uploaded: http://boxes.att.io/ubuntu/boxes/ubuntu-14.04-amd64/versions/1.1/providers/vmware_desktop.box

You should be able to ssh into $(DOMAIN) without a password or you’ll be
prompted for each action. This will create the version directories in
/var/boxes and uploads the created boxes to that version directory.
