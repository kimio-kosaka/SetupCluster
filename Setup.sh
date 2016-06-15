#!/bin/sh
if [ $1 = "" ]; then
    echo "nothing arg"
    exit 1
fi

sudo apt-get autoremove sonic-pi -y

#system update/upgrade
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y

#install opencv for python
sudo apt-get install -y libopencv-dev
sudo apt-get install -y python-opencv

#install MPI system
sudo apt-get install -y libcr-dev mpich2 mpich2-doc
sudo apt-get install -y python-mpi4py

#install vncserver
sudo apt-get install -y tightvncserver
sudo apt-get install -y libvncserver-dev
cp ./dispman_vncserver ~/

sudo apt-get install -y nfs-kernel-server
#sudo echo "/home/pi/mpi  *(rw,sync,fsid=0,crossmnt,no_subtree_check)" >>/etc/export

sudo apt-get install -y vim

#include nodesinfo
. ./nodesinfo.sh

# nodesinfo values of sample as below
# nameprefix=cluster
# netaddr=192.168.10
# routeraddr=$netaddr.253
# dnsaddr=$netaddr.251
# baseaddr=150
# nodelist='00 01 02 03 04 05 06 07 08 09 10 11 12 13 14'

#change hostname
cp hostname.org hostname
echo $nameprefix-$1 > hostname
sudo cp hostname /etc/hostname

#set static IP adderss
myaddr=$netaddr.$(expr $baseaddr + $1)
cp dhcpcd.conf.org dhcpcd.conf
echo static ip_address=$myaddr/24 >> ./dhcpcd.conf
echo static routers=$routeraddr >> ./dhcpcd.conf
echo static domain_name_servers=$dnsaddr >> ./dhcpcd.conf
sudo cp dhcpcd.conf /etc/dhcpcd.conf

#MPI node list
cp hosts.org hosts
echo 127.0.1.1 $nameprefix-$1 >> hosts
echo $netaddr.1 router >> hosts
echo $netaddr.2 fs >> hosts
for nn in $nodelist
do
    echo $netaddr.$(expr $baseaddr + $nn) $nameprefix-$nn >> hosts
done
sudo cp hosts /etc/hosts

#USB current 1.2[A] mode
cp config.txt.org config.txt
echo max_usb_current=1 >> config.txt
sudo cp config.txt  /boot/config.txt

mkdir ~/bullet
mkdir ~/.vnc
cp passwd ~/.vnc/
mkdir ~/.ssh
cp authorized_keys ~/.ssh/

