#!/bin/bash
############################################################################################
# Author: Rosen Georgiev a.k.a Subzer0 subzer0@abv.bg
# Description: Bash script looking for unknown hosts in your LAN
# Version: 0.07
# Date created: 07-Apr-2018
# Date modifyed:
# License: ABSOLUTELY FREE
# ABSOLUTELY NO WARANTIE it will find intruders...
############################################################################################

#by the first run this script will produce log file with no nodes
#it will compare this list and if any new MAC shows up will warn you
#again this is not profi tool, no WARANTIES it works for you
#tested on Ubuntu, Kali, Parrot...

############################################################################################

#some variales here could be modifyed by administrators taste

#empty string
toAdd=""

#commands needed separate by space
proGramS="sudo grep uniq sort arp-scan awk"

#logfile with the known hosts
cHeck=$(ls | grep knownHosts.log)

if  [[ !  -z  $cHeck  ]];then
	echo "Logfile $cHeck found."
else
	echo "Creating new log file!"
	touch knownHosts.log
fi

slogFile=knownHosts.log
logFile=$(cat "$slogFile" | sort -u)

############################################################################################

#action message if command exist
noaCtion="command is found."

#action messagee if command missing
aCtion="command is missing and will be installed!!!"

#check if needed command exist and install it

for p in $proGramS; do

	if sudo which "$p" > /dev/null 2>&1; then
		echo $p $noaCtion;
	else
		echo $p $aCtion;
		sudo apt-get update > /dev/null
		sudo apt-get -y install "$p" > /dev/null
	fi
done
############################################################################################

#find the active networks

activeNet=$(ip route|grep scope|awk '{print $1}')

############################################################################################

# the scanner

for n in $activeNet;
	do
	echo -e "\\n**************************************\\n* Scanning network: $n *\\n**************************************\\n"
	founD=$(
		sudo arp-scan $n | grep '^[0-9]\{3\}' | awk '{print substr ($0,index ($0,$2))}'
		)
	#echo "$founD"
		if  [[ !  -z  $founD  ]];then

			compaR=$(echo "$founD" | awk '{print $1}'| sort -u)
			newFoundMac=$(echo "$compaR" | diff "$slogFile" - | awk '/>/ {print $2}')&&

			if  [[ !  -z  $newFoundMac  ]];then

				newFoundDev=$(
					while EFS= read -r line
					do
    					echo "$founD" | grep "$line"
					done <<< "$newFoundMac"
					)
				echo -e "\\nFound UNKNOWN devices by MAC:\\n$newFoundDev\\n"
				toAdd="$toAdd$newFoundDev"
			else
				echo "Hmmm, Nothing to do!"
			fi
		else
			echo -e "\\nIn this network segment was\\nno UNKNOWN devices found\\n"
		fi

	done&&

############################################################################################

if  [[ !  -z  $newFoundMac  ]];then

	echo -e "Which of the following devices\\nyou want to add to $slogFile?\\n"

	toAddNew=$(echo "$toAdd"| uniq | nl)
	maxNum=$(echo "toAddNew" | awk 'END {print$1}')

	echo "$toAddNew"

	#unset choice
	#	while [[ ! ${choice} =~ ^[0-9]+$ || ${choice} =~ "A" ]];do

			echo -e "\\nPlease type the numbers separated\\nby space or A for All and press ENTER:"
			read choice
	#		! [[ ${choice} -ge 1 && ${choice} -le $maxNum || ${choice} == "A" ]] && unset choice
	#	done

	if [ "$choice" == "A" ];then
		if  [[ !  -z  $newFoundMac  ]];then
			echo "$newFoundMac" >> "$slogFile"
			echo "All Hosts added to $slogFile"
		else
			echo "Ooops! Nothing to do"
		fi
	else
		for s in $choice;
			do
			if  [[ !  -z  $toAddNew  ]];then
				kk=$(echo "$toAddNew" | awk "NR==$s {print}" | awk '{print$2}';)
				echo "$kk" | tee -a "$slogFile"
				echo "Line $s added to $slogFile"
			else
				echo "Ooops! Nothing to do"
			fi
			done
	fi
else
	echo "What a quiet network!"
fi
############################################################################################

#END

