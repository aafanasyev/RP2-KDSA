#!/bin/bash

# SOURCES https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html
# 	  https://developer.hashicorp.com/vagrant/docs/synced-folders/basic_usage
#


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

sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y; sudo apt-get autoclean -y;

echo "Install Libvirt, KVM, VirtioFS and Vagrant"

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --batch --yes
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update

sudo apt-get --allow-downgrades --allow-change-held-packages install -y \
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

#only since ubuntu 24.04 

sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources

#
sudo apt-get -y update

sudo apt-get -y build-dep ruby-libvirt

sudo apt-get install -y --allow-downgrades \
	dnsmasq-base \
	ebtables \
	libvirt-dev \
	libxml2-dev \
	libxslt1-dev \
	ruby-dev \
	zlib1g-dev 

vagrant plugin uninstall vagrant-libvirt
vagrant plugin install vagrant-libvirt
vagrant plugin update
sudo apt-mark hold vagrant

echo "##########################################
      ###
      ### Provision of the Ubuntu 22.04 LTS VM
      ###
      ##########################################"

cat <<-VAGRANTFILE > Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  #config.vm.box = "jtarpley/ubuntu2404_base"
  #config.vm.box = "crystax/ubuntu2404"
  #config.vm.box = "boxen/ubuntu-24.04"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 4096
    libvirt.memorybacking :access, :mode => "shared"
  end

  config.vm.provision :shell, path: "vagrant/bootstrap.sh", run: 'always'
  config.vm.provision :shell, reboot: true
  config.vm.provision :shell, path: "vagrant/ltsupgrade.sh"
  config.vm.provision :shell, reboot: true
  #config.vm.provision :shell, path: "vagrant/desktop.sh"
  #config.vm.provision :shell, reboot: true

  config.vm.synced_folder "vagrant/", "/vagrant", type: "virtiofs"
end
VAGRANTFILE

vagrant up --provider libvirt

echo "List and connect to machine"
vagrant status

sudo chown $(whoami) $HOME/Git/RP2-KDSA/.vagrant/machines/default/libvirt/private_key
#vagrant ssh

#ssh vagrant@192.168.7.2 \
#  -i .vagrant/machines/default/libvirt/private_key
