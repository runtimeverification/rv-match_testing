#!/bin/bash

# This file should be merged with run_set.sh as soon as possible.
# There should be an option to pass in a flag to control whether the tests are being ran or not.
# The code for parsing the .ini files is the same as generate_table, so that should be extracted and generalized.

cout="kcc_configure_out.txt"
mout="kcc_make_out.txt"
kout="kcc_config_k_summary.txt"
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
get_info() {
    infopath=$infofolder$infoname"_success.ini"
    result=$string_non_exist
    if [[ -e $infopath ]] ; then
        if [[ "$(head -n 1 $infopath)" == 0 ]] ; then
            result=$string_success
        else
            result=$string_failed
        fi
    fi
}
printresultforcompiler() {
    infofolder="tests/$line/$compiler/log/latest/"
    get_info
    output+=$line'\t'$midstring$result'\n'
}
output='\n'
while read line; do
    string_success="passed"
    string_failed="failed"
    string_non_exist="test did not occur"
    
    infoname="configure"
    midstring=" configuration "
    compiler="gcc" ; printresultforcompiler
    if [[ $result == $string_failed ]]; then echo $(tail -5 $infofolder$cout); fi
    compiler="kcc" ; printresultforcompiler
    if [[ $result == $string_failed ]]; then echo $(tail -5 $infofolder$cout); fi
    
    infoname="make"
    midstring="        making "
    compiler="gcc" ; printresultforcompiler
    if [[ $result == $string_failed ]]; then echo $(tail -5 $infofolder$mout); fi
    compiler="kcc" ; printresultforcompiler
    if [[ $result == $string_failed ]]; then echo $(tail -5 $infofolder$mout); fi

    string_success="not generated"
    string_failed="produced"
    string_non_exist="not checked for"
    
    infoname="no_kcc_config_generated"
    midstring="'s  kcc_config was "
    compiler="gcc" ; get_info
    compiler="kcc" ; get_info
    if [[ -e $infofolder/$kout ]]; then echo $infofolder$kout; fi

done < $whitelistpath

echo -e $output
printf $output'\n' | column -t
