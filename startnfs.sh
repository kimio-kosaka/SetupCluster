!/bin/sh

. ./nodesinfo.sh
# sample nodesinfo
# nameprefix=cluster
# netaddr=192.168.10
# routeraddr=$netaddr.253
# dnsaddr=$netaddr.251
# baseaddr=150
# nodelist='00 01 02 03 04 05 06 07 08 09 10 11 12 13 14'

sudo service rpcbind start
sudo service nfs-common start
sudo service nfs-kernel-server start
sleep 1
for nn in $nodelist
do
    if [ "$nn" -ne 00 ] ;then
        ssh pi@$nameprefix-$nn "sudo mount -t nfs $nameprefix-00:/home/pi/bullet ~/bullet"
    fi
done
