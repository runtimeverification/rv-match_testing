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
echo "$currentscript Build number: ${BUILD_NUMBER}"
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
exportpath="$(pwd)/results/$exportfile.xml"
rm -f "$(pwd)/results/*.xml"
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
    if [ -z "${BUILD_NUMBER}" ] ; then
        logdate="$(date +%Y-%m-%d.%H:%M:%S)-$testname"
    else
        logdate="${BUILD_NUMBER}-$testname"
    fi
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
            log_output="/mnt/jenkins/logs/$logdate/${line}-all.log"
            touch $log_output
            chmod a+rw $log_output
            log_output_build="/mnt/jenkins/logs/$logdate/${line}-build.log"
            touch $log_output_build
            chmod a+rw $log_output_build
            log_output_test="/mnt/jenkins/logs/$logdate/${line}-test.log"
            touch $log_output_test
            chmod a+rw $log_output_test
            report_output="/mnt/jenkins/logs/$logdate/${line}-all.out"
            touch $report_output
            chmod a+rw $report_output
            report_output_build="/mnt/jenkins/logs/$logdate/${line}-build.out"
            touch $report_output_build
            chmod a+rw $report_output_build
            report_output_test="/mnt/jenkins/logs/$logdate/${line}-test.out"
            touch $report_output_test
            chmod a+rw $report_output_test
            json_out="/mnt/jenkins/logs/temp.json"
            rm -f $json_out ; touch $json_out ; export json_out ; chmod a+rw $json_out
            build_html="/mnt/jenkins/logs/$logdate/${line}-build-html" ; mkdir $build_html
            test_html="/mnt/jenkins/logs/$logdate/${line}-test-html" ; mkdir $test_html
            build_json="/mnt/jenkins/logs/$logdate/${line}-build.json"
            test_json="/mnt/jenkins/logs/$logdate/${line}-test.json"
            build_json_perm=$build_json ; test_json_perm=$test_json
            touch $build_json ; chmod a+rw $build_json
            touch $test_json  ; chmod a+rw $test_json
            
        else
            log_output="$(pwd)/logs/$logdate/${line}-all.log"
            log_output_build="$(pwd)/logs/$logdate/${line}-build.log"
            log_output_test="$(pwd)/logs/$logdate/${line}-test.log"
            report_output="$(pwd)/logs/$logdate/$line.out"
            html_out="$(pwd)/logs/$logdate/$line.html"
            json_out="$(pwd)/logs/temp.json"
            build_json="$(pwd)/logs/temp-build.json"
            test_json="$(pwd)/logs/temp-test.json"
            build_json_perm="$(pwd)/logs/$logdate/${line}-build.json"
            test_json_perm="$(pwd)/logs/$logdate/${line}-test.json"
            report_output_build="$(pwd)/logs/$logdate/${line}-build.out"
            report_output_test="$(pwd)/logs/$logdate/${line}-test.out"
            rm -f $json_out ; touch $json_out ; export json_out
        fi
        touch $log_output_build ; touch $log_output_test ; touch $build_json ; touch $test_json
        export build_json ; export test_json ; export log_output_build ; export log_output_test
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
    if [ ! "$testsfolder" == "selftest" ] ; then
        echo "build: $log_output_build"
        echo "test : $log_output_test"
        bash extract.sh $log_output $report_output
        bash extract.sh $log_output_build $report_output_build
        bash extract.sh $log_output_test $report_output_test
        head -n`grep -n "=========================" $report_output | grep -Eo '^[^:]+'` $report_output
        cp $test_json $test_json_perm
        cp $build_json $build_json_perm
        sudo rv-html-report $build_json -o $build_html ; chmod a+rw $build_json
        sudo rv-html-report $test_json -o $test_html ; chmod a+rw $test_json
    fi
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
