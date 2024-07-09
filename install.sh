#!/bin/bash

# SOURCES https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html
# 	  https://developer.hashicorp.com/vagrant/docs/synced-folders/basic_usage


echo "Check Hardware Virtualisation support by CPU"

if [[ $(grep -E -c '(vmx|svm)' /proc/cpuinfo) -eq 0 ]]
then
    echo "Hardware Virtualisation is not supported by CPU"
    exit 1
else
    echo "Hardware Virtualisation is supported by CPU"
fi

echo "Some commands require sudo priveleges"
echo "Up[date/grade] OS components"

sudo apt update; sudo apt upgrade -y; sudo apt dist-upgrade -y; sudo apt autoremove -y; sudo apt autoclean -y;

echo "Install Libvirt, KVM, NFS and Vagrant"

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update

sudo apt install -y \
	cpu-checker \
        bridge-utils \
	vagrant \
	qemu-kvm \
	virtiofsd \
	libvirt-daemon-system \
	libvirt-clients
sudo systemctl enable --now libvirtd

echo "Add Your Username to Virtualization Groups"
sudo adduser "$(id -un)" libvirt
sudo adduser "$(id -un)" kvm

echo "Install vagrant-libvirt Plugin and required components"
sudo apt build-dep vagrant ruby-libvirt
sudo apt install \
	dnsmasq-base \
	ebtables \
	libvirt-dev \
	libxml2-dev \
	libxslt1-dev \
	ruby-dev \
	zlib1g-dev

#sudo systemctl enable --now nfs-server
vagrant plugin install vagrant-libvirt

echo "Creating sns3 directory under your home directory" 
cd ~
mkdir -p sns3/vagrant
cd ~/sns3

echo "Provision VM to deploy simulator"

cat <<-VAGRANTFILE > Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 4096
    libvirt.memorybacking :access, :mode => "shared"
  end
  config.vm.synced_folder "~/sns3/vagrant", "/vagrant", type: "virtiofs"
end
VAGRANTFILE

vagrant up --provider libvirt

echo "List and connect to machine"
vagrant status
vagrant ssh

#ssh vagrant@192.168.7.2 \
#  -i .vagrant/machines/default/libvirt/private_key
