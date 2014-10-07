#!/bin/bash
set -ex

rpm -ivh $PUPPET_REPO
yum install puppet -y