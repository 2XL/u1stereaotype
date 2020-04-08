#!/bin/bash 



echo "Setup dummy deim host"

if [ `whoami` = "root" ]
  then 
	echo "Running with GOD mode :D!"		
  else 	
	echo "Permission Denied!"
	exit 0
fi



echo "0 Start ssh service" 
/etc/init.d/ssh start



echo "1 Remove autoapaguin.sh" 

FILE_PATH="/usr/lib/milax-labdeim/autoapaguin.sh"
if [ -e "$FILE_PATH" ]
then
rm $FILE_PATH 
fi




echo "2 Montar la particion /dev/sda8 como home"
# Now you need to mount the drive to copy the contents of /home to the new drive. 
# I’ll use an empty directory called /mnt/sdb1 but you can create whatever directory you want.
TEMPDIR="/temporal"
TEMPPAR="/dev/sda8"
TEMP_MV="/home"
sudo mkdir $TEMPDIR
sudo mount -t auto $TEMPPAR $TEMPDIR

# Then you'll need to recursively copy everything under /home to this location!

cp -rp $TEMP_MV $TEMPDIR

# the 'r' flag means recurse
# the 'p' flat means preserve file permissions

# Once it's all copied, you can rename /home to something else


# todo cannot move home partition its busy
sudo mv $TEMP_MV "$TEMP_MV"_old

sudo umount $TEMPPAR

sudo mkdir $TEMP_MV

# edit fstab

echo "3 Update fstab"

FSTAB_STR="$TEMPPAR       $TEMP_MV           ext4    defaults        0       0" 



if grep -q "$FSTAB_STR" /etc/fstab
then 
echo "Already setup"
else
echo "Add to new entry to FSTAB"
sudo echo $FSTAB_STR>> /etc/fstab
fi



sudo mount -a # relad the fstab


# echo milax | sudo -S mount $TEMPPAR $TEMP_MV
  



# for persistent change:

# mount at system boot
# vi /etc/fstab
# add
# 	<file system> 	<mount point>   <type>  <options>       <dump>  <pass>
# echo 	$TEMPPAR 	$TEMP_MV 	ext4 	defaults 	0	2
#	/dev/sda8	/home		ext4	defaults	0	0
# dump is for dump cmd backup if not 0
# pass is for fsck cmd order of check, if 0 not check


# once the  file partition is mounted

# install vagrant and virtual box # 4.3.36 installado en la particion de GSX
#


echo "4 Install vagrant and virtualbox"
sudo apt-get update

# sudo apt-get install vagrant virtualbox -y


FILE_PATH_VBOX_URL="http://download.virtualbox.org/virtualbox/5.1.2/virtualbox-5.1_5.1.2-108956~Debian~jessie_amd64.deb"
FILE_PATH_VBOX="./virtualbox-5.1_5.1.2-108956~Debian~jessie_amd64.deb"
if [ -e "$FILE_PATH_VBOX" ]
then 
echo "file exists"
else
wget $FILE_PATH_VBOX_URL
fi

# sudo dpkg -i $FILE_PATH_VBOX





#
echo 'milax' | sudo -S echo "PATCH with virtualbox-5.0"
sudo apt-get remove -y milax-assignatures;

# cd ~/BenchBox/windows; vagrant destroy -f;
vv=$(VBoxManage --version)
echo sudo echo $vv
more /etc/apt/sources.list

$FILE_PATH_VBOX_LIST="/etc/apt/sources.list.d/vbox.list"
if [ -e "$FILE_PATH_VBOX_LIST" ]
then
echo "file exists"
else
echo "deb http://download.virtualbox.org/virtualbox/debian jessie contrib" | sudo tee -a /etc/apt/sources.list.d/vbox.list
fi
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update;
sudo apt-get install -y virtualbox-5.0;

VBoxManage --version
git pull
vagrant up

# <type of repository>  <location>  <dist-name> <components> 
# jessie-oficiales
# echo "deb http://mirrors.kernel.org/debian/ jessie main contrib non-free" | sudo tee -a /etc/apt/sources.list
# echo "deb-src http://mirrors.kernel.org/debian/ jessie main contrib non-free" | sudo tee -a /etc/apt/sources.list





















# sudo rm -r /home/milax/BenchBox


FILE_PATH_DEB_URL="https://releases.hashicorp.com/vagrant/1.7.3/vagrant_1.7.3_x86_64.deb"

FILE_PATH_DEB="./vagrant_1.7.3_x86_64.deb"
if [ -e "$FILE_PATH_DEB" ]
then
echo "file exists"
else
wget $FILE_PATH_DEB_URL
fi

sudo dpkg -i $FILE_PATH_DEB

# agafar el ip del manager y fer un put request amb la api de  mongodb

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py



echo "5 Register node to manager mongodb database"




# hostname fields


# LOGIN=`whoami`
LOGIN=milax
IP=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
HOSTNAME=`hostname`
NOTE="LAB_DEIM1"


if [ -z "$1" ]
then
echo "No additional parameters supplied, gracefull quit..."
else
echo "Register self to manager"
MANAGER_IP=$1
curl --data "hostname=$HOSTNAME&ip=$IP&logging=$LOGIN&note=$NOTE" "$MANAGER_IP:8888/hosts" 
fi

