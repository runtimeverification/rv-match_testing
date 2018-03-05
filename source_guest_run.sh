#!/bin/bash
hostspace="/mnt/jenkins-source"
set -e

# Part 1: Basic container debug
printf "\nEntered container at: "$(pwd)
echo "Contents of this current folder:"
ls

printf "\nHost folder seen from: $hostspace"
echo "Host folder contents:"
ls "$hostspace"

printf "\nContents of /root folder here:"
ls /root

printf "\nBasic network test, not that we need it here in the source container, but to debug container networking since it should be working here."
ping -c 1 www.google.com

printf "\nCopying rv-match from jenkins space to /root/ folder here.\n"
cd /root/
cp -r "$hostspace" .
mv jenkins-source/ rv-match/
mv rv-match/rv-match_testing/ ./rv-match_testing

printf "\nContents of local folder $(pwd):\n"
ls

printf "\nEntering rv-match/k folder:\n"
cd rv-match/k/
ls

printf "\nInstalling maven.\n"
sudo apt update &> /dev/null
sudo apt -y install build-essential m4 openjdk-8-jdk libgmp-dev libmpfr-dev pkg-config flex z3 maven opam &> /dev/null

printf "\nBuilding rv-match/k with maven for using k-bin-to-text.\n"
mvn package -DskipTests &> /dev/null

printf "\nMaking sure that k-bin-to-text works...\n"
set +e
export PATH=$(pwd)/k-distribution/target/release/k/bin:$PATH
k-bin-to-text ; testout=$(echo "$?")
set -e
printf "\n  which test:\n"
which k-bin-to-text
printf "\n  return value test:\n"
[ "$testout" == "1" ]
printf "\nPassed! k-bin-to-text works in source container.\n"

# We don't care if installer fails as long as rvpc functions afterwards.
set +e
printf "\nInstalling rv-predict[c]\n" # uninstall "sudo dpkg -r rv-predict-c"
wget -q https://runtimeverification.com/predict/download/c?v=1.9 &> /dev/null
mv c\?v\=1.9 predict-c.jar
printf "


1
1
1
" > stdinfile.txt
cat stdinfile.txt | sudo java -jar predict-c.jar -console &> /dev/null ; rm stdinfile.txt

set -e
printf "\nAsserting rvpc functions.\n"
which rvpc &> /dev/null
rvpc -help &> /dev/null

set +e
printf "\nInstalling rv-predict[java]\n"
wget -q https://runtimeverification.com/predict/download/java?v=1.9 &> /dev/null
mv java\?v\=1.9 predict-java.jar
printf "
1

1
Y
1

1
" > stdinfile.txt
cat stdinfile.txt | sudo java -jar predict-java.jar -console &> /dev/null ; rm stdinfile.txt
export PATH=$PATH:/usr/local/RV-Predict/Java/bin
printf "\nAsserting 'rv-predict' command functions. [Assertion currently disabled]\n"
# set -e
which rv-predict #&> /dev/null
rv-predict -help #&> /dev/null

printf "\nInstalling the latest rv-match so copied containers can at least use some version of kcc without an install.\n"
cd /root/ ; wget -q https://runtimeverification.com/match/1.0/rv-match-linux-64-1.0-SNAPSHOT.jar &> /dev/null
printf "
1


1
y
1
1
" > stdinfile.txt
cat stdinfile.txt | java -jar rv-match-linux-64*.jar -console &> /dev/null ; rm stdinfile.txt
set -e ; which kcc

printf "\nInstalling basic libraries to be used by rv-match_testing in copied containers.\n"
set +e
which date
which bc
which fuser
set -e
cd /root/rv-match_testing/
bash libs.sh
i=0
if [ fuser /var/lib/dpkg/lock >/dev/null 2>&1 ] ; then
    echo "$report_string: $current_script: Waiting for other software managers to finish..."
fi
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    sleep 0.5
    ((i=i+1))
done
bash libs.sh
bash libs.sh

printf "\nAsserting that rv-match_testing self-unit-tests pass.\n"
cd /root/rv-match_testing/
set +e ; bash unit_test_run-set.sh ; testout="$?"
if [ "$testout" == "0" ] ; then
    echo "  self-unit-tests all passed."
else
    if [ "$testout" == "1" ] ; then
        echo "  self-unit-test(s) failed."
    else
        echo "  self-unit-tests did not process properly."
    fi
fi
set -e ; [ "$testout" == "0" ]

printf "\nIterating through all projects, installing their dependencies and downloading their source.\n"
cd /root/rv-match_testing/
bash generate_run_set.sh
bash run-set.sh -p _generated_all

printf "\nFlush apt through the basic libraries after project specific dependencies were installed.\n"
cd /root/rv-match_testing/
bash libs.sh

printf "\nIf all went well, source container is now considered ready for copying.\n"
