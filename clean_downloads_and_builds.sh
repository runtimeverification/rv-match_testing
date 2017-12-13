#!/bin/bash

# This file should be merged with run_set.sh as soon as possible.
# There should be an option to pass in a flag to control whether the tests are being ran or not.
# The code for parsing the .ini files is the same as generate_table, so that should be extracted and generalized.

filepath=$1
file=$(basename $filepath)
setfolder=$(basename $(dirname $filepath))"/"
echo "filepath is: "$filepath
echo "file is    : "$file
echo "folder is  : "$setfolder
allpath=$setfolder"_generated_all.ini"
blacklist_indicator="BLACKLIST"
filename=${file%.*}
blacklist_check=$(head -n 1 $filepath)
echo "First line of file: "$blacklist_check
echo "Name without extension: "$filename
echo "=============="
whitelistpath=$filepath
if [ $blacklist_check == $blacklist_indicator ]; then
    bash generate_run_set.sh
    whitelistpath=$setfolder"_generated_"$filename"_whitelist.ini"
    touch $whitelistpath
    grep -f $filepath -v -F -x $allpath > $whitelistpath
fi
while read line; do
    rm -rf "tests/$line/download/"
    rm -rf "tests/$line/gcc/build/"
    rm -rf "tests/$line/kcc/build/"
done < $whitelistpath

#echo -e $output
#printf $output'\n' | column -t
