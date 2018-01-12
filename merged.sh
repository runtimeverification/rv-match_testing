#!/bin/bash

# Handle options
currentscript="<insert scriptname here>"
exportfile="report"
testsfolder="tests"
flagsfortests=""
while getopts ":rsau" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        flagsfortests="-r"
      ;;
    s ) echo $currentscript" status option selected."
        flagsfortests="STOP"
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
        flagsfortests="-a"
      ;;
    u ) echo $currentscript" unit-test-self option selected."
        testsfolder="selftest"
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s] [-a] [-u]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -u unit-test-self"
      ;;
  esac
done

# Handle .ini argument
filepath=$1
if [ ! -e $filepath ] ; then
    filepath=$2
fi

# Prepare state for proper loop
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

# Text input prep
cout="kcc_configure_out.txt"
mout="kcc_make_out.txt"
kout="kcc_config_k_summary.txt"

# XML Prep
suiteprefix="Report"
exportpath=$(pwd)"/results/$exportfile.xml"
mkdir $(dirname $exportpath) ; touch $exportpath
echo '<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
<testsuite name="'$suiteprefix'ScriptReport" package="'$suiteprefix'Package">
<properties/>' > $exportpath

# Function for extracting testcase output from log files, generalized to project and compiler
get_info() {
    infofolder="$testsfolder/$line/$compiler/build_log/latest/"
    timestring=''
    timepath=$infofolder$infoname"_time.ini"
    if [[ -e $timepath ]] ; then
        time="$(head -n 1 $timepath)" && timestring=' time="'$time'"'
    fi
    echo '<testcase classname="'$exportfile'.'${line/./"_"}'" name="'$compiler' '$infoname' success"'$timestring'>' >> $exportpath
    infopath=$infofolder$infoname"_success.ini"
    result=$string_non_exist
    let "$compiler$infoname += 1"
    if [[ -e $infopath ]] ; then
        if [[ "$(head -n 1 $infopath)" == 0 ]] ; then
            result=$string_success
            let "$compiler$infoname""s += 1"
        else
            echo '<error message="Failed.">' >> $exportpath
            result=$string_failed
            if [[ -e $infofolder$out ]]; then
                print="$(tail -20 $infofolder$out)"
            else
                print="$infofolder$out is supposed to be in the log folder."
            fi
            if [ "$out" == "$mout" ] ; then
                if [[ -e $infofolder$kout ]] ; then
                    
                    print=$print$'\n=========================\nList of the processed kcc_configs:\n\n'$(cat $infofolder$kout)
                fi
            fi
            echo '=====-- printf of $print'
            printf "$print" && echo ""
            echo '=====-- end printf'
            printf "<![CDATA[%s]]>" "$print" >> $exportpath
            echo '</error>' >> $exportpath
            let "$compiler$infoname""f += 1"
        fi
    else
        echo '<skipped/>' >> $exportpath
        echo $infopath" does not exist. Reporting skip."
        if [[ -d $infofolder ]] ; then
            echo ""$infofolder" exists."
        else
            echo ""$infofolder" does not exist."
        fi
    fi
    echo '</testcase>' >> $exportpath
    echo $line" "$compiler$midstring$result
}

read_log_files() {
    string_success="passed"
    string_failed="failed"
    string_non_exist="test did not occur"
    if [ ! $exportfile == "regression" ] && [ ! $exportfile == "acceptance" ] ; then
        infoname="configure"
        midstring=" configuration "
        out=$cout
        compiler="gcc" ; get_info
        compiler="kcc" ; get_info
    fi
    infoname="make"
    midstring="        making "
    out=$mout
    if [ ! $exportfile == "regression" ] ; then
        compiler="gcc" ; get_info
    fi
    compiler="kcc" ; get_info
    
    if [ ! $exportfile == "regression" ] && [ ! $exportfile == "acceptance" ] ; then
        string_success="not generated"
        string_failed="produced"
        string_non_exist="not checked for"
    
        infoname="no_kcc_config_generated"
        midstring="'s  kcc_config was "
        out=$kout
        compiler="gcc" ; get_info
        compiler="kcc" ; get_info
    fi
}

while read line; do
    if [ ! "$flagsfortests" == "STOP" ] ; then
        # Update container, if we're in one, with the jenkins test.sh
        if [ -e /mnt/jenkins/$testsfolder/$line/test.sh ] ; then
            # Branch is meant to run iff there is containerization.
            mkdir -p $testsfolder/$line/
            cp /mnt/jenkins/$testsfolder/$line/test.sh $testsfolder/$line/test.sh
        fi
        echo ==== $line started at $(date)
        bash "$testsfolder/$line/test.sh" "$flagsfortests"
        echo ==== $line finished at $(date)
    else
        echo "Status option was selected, so the tests are not being run right now."
    fi
    read_log_files
    cat "$testsfolder/$line/$exportfile.xml" >> $exportpath
done < $whitelistpath

# The above segment should:
# 1. Run script iff options command.
# 2. Obtain detailed build info for xml via this script.
# 3. Obtain unit test info for xml via prepare script.

# Display sums
echo "gcc success:"$gccmakes" fails:"$gccmakef" total:"$gccmake
echo "kcc success:"$kccmakes" fails:"$kccmakef" total:"$kccmake

# Conclude XML
echo '</testsuite>
</testsuites>
' >> $exportpath
echo "$exportpath file, produced by this script, is as follows:"
cat $exportpath
