#!/bin/sh
nameprefix=cluster
netaddr=192.168.10
routeraddr=$netaddr.253
dnsaddr=$netaddr.251
baseaddr=150
nodelist='00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15'

#change hostname
cp hostname.org hostname
echo $nameprefix-$1 > hostname
#sudo cp hostname /etc/hostname

#set static IP adderss
myaddr=$netaddr.$(expr $baseaddr + $1)
cp dhcpcd.conf.org dhcpcd.conf
echo static ip_address=$myaddr/24 >> ./dhcpcd.conf
echo static routers=$routeraddr >> ./dhcpcd.conf
echo static domain_name_servers=$dnsaddr >> ./dhcpcd.conf
#sudo cp dhcpcd.conf /etc/dhcpcd.conf

#MPI node list
cp hosts.org hosts
echo 127.0.1.1 $nameprefix-$1 >> hosts
for nn in $nodelist
do
    echo $netaddr.$(expr $baseaddr + $nn) $nameprefix-$nn >> hosts
done
#sudo cp hosts /etc/hosts

#USB current 1[A]
cp config.txt.org config.txt
echo max_usb_current=1 >> config.txt
#sudo cp config.txt /boot/config.txt