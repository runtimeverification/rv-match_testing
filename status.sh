#!/bin/bash

# This file should be merged with run_set.sh as soon as possible.
# There should be an option to pass in a flag to control whether the tests are being ran or not.
# The code for parsing the .ini files is the same as generate_table, so that should be extracted and generalized.
cout="kcc_configure_out.txt"
mout="kcc_make_out.txt"
kout="kcc_config_k_summary.txt"
export="results/status.xml"
touch $export
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
echo '<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
<testsuite name="StatusScriptReport" package="StatusPackage">
<properties/>' > $export
get_info() {
    echo '<testcase classname="status.'${line/./"_"}'" name="'$compiler' '$infoname'">' >> $export
    infopath=$infofolder$infoname"_success.ini"
    result=$string_non_exist
    if [[ -e $infopath ]] ; then
        if [[ "$(head -n 1 $infopath)" == 0 ]] ; then
            result=$string_success
        else
            echo '<error message="Failed."></error>' >> $export
            result=$string_failed
        fi
    else
        echo '<skipped/>' >> $export
    fi
    if [[ $result == $string_failed ]]; then
        if [[ -e $infofolder$out ]]; then
            echo "$(tail -8 $infofolder$out)"
        else
            echo "$infofolder$out is supposed to be in the log folder."
        fi
    fi
    echo '</testcase>' >> $export
}

printresultforcompiler() {
    infofolder="tests/$line/$compiler/log/latest/"
    get_info
    #output+=$line'\t'$compiler$midstring$result'\n'
    echo $line" "$compiler$midstring$result
}
#output='\n'

while read line; do
    string_success="passed"
    string_failed="failed"
    string_non_exist="test did not occur"
    
    infoname="configure"
    midstring=" configuration "
    out=$cout
    compiler="gcc" ; printresultforcompiler
    compiler="kcc" ; printresultforcompiler
    
    infoname="make"
    midstring="        making "
    out=$mout
    compiler="gcc" ; printresultforcompiler
    compiler="kcc" ; printresultforcompiler

    string_success="not generated"
    string_failed="produced"
    string_non_exist="not checked for"
    
    infoname="no_kcc_config_generated"
    midstring="'s  kcc_config was "
    out=$kout
    compiler="gcc" ; get_info
    compiler="kcc" ; get_info

done < $whitelistpath

#echo -e $output
#printf $output'\n' | column -t

echo '</testsuite>
</testsuites>
' >> $export
