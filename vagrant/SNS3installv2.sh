#!/bin/bash

ns3version="3.37"
ns3dir="/vagrant/sns3"

echo "Some commands require sudo priveleges"
echo "Creating sns3 directory under your home directory" 
#cd ~
mkdir -p $ns3dir

echo "Up[date/grade] OS components" 
sudo apt update; sudo apt upgrade -y; sudo apt dist-upgrade -y; sudo apt autoremove -y; sudo apt autoclean -y;

echo "install components for ns3"
#sudo apt install -y build-essential g++ cmake cmake-format clang libstdc++-10-dev libstdc++-11-dev python3 python3-dev pkg-config sqlite3 cmake python3-setuptools git qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 openmpi-bin openmpi-common openmpi-doc libopenmpi-dev autoconf cvs bzr unrar gsl-bin libgsl-dev libgslcblas0 wireshark tcpdump sqlite3 libsqlite3-dev  libxml2 libxml2-dev libc6-dev libc6-dev-i386 libclang-dev llvm-dev automake python3-pip libxml2 libxml2-dev libboost-all-dev libassimp-dev libgtk-3-dev libharfbuzz-dev

#sudo apt install g++ python3 cmake ninja-build git gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 tcpdump wireshark sqlite sqlite3 libsqlite3-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools openmpi-bin openmpi-common openmpi-doc libopenmpi-dev doxygen graphviz imagemagick python3-sphinx dia imagemagick texlive dvipng latexmk texlive-extra-utils texlive-latex-extra texlive-font-utils libeigen3-dev gsl-bin libgsl-dev libgslcblas0 libxml2 libxml2-dev libgtk-3-dev lxc-utils lxc-templates vtun uml-utilities ebtables bridge-utils libxml2 libxml2-dev libboost-all-dev ccache

sudo apt install build-essential autoconf automake libxmu-dev g++ python3 python3-dev pkg-config sqlite3 cmake python3-setuptools git qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 openmpi-bin openmpi-common openmpi-doc libopenmpi-dev autoconf cvs bzr unrar gsl-bin libgsl-dev libgslcblas0 wireshark tcpdump sqlite sqlite3 libsqlite3-dev  libxml2 libxml2-dev libc6-dev libc6-dev-i386 libclang-dev llvm-dev automake python3-pip libxml2 libxml2-dev libboost-all-dev 

echo "Clone and checkout ns3 $ns3version"
echo "See: https://gitlab.com/nsnam/ns-3-dev"
echo "See: https://www.nsnam.org/docs/release/3.42/installation/html/quick-start.html" 
#cd ~/sns3
cd $ns3dir
git clone https://gitlab.com/nsnam/ns-3-dev.git ns-$ns3version
cd $ns3dir/ns-$ns3version
git checkout -b ns-$ns3version-release ns-$ns3version

ls
sleep 3

echo "Uninstall ns-3 if any compilations exists"  
./ns3 uninstall
./ns3 clean

echo "Get satellite, traffic and magister-stats ns-3 modules"
cd $ns3dir/ns-$ns3version/contrib
git clone https://github.com/sns3/sns3-satellite.git satellite
git clone https://github.com/sns3/traffic.git traffic
git clone https://github.com/sns3/stats.git magister-stats

echo "Configure, build and sns-3"
cd $ns3dir/ns-$ns3version
./ns3 clean
./ns3 configure --build-profile=optimized --enable-examples --enable-tests
./ns3 build

echo "Post-Compilation" 
cd $ns3dir/ns-$ns3version/contrib/satellite
git submodule update --init --recursive

echo "Test SNS-3"
cd $ns3dir/ns-$ns3version
./test.py --no-build
echo "Installation completed"
