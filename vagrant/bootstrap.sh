#!/bin/bash

### Disable Prompts.
#export DEBIAN_FRONTEND=noninteractive

sudo apt update -y
sudo apt upgrade -y 
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y
sudo apt autoclean -y
sudo apt install ubuntu-release-upgrader-core -y

sudo grub-install --boot-directory=/boot $(sudo lshw -C Disk | grep -Po 'logical name:\s\K.*')
sudo update-grub
debconf-show grub-pc


