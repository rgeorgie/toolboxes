#!/usr/bin/env bash

#####################################################
# bash script automatizing some tasks around LXC    #
# running containers                                #
#                                                   #
# Author: Rosen Georgiev aka Subzer0                #
# Date: July/02/2018                                #
# Version: 0.01                                     #
# License: Freeeeee                                 #
# Warranty: ABSOLUTELY NO ANY WARRANTY !!!          #
# Contact: subzer0@abv.bg                           #
#                                                   #
#####################################################

for container in $(lxc list volatile.last_state.power=RUNNING -c n | awk 'NR>2 {print $2}' | awk NF); do

    echo "-----------------------------";
    echo "${container}";
    echo "-----------------------------";

    lxc exec ${container} apt update
    lxc exec ${container} apt upgrade -y
    lxc exec ${container} apt autoremove -y

done