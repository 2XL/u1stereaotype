#!/bin/bash



echo "milax" | sudo -S echo "Hello"
sudo rm -r /etc/NetworkManager/system-connections/*
sudo ip link del docker0

# ls /etc/network/interfaces 
#if [ $? -eq 0 ]; then
#rm /etc/network/interfaces
#fi
# rm /tmp/interfaces
echo "auto lo" > /tmp/interfaces
echo "iface lo inet loopback" >> /tmp/interfaces
echo "" >> /tmp/interfaces
echo "auto eth0" >> /tmp/interfaces
echo " iface eth0 inet dhcp" >> /tmp/interfaces
echo "" >> /tmp/interfaces
echo "" >> /tmp/interfaces
echo "auto eth1" >> /tmp/interfaces
echo " iface eth1 inet dhcp" >> /tmp/interfaces
echo "" >> /tmp/interfaces
echo "" >> /tmp/interfaces
echo "auto eth2" >> /tmp/interfaces
echo " iface eth2 inet dhcp" >> /tmp/interfaces
echo "" >> /tmp/interfaces

echo "Updated interfaces file"

echo "milax" | sudo -S mv /tmp/interfaces /etc/network/interfaces
sudo chown root:root /etc/network/interfaces
sudo service network-manager restart
sudo service networking restart


echo "Restarted connections"

more /etc/network/interfaces

echo "Wait time"
sleep 5

echo "`hostname -I` `hostname `" >> hosts



