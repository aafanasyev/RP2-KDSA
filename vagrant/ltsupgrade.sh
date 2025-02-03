#!/bin/bash

###Configure available releases to LTS.
# sudo apt-get install -y --no-install-recommends -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' login_4.13+dfsg1-4ubuntu3.2_amd64.deb
# https://serverfault.com/a/839563

echo "#######################################
      ###
      ### Upgrade to the Ubuntu 24.04 LTS VM
      ###
      #######################################"

sudo apt-get --yes -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confnew" upgrade
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confnew" dist-upgrade

echo "Set upgrade to LTS"
sudo sed -i 's/Prompt=never/Prompt=lts/g' /etc/update-manager/release-upgrades
sudo cat /etc/update-manager/release-upgrades

sudo do-release-upgrade -p "24.04.1" -f DistUpgradeViewNonInteractive

sudo grub-install --boot-directory=/boot $(sudo lshw -C Disk | grep -Po 'logical name:\s\K.*')
sudo update-grub
debconf-show grub-pc

sudo lsb_release -a
sudo hostnamectl set-hostname u2404

