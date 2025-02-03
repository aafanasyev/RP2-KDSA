#!/bin/bash

### Disable Prompts.
export DEBIAN_FRONTEND=noninteractive

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
#dpkg-reconfigure locales

echo "##################################
      ###
      ### Update Ubuntu 22.04 LTS VM
      ###
      ##################################"

sudo dpkg-reconfigure debconf -f noninteractive -p critical

sudo apt-get update -y
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confnew" upgrade
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confnew" dist-upgrade
sudo apt-get autoremove --purge -y
sudo apt-get autoclean -y
sudo apt-get install ubuntu-release-upgrader-core -y

#sudo grub-install --boot-directory=/boot $(sudo lshw -C Disk | grep -Po 'logical name:\s\K.*')
#sudo update-grub
#debconf-show grub-pc


