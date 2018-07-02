#!/usr/bin/env bash

#####################################################
# bash script comparing two (eg wordlist) files and #
# adding missing lines to the master file           #
#                                                   #
# Author: Rosen Georgiev aka Subzer0                #
# Date: June/16/2018                                #
# Version: 0.01                                     #
# License: Freeeeee                                 #
# Warranty: ABSOLUTELY NO ANY WARRANTY !!!          #
# Contact: subzer0@abv.bg                           #
#                                                   #
#####################################################

# USAGE run this script followed by FILEPATH1 (your new wordlist) FILEPATH2 (your own wordlist)

# ENJOY IT!

clear

filenamefrom="$1"

filenameto="$2"

aline=$(wc -l < $filenamefrom)
bline=0
cline=0

# uncomment next lines just if you know what I'm doing
# this will look if you already have updated your file once
# and will replace it

if [ $filenameto.new ]; then

    echo "Modifyed file found, will replace it!!!"
    cp -r $filenameto $filenameto.backup
    cp -r $filenameto.new $filenameto
fi

touch ${filenameto}.tmp



# the code:

while read -r line
do
    proc=$((aline-bline))
    proca1=$((100*bline/aline))


    clear
    echo "Start comparing files... depends on your files, will take a while..."
    echo "Checking Line number: $bline payload: $line"
    echo "Have to check: $proc lines more"
    echo "Process: $proca1 %"
    echo "Lines added so far: $cline"

    word=$(grep -c -w "$line" ${filenameto})
    bline=$(( $bline + 1 ))


    if [ ${word} -eq 0 ]; then
        sudo echo ${line} >> ${filenameto}.tmp
        cline=$(( $cline + 1 ))
        echo "line $cline $line added to the file"

    fi

done < "$filenamefrom"

echo "Sorting files"
sort ${filenameto} | uniq -u > ${filenameto}.new
sort ${filenameto}.tmp | uniq -u >> ${filenameto}.new
sort ${filenameto}.new &>/tmp/null

rm -r ${filenameto}.tmp

echo "Done!!! New $cline lines added"
echo "Your new file is ${filenameto}.new"
echo "Cheers, Subzer0"
