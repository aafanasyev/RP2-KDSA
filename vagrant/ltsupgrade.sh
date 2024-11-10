#!/bin/bash

###Configure available releases to LTS.
# sudo apt-get install -y --no-install-recommends -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' login_4.13+dfsg1-4ubuntu3.2_amd64.deb
# https://serverfault.com/a/839563
sudo apt-get --yes --force-yes -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confnew" upgrade
sudp apt-get --yes --force-yes -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confnew" dist-upgrade

echo "Set upgrade to LTS"
sudo sed -i 's/Prompt=never/Prompt=lts/g' /etc/update-manager/release-upgrades
sudo cat /etc/update-manager/release-upgrades

sudo do-release-upgrade -p "24.04.1" -f DistUpgradeViewNonInteractive

sudo lsb_release -a
sudo hostnamectl set-hostname u2404

