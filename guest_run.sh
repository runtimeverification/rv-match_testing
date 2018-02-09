#!/bin/bash
currentscript="guest_run.sh"
hostspace="/mnt/jenkins"
# This is the initial script ran from inside the lxc container.
# Called by: container_run.sh
# Calls    : libs.sh, run_set.sh

exportfile="report"
runsetparams=" -"
development_checkout_check="0"
unittestsetprefix=""
hadflag="1"
echo "========= Beginning container guest scripts."
while getopts ":rsatdg" opt; do
  hadflag="0"
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        runsetparams=$runsetparams"r"
      ;;
    s ) echo $currentscript" status option selected."
        exportfile="status"
        runsetparams=$runsetparams"s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
        runsetparams=$runsetparams"a"
      ;;
    t ) echo $currentscript" unit test option selected."
        runsetparams=$runsetparams"t"
        unittestsetprefix="unit_"
      ;;
    d ) echo $currentscript" development option selected."
        development_checkout_check="1"
      ;;
    g ) echo $currentscript" gcc only option selected."
        runsetparams=$runsetparams"g"
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s] [-a] [-t] [-d] [-g]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d development"
         echo " -g gcc only"
      ;;
  esac
done
if [ "$runsetparams" == " -" ] ; then
    runsetparams=""
fi
if [ "$hadflag" == "0" ] ; then
    runsetparams="$runsetparams $2"
else
    runsetparams="$runsetparams $1"
fi

# Part 1: Basic container debug
echo "Entered container at: "$(pwd)

printf "\n<$currentscript assert network>\n"
set -e
ping -c 1 www.google.com
set +e
echo "</$currentscript assert network>"

printf "\n<$currentscript assert k-bin-to-text>\n"
export PATH=/root/rv-match/k/k-distribution/target/release/k/bin:$PATH
k-bin-to-text ; testout=$(echo "$?")
set -e
printf "\n  'which' test:\n"
which k-bin-to-text
printf "\n  'return value with empty arguments is 1' test:\n"
[ "$testout" == "1" ]
set +e
echo "</$currentscript assert k-bin-to-text>"
# /Part 1: Basic container debug

# Part 2 Configure Local Jenkins Dependencies
#  2a Copy project scripts
cd /root/
rm -rf rv-match_testing/
git clone https://github.com/runtimeverification/rv-match_testing.git
cd rv-match_testing/
gitbranch="master"
if [ "$development_checkout_check" == "1" ] ; then
    echo "Git branch development checked out."
    gitbranch="development"
else
    echo "Git branch master checked out."
fi
git checkout $gitbranch
git reset --hard origin/$gitbranch
git checkout $gitbranch
git pull

# https://github.com/runtimeverification/rv-match/blob/master/installer-linux/scripts/install-in-container
cd /root/
mv rv-match-linux-64-1.0-SNAPSHOT.jar rv-match-linux-64-1.0-SNAPSHOT.jar.old
wget -q https://runtimeverification.com/match/1.0/rv-match-linux-64-1.0-SNAPSHOT.jar
diff rv-match-linux-64-1.0-SNAPSHOT.jar rv-match-linux-64-1.0-SNAPSHOT.jar.old ; checknew="$?"
kcc -v ; checkinstalled="$?"
if [ "$checknew" == "0" ] && [ "$checkinstalled" == "0" ] ; then
    echo "Not installing rv-match since two criterion hold:"
    echo "1. Already downloaded .jar matches the new."
    echo "2. \"kcc -v\" functions."
    echo "We are assuming based on that that rv-match is already installed and updated to the latest version."
else
    if [ "$checknew" == 0 ] ; then
        echo "\"kcc -v\" doesn't function, even though the new version matches the old."
        echo "Therefore, we will attempt install of rv-match."
    else
        echo "Either the new rv-match differs from the old or the old doesn't exist, so we will install it."
    fi
    printf "
1


1
y
1
1
" > stdinfile.txt
    cat stdinfile.txt | java -jar rv-match-linux-64*.jar -console ; rm stdinfile.txt
fi

echo "<$currentscript assert self-unit-tests>"
cd /root/rv-match_testing
bash unit_test_merged.sh &> selfunittest.log ; testout=$(echo "$?")
if [ "$testout" == "0" ] ; then
    echo "  self-unit-tests all passed."
else
    if [ "$testout" == "1" ] ; then
        echo "  self-unit-test(s) failed."
    else
        echo "  self-unit-tests did not process properly."
    fi
    cat selfunittest.log
fi
set -e
[ "$testout" == "0" ]
set +e
echo "</$currentscript assert self-unit-tests>"

# Part 3 Run Main Script
echo "Debug location."
pwd
ls
cd /root/rv-match_testing && ls && bash merged.sh$runsetparams

# Part 4 Copy test result xml back to host
echo "Container results are in "$exportfile".xml:"
cat results/$exportfile.xml
echo "Copying results to host now."
cp results/$exportfile.xml $hostspace/results/ && rm results/$exportfile.xml
echo "========== Finished container guest scripts."
