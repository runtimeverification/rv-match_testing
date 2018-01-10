#!/bin/bash
currentscript="guest_run.sh"
hostspace="/mnt/jenkins"
# This is the initial script ran from inside the lxc container.
# Called by: container_run.sh
# Calls    : libs.sh, run_set.sh

mainscript="mainscript_testing"
exportfile="report"
runsetparams=""
echo "========= Beginning container guest scripts."
while getopts ":rsa" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        mainscript="mainscript_regression"
        exportfile="regression"
        runsetparams=" -r"
      ;;
    s ) echo $currentscript" status option selected."
        mainscript="mainscript_status"
        exportfile="status"
        runsetparams=" -s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        mainscript="mainscript_acceptance"
        exportfile="acceptance"
        runsetparams=" -a"
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s] [-a]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
      ;;
  esac
done

# Part 1: Basic container debug
echo "Entered container at: "$(pwd)
echo "Network test:"
ping -c 1 www.google.com

# Part 2 Configure Local Jenkins Dependencies
#  2a Copy project scripts
cd $hostspace
cp *.sh /root/
mkdir /root/sets/
cp -r sets/* /root/sets/

#  2b Set kcc dependencies
export PATH=$hostspace/kcc_dependency_1:$hostspace/kcc_dependency_2:$hostspace/kcc_dependency_3/bin:$PATH
echo "The modified container PATH variable: "$PATH

echo "k-bin-to-text debug"
which k-bin-to-text
ls -la $hostspace/kcc_dependency_3/bin
echo k-bin-to-text
errorstring="Error: Could not find or load main class org.kframework.main.BinaryToText"
echo "Checking to see if "$(k-bin-to-text)" is equal to "$errorstring
if [[ $(k-bin-to-text) == $errorstring ]] ; then
    echo "It was equal, so starting kserver with \"kserver &\"..."
    kserver &
else
    echo "It was not equal so we assume kserver was already started."
fi
echo "</placement debug>"

# Part 3 Run Main Script
mainscript_testing() {
    bash libs.sh
    #bash tests/getty/test.sh
    #bash run_set.sh sets/crashless.ini
    #bash run_set.sh sets/temporary.ini
    bash merge.sh sets/crashless.ini
    #cp results/status.xml $hostspace/results/
}
mainscript_regression() {
    bash libs.sh
    #bash run_regression_set.sh sets/regression.ini
    # The following line should be the one used after issue 14 is fixed.
    bash merge.sh$runsetparams sets/regression.ini
}
mainscript_status() {
    bash status.sh$runsetparams sets/crashless.ini
}
mainscript_acceptance() {
    bash libs.sh
    bash merge.sh$runsetparams sets/acceptance.ini
}
cd /root/ && $mainscript

# Part 4 Copy test result xml back to host
echo "Container results are in "$exportfile".xml:"
cat results/$exportfile.xml
echo "Copying results to host now."
cp results/$exportfile.xml $hostspace/results/
echo "========== Finished container guest scripts."
