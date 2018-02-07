#!/bin/bash
currentscript="guest_run.sh"
hostspace="/mnt/jenkins"
# This is the initial script ran from inside the lxc container.
# Called by: container_run.sh
# Calls    : libs.sh, run_set.sh

mainscript="mainscript_testing"
exportfile="report"
runsetparams=" -"
development_checkout_check="0"
echo "========= Beginning container guest scripts."
while getopts ":rsatdg" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        mainscript="mainscript_regression"
        exportfile="regression"
        runsetparams=$runsetparams"r"
      ;;
    s ) echo $currentscript" status option selected."
        mainscript="mainscript_status"
        exportfile="status"
        runsetparams=$runsetparams"s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        mainscript="mainscript_acceptance"
        exportfile="acceptance"
        runsetparams=$runsetparams"a"
      ;;
    t ) echo $currentscript" unit test option selected."
        runsetparams=$runsetparams"t"
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
if [ $runsetparams == " -" ] ; then
    runsetparams=""
fi

# Part 1: Basic container debug
echo "Entered container at: "$(pwd)
echo "Network test:"
ping -c 1 www.google.com

# Part 2 Configure Local Jenkins Dependencies
#  2a Copy project scripts
cd /root/
rm -rf rv-match_testing/
git clone https://github.com/runtimeverification/rv-match_testing.git
cd rv-match_testing/
#echo "Wanting to use git sha: ""$(head -n 1 $hostspace/githash.ini)"
#git checkout "$(head -n 1 $hostspace/githash.ini)"
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
#cp *.sh /root/
#mkdir /root/sets/
#cp -r sets/* /root/sets/

#  2b Set kcc dependencies
# Here we copy kcc dependencies from jenkins workspace to the container
#cd /root/
#rm -r kcc_dependency_1/
#rm -r kcc_dependency_2/
#rm -r kcc_dependency_3/bin/
#cp -r $hostspace/kcc_dependency_1/ kcc_dependency_1/
#cp -r $hostspace/kcc_dependency_2/ kcc_dependency_2/
#cp -r $hostspace/kcc_dependency_3/ kcc_dependency_3/
#export PATH=/root/kcc_dependency_1:/root/kcc_dependency_2:/root/kcc_dependency_3/bin:$PATH
#echo "The modified container PATH variable: "$PATH

# Switching soon to using installer instead of direct file copies.
# https://github.com/runtimeverification/rv-match/blob/master/installer-linux/scripts/install-in-container

bash libs.sh
sudo rm /var/lib/dpkg/lock
sudo apt-get -y install default-jre
mv rv-match-linux-64-1.0-SNAPSHOT.jar rv-match-linux-64-1.0-SNAPSHOT.jar.old
wget https://runtimeverification.com/match/1.0/rv-match-linux-64-1.0-SNAPSHOT.jar
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
echo "<Checking for proper rv-match installation and starting kserver>"
which k-bin-to-text
which kserver
which kcc
kserver &
echo "</Checking for proper rv-match installation and starting kserver>"

# Part 3 Run Main Script
mainscript_testing() {
    #echo "Running self unit tests now:"
    #bash unit_test_merged.sh
    #bash libs.sh
    #bash tests/getty/test.sh
    #bash merged.sh sets/crashless.ini
    #bash merged.sh sets/temporary.ini
    #bash merged.sh sets/interesting.ini
    #bash merged.sh sets/quickset.ini
    #cp results/status.xml $hostspace/results/
    #bash merged.sh sets/minuteset.ini
}
mainscript_regression() {
    bash libs.sh
    #bash run_regression_set.sh sets/regression.ini
    # The following line should be the one used after issue 14 is fixed.
    bash merged.sh$runsetparams sets/regression.ini
    #bash merged.sh$runsetparams sets/temporary.ini
}
mainscript_status() {
    bash merged.sh$runsetparams sets/crashless.ini
}
mainscript_acceptance() {
    bash libs.sh
    bash merged.sh$runsetparams sets/acceptance.ini
    #bash merged.sh$runsetparams sets/acceptance_and_regression.ini
}
echo "Debug location."
pwd
ls
cd /root/rv-match_testing && ls && $mainscript

# Part 4 Copy test result xml back to host
echo "Container results are in "$exportfile".xml:"
cat results/$exportfile.xml
echo "Copying results to host now."
cp results/$exportfile.xml $hostspace/results/ && rm results/$exportfile.xml
echo "========== Finished container guest scripts."
