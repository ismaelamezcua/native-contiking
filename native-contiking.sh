#!/bin/bash

CONTIKI_INSTALL_DIR="~/.native-contiki"

echo "This script will install all dependencies for the native tool-chain for Contiki-NG"

# System update
echo "Updating your system..."
echo "============================================================"
#sudo apt update

# Required packages
echo "Installing required packages..."
echo "============================================================"
for package in build-essential doxygen git curl wireshark python3-serial srecord rlwrap; do
  sudo apt install $package
done

# Wireshark non-superuser capture packets
echo "Allowing non-root packet capture in Wireshark"
echo "============================================================"
sudo usermod -a -G wireshark $USER

# Create the installation folder
mkdir $CONTIKI_INSTALL_DIR
cd $CONTIKI_INSTALL_DIR

# Install Arm compiler
ARM_COMPILER="gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux"
ARM_COMPILER_URI="https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2020q2/$ARM_COMPILER.tar.bz2"
echo "Installing the Arm compiler"
echo "============================================================"
wget $ARM_COMPILER_URI
if [ $? -ne 0]; then
  echo "Failed to retrieve Arm compiler."
  exit 1;
fi
tar -xjf $ARM_COMPILER.tar.bz2
echo "export PATH=$PATH:$CONTIKI_INSTALL_DIR/$ARM_COMPILER/bin" >> ~/.bashrc

echo "Installing OpenJDK and configuring Java"
echo "============================================================"
sudo apt install default-jdk ant
update-alternatives --config java
echo 'export JAVA_HOME="/usr/lib/jvm/default-java"' >> ~/.profile

echo "Configuring user access to USB"
echo "============================================================"
sudo usermod -a -G plugdev $USER
sudo usermod -a -G dialout $USER
echo 'ATTRS{idVendor}=="0451", ATTRS{idProduct}=="16c8", ENV{ID_MM_DEVICE_IGNORE}="1"' >> /lib/udev/rules.d/77-mm-usb-device-blacklist.rules

echo "Native tool-chain installation has completed."
echo "You can clone the Contiki-NG repository now."
echo "============================================================"

