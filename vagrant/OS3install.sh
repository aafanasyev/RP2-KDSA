#!/bin/bash

os3version="3.37"
os3dir="~/vagrant/os3"

echo "Some commands require sudo priveleges"
echo "Creating os3 directory under your home directory" 
#cd ~
mkdir -p $os3dir
cd $os3dir

echo "Up[date/grade] OS components" 
sudo apt update; sudo apt upgrade -y; sudo apt dist-upgrade -y; sudo apt autoremove -y; sudo apt autoclean -y;

echo "Install required dependencies for OS3"

sudo apt -y install build-essential clang lld gdb bison flex perl \
python3 python3-pip qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
libqt5opengl5-dev libxml2-dev zlib1g-dev doxygen graphviz \
libwebkit2gtk-4.0-37 xdg-utils libopenscenegraph-dev mpi-default-dev

python3 -m pip install --user --upgrade numpy pandas matplotlib scipy \
seaborn posix_ipc

wget -O "https://github.com/omnetpp/omnetpp/releases/download/omnetpp-6.0.3/omnetpp-6.0.3-core.tgz"
tar xvfz omnetpp-6.0.3-core.tgz
cd omnetpp-6.0.3
source setenv

./configure
make clean
make

