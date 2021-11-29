#!/bin/bash

echo "This script will install all depdendencies for the native toolchain for Contiki-NG"

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
echo "Allow non-root packet capture in Wireshark"
echo "============================================================"
sudo usermod -a -G wireshark $USER

# Create the installation folder
mkdir ~/.native-contiking
cd ~/.native-contiking

# Install Arm compiler
ARM_COMPILER="gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux"
ARM_COMPILER_URI="https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2020q2/$ARM_COMPILER.tar.bz2"
echo "Install the Arm compiler"
echo "============================================================"
wget $ARM_COMPILER_URI
if [ $? -ne 0]; then
  echo "Failed to retrieve Arm compiler."
  exit 1;
fi
tar -xjf $ARM_COMPILER.tar.bz2
echo "export PATH=$PATH:~/.native-contiking/$ARM_COMPILER/bin" >> ~/.bashrc

