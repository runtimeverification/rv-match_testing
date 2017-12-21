#!/bin/bash
filepath=$1
file=$(basename $filepath)
setfolder=$(basename $(dirname $filepath))"/"
allpath=$setfolder"_generated_all.ini"
blacklist_indicator="BLACKLIST"
filename=${file%.*}
blacklist_check=$(head -n 1 $filepath)
whitelistpath=$filepath
if [ $blacklist_check == $blacklist_indicator ]; then
    bash generate_run_set.sh
    whitelistpath=$setfolder"_generated_"$filename"_whitelist.ini"
    touch $whitelistpath
    grep -f $filepath -v -F -x $allpath > $whitelistpath
fi
mkdir results/
full_report=$(pwd)"/results/regression.xml"
echo '<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
<testsuite name="ReportScriptReport" package="ReportPackage">
<properties/>' > $full_report
while read line; do
  if [ ! -e tests/$line/test.sh ] ; then
    mkdir -p tests/$line/
    cp /mnt/jenkins/tests/$line/test.sh tests/$line/test.sh
  fi
  cp tests/$line/test.sh tests/$line/test_regression.sh
  sed -i -e 's/prepare.sh/prepare_regression.sh/g' tests/$line/test_regression.sh
  bash tests/$line/test_regression.sh
  cat "tests/$line/report.xml" >> $full_report
done < $whitelistpath
echo '</testsuite>
</testsuites>
' >> $full_report
