#!/bin/bash
set -ex
echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers
sed -i '/^Defaults    requiretty/d' /etc/sudoers
chmod 0440 /etc/sudoers.d/vagrant
