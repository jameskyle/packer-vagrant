#!/bin/bash
set -ex

echo "============ Upgrading target system ============"
if [[ $OS_FAMILY == "RedHat" ]]; then
  yum update -y
elif [[ $OS_FAMILY == "Debian" ]]; then
  apt-get update && apt-get dist-upgrade -y
  apt-get autoremove --purge -y
else
  echo "============ Unkown OS Family. Don't know how to upgrade ==========="
fi

reboot

sleep 60