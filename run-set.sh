#!/bin/bash

# Handle options
currentscript="run-set.sh"
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
if [ "$flagsfortests" == "-" ] ; then flagsfortests="" ; fi

# Handle (set|project) argument
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

# Define the project set as a whitelist
whitelistpath=$filepath
if [ "$(head -n 1 $filepath)" == "BLACKLIST" ]; then
    bash generate_run_set.sh
    file=$(basename $filepath)
    setfolder=$(basename $(dirname $filepath))"/"
    whitelistpath=$setfolder"_generated_${file%.*}_whitelist.ini"
    grep -f $filepath -v -F -x $setfolder"_generated_all.ini" > $whitelistpath
fi

# XML Head
suiteprefix="Report"
exportpath=$(pwd)"/results/$exportfile.xml"
exportpathtemp="$exportpath.tmp"
mkdir $(dirname $exportpath)
echo '<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
<testsuite name="'$suiteprefix'ScriptReport" package="'$suiteprefix'Package">
<properties/>' > $exportpathtemp

# Create (set|project) single run instance log folder on host
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
            report_output="/mnt/jenkins/logs/$logdate/$line.out"
            touch $report_output
            chmod a+rw $report_output
            json_out="/mnt/jenkins/logs/temp.json"
            chmod a+rw $json_out
            html_out="/mnt/jenkins/logs/$logdate/""$line""-html"
            mkdir $html_out
        else
            log_output="logs/$logdate/$line.log"
            report_output="logs/$logdate/$line.out"
            html_out="logs/$logdate/$line.html"
            json_out="logs/temp.json"
        fi
        rm -f $json_out ; touch $json_out ; export json_out
        echo "     logged at $log_output"
        set -e ; rm -f "$testsfolder/$line/$exportfile.xml" ; set +e # prevents a false test report
        if [ "$isset" == "0" ] ; then
            bash timeout.sh -t 43200 bash "$testsfolder/$line/test.sh" "$flagsfortests" &> $log_output
        else
            bash timeout.sh -t 43200 bash "$testsfolder/$line/test.sh" "$flagsfortests" |& tee $log_output
        fi
    else
        echo "Status option was selected, so the tests are not being run right now."
    fi
    cat "$testsfolder/$line/$exportfile.xml" >> $exportpathtemp
    bash extract.sh $log_output $report_output
    head -n`grep -n "=========================" $report_output | grep -Eo '^[^:]+'` $report_output
    sudo rv-html-report $json_out -o $html_out ; rm -f $json_out
done < $whitelistpath
echo "==== tests finished at $(date)"

# XML Foot
echo '</testsuite>
</testsuites>
' >> $exportpathtemp

# Remove non-XML-parsable characters
# https://unix.stackexchange.com/questions/421286/how-to-printf-literal-characters-from-to-file-in-bash
# 'tr/\x09\x0a\x0d\x20-\x{d7ff}\x{e000}-\x{fffd}\x{10000}-\x{10ffff}//cd'
perl -C -pe 'tr/\x{9}-\x{A}\x{D}-\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FDCF}\x{FE00}-\x{FFFD}\x{10000}-\x{1FFFD}\x{20000}-\x{2FFFD}\x{30000}-\x{3FFFD}\x{40000}-\x{4FFFD}\x{50000}-\x{5FFFD}\x{60000}-\x{6FFFD}\x{70000}-\x{7FFFD}\x{80000}-\x{8FFFD}\x{90000}-\x{9FFFD}\x{A0000}-\x{AFFFD}\x{B0000}-\x{BFFFD}\x{C0000}-\x{CFFFD}\x{D0000}-\x{DFFFD}\x{E0000}-\x{EFFFD}\x{F0000}-\x{FFFFD}\x{100000}-\x{10FFFD}//cd' < $exportpathtemp > $exportpath
rm $exportpathtemp

# XML to console
echo "$currentscript produced $exportpath:"
cat $exportpath
