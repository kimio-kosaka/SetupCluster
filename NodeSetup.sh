#!/bin/sh
mkdir ~/bullet
mkdir ~/.vnc
cp passwd ~/.vnc/
mkdir ~/.ssh
cp authorized_keys ~/.ssh/
#USB current 1.2[A] mode
cp config.txt.org config.txt
echo max_usb_current=1 >> config.txt
sudo cp config.txt  /boot/config.txt