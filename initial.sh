#!/bin/sh

#################################################################
#								#
#	Shell script for initial setup ThinCore Linux		#
#	on Thin Client SA10 and SA22				#
#	Author: Rosen Georgiev (a.k.a Subzer0) W0405552		#
#	Version: 0.01	Date: 05/31/2018			#
#	Contact: Subzer0@abv.bg					#
#								#
#################################################################

uSer=buadmin
pAssword=Passw0rd
iPaddress=$(ifconfig eth0 | awk '{print $2}' | egrep -o '([0-9]+\.){3}[0-9]+')

#add user $uSer
echo -e "$pAssword\n$pAssword\n" | sudo adduser -G staff $uSer &&

#change passwd for tc
sudo echo tc:$pAssword | sudo chpasswd &&

#inastall nano
tce-load -wi nano.tcz &
wait

#link vi
sudo ln -s /bin/vi /usr/bin/vi

#install openssh
tce-load -wi openssh.tcz &
wait
sudo cp /usr/local/etc/ssh/sshd_config.example >> /usr/local/etc/ssh/sshd_config &&

#add openssh to start
sudo echo '/usr/local/etc/init.d/openssh start &' >> /opt/bootlocal.sh &&

#add etc to .filetool.lst
sudo echo 'etc' >> /opt/.filetool.lst &&

#add usr to 
sudo echo 'usr' >> /opt/.filetool.lst &&

#start ssh
sudo /usr/local/etc/init.d/openssh start &
wait

#backup
sudo filetool.sh -b &
wait

echo -e "\n************************************************"
echo -e "\n* You may connect this host now using command: *"
echo -e "\n*           ssh $uSer@$iPaddress               *"
echo -e "\n*         with password: $pAssword             *"
echo -e "\n*       Cheers Rosen (a.k.a Subzer0)           *"
echo -e "\n************************************************\n"
