# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

Vagrant.configure("2") do |config|
  config.vm.define :centos7 do |t|
    t.vm.box = "jkyle/centos-7.0-x86_64"
    t.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    t.vm.provider "vmware_fusion" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end
  
  config.vm.define :centos65 do |t|
    t.vm.box = "jkyle/centos-6.5-x86_64"
    t.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    t.vm.provider "vmware_fusion" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end
  
  config.vm.define "ubuntu14.04" do |t|
    t.vm.box = "jkyle/ubuntu-14.04-amd64"
    t.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    t.vm.provider "vmware_fusion" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end
  
end
