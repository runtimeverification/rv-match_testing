#!/bin/bash
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
  echo ==== $line started at $(date)
  bash tests/$line/test.sh
  echo ==== $line finished at $(date)
done < $whitelistpath
