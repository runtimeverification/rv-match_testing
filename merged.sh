#!/bin/bash

# Handle options
currentscript="merged.sh"
exportfile="report"
testsfolder="tests"
flagsfortests="-"
gcconly="1"
rvpredict="1"
while getopts ":rsatugpPb" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        flagsfortests=$flagsfortests"r"
      ;;
    s ) echo $currentscript" status option selected."
        flagsfortests="STOP"
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
        flagsfortests=$flagsfortests"a"
      ;;
    t ) echo $currentscript" unit testing option selected."
        flagsfortests=$flagsfortests"t"
      ;;
    u ) echo $currentscript" unit-test-self option selected."
        testsfolder="selftest"
      ;;
    g ) echo $currentscript" gcc only option selected."
        gcconly="0"
        flagsfortests=$flagsfortests"g"
      ;;
    p ) echo $currentscript" prepare option selected."
        flagsfortests=$flagsfortests"p"
      ;;
    P ) echo $currentscript" rv-predict option selected."
        rvpredict="0"
        flagsfortests=$flagsfortests"P"
      ;;
    b ) echo $currentscript" force build option selected."
        flagsfortests=$flagsfortests"b"
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s] [-a] [-t] [-u] [-g] [-p] [-P] [-b]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -u unit-test-self"
         echo " -g gcc only"
         echo " -p prepare only"
         echo " -P rv-predict"
         echo " -b force build"
      ;;
  esac
done
if [ "$flagsfortests" == "-" ] ; then
    flagsfortests=""
fi

# Handle .ini argument
isset="1"
testname=$1
if [ ! -e "sets/$testname.ini" ] && [ ! -e "tests/$testname/test.sh" ] ; then
    testname=$2
fi
if [ -e "sets/$testname.ini" ] ; then
    filepath="sets/$testname.ini"
    isset="0"
else
    if [ -e "tests/$testname/test.sh" ] ; then
        filepath="sets/_generated_single.ini"
        echo "$testname" > $filepath
    else
        echo "$testname is neither a set or test."
        exit 1
    fi
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
        if [ ! "$gcconly" == "0" ] && [ ! "$rvpredict" == "0" ] ; then
            compiler="kcc" ; get_info
        fi
        if [ ! "$gcconly" == "0" ] && [ "$rvpredict" == "0" ] ; then
            compiler="rvpc" ; get_info
        fi
    fi
    infoname="make"
    midstring="        making "
    out=$mout
    if [ ! $exportfile == "regression" ] ; then
        compiler="gcc" ; get_info
    fi
    if [ ! "$gcconly" == "0" ] && [ ! "$rvpredict" == "0" ] ; then
        compiler="kcc" ; get_info
    fi
    if [ ! "$gcconly" == "0" ] && [ "$rvpredict" == "0" ] ; then
        compiler="rvpc" ; get_info
    fi
    if [ ! $exportfile == "regression" ] && [ ! $exportfile == "acceptance" ] ; then
        string_success="not generated"
        string_failed="produced"
        string_non_exist="not checked for"
    
        infoname="no_kcc_config_generated"
        midstring="'s  kcc_config was "
        out=$kout
        # If I am not mistaken, the following commented line is unnecessary.
        #compiler="gcc" ; get_info
        if [ ! "$gcconly" == "0" ] && [ ! "$rvpredict" == "0" ] ; then
            compiler="kcc" ; get_info
        fi
    fi
}
if [ "$testsfolder" == "selftest" ] ; then
    logdate="selftest/$exportfile"
else
    logdate="$(date +%Y-%m-%d.%H:%M:%S)-$testname"
fi
mkdir -p logs/$logdate
if [ -d /mnt/jenkins/logs ] ; then
    mkdir -p /mnt/jenkins/logs/$logdate
    chmod -R a+rw /mnt/jenkins/logs/$logdate
fi
while read line; do
    if [ ! "$flagsfortests" == "STOP" ] ; then
        echo ""
        echo "==== $line  started at $(date)"
        if [ -d /mnt/jenkins/logs/$logdate ] ; then
            log_output="/mnt/jenkins/logs/$logdate/$line.log"
            touch $log_output
            chmod a+rw $log_output
        else
            log_output="logs/$logdate/$line.log"
        fi
        echo "     writing to log at $log_output"
        set -e ; rm -f "$testsfolder/$line/$exportfile.xml" ; set +e # prevents a false test report
        # 43200 seconds is 12 hours
        if [ "$isset" == "0" ] ; then
            bash timeout.sh -t 43200 bash "$testsfolder/$line/test.sh" "$flagsfortests" &> $log_output
        else
            bash timeout.sh -t 43200 bash "$testsfolder/$line/test.sh" "$flagsfortests" |& tee $log_output
        fi
        echo "==== $line finished at $(date)"
    else
        echo "Status option was selected, so the tests are not being run right now."
    fi
    #read_log_files
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
# The following perl script one liner was provided by users at URL:
# https://unix.stackexchange.com/questions/421286/how-to-printf-literal-characters-from-to-file-in-bash
# perl -C -pe 'tr/\x09\x0a\x0d\x20-\x{d7ff}\x{e000}-\x{fffd}\x{10000}-\x{10ffff}//cd' < $exportpath > $exportpath".tmp"
 perl -C -pe 'tr/\x{9}-\x{A}\x{D}-\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FDCF}\x{FE00}-\x{FFFD}\x{10000}-\x{1FFFD}\x{20000}-\x{2FFFD}\x{30000}-\x{3FFFD}\x{40000}-\x{4FFFD}\x{50000}-\x{5FFFD}\x{60000}-\x{6FFFD}\x{70000}-\x{7FFFD}\x{80000}-\x{8FFFD}\x{90000}-\x{9FFFD}\x{A0000}-\x{AFFFD}\x{B0000}-\x{BFFFD}\x{C0000}-\x{CFFFD}\x{D0000}-\x{DFFFD}\x{E0000}-\x{EFFFD}\x{F0000}-\x{FFFFD}\x{100000}-\x{10FFFD}//cd' < $exportpath > $exportpath".tmp"
 cp $exportpath".tmp" $exportpath
 echo "XML filter diff result:"
 diff $exportpath".tmp" $exportpath ; echo "$?"
 rm $exportpath".tmp"
echo "$exportpath file, produced by this script, is as follows:"
cat $exportpath
