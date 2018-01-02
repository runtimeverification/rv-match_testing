#!/bin/bash
echo "Hello, world from "$(pwd)
#find . -type d

# Part 1 Network Test
echo " === Network testing. === "
ping -c 1 www.google.com

# Part 2 Configure Local Jenkins Dependencies
#  2a Copy project scripts
hostspace="/mnt/jenkins"
mkdir -p tests/helloworld/
touch tests/helloworld/test.sh
cd $hostspace
cp tests/helloworld/test.sh /root/tests/helloworld/test.sh
cp run_set.sh /root/run_set.sh
mkdir /root/sets/
cp -r sets/* /root/sets/
echo " === These are what is in the sets directory: "
ls /root/sets/
cp prepare.sh /root/prepare.sh
cp libs.sh /root/libs.sh
cd /root/
echo " == Should be the same "
ls sets/

#  2b Set kcc dependencies
export PATH=$hostspace/kcc_dependency_1:$hostspace/kcc_dependency_2:$hostspace/kcc_dependency_3/bin:$PATH
echo "New guest path: "$PATH

echo "k-bin-to-text placement test"
which k-bin-to-text
ls -la $hostspace/kcc_dependency_3/bin
echo "</placement test>"

# Part 3 Install Libraries (apt install etc.)
bash libs.sh

# Part 4 Run Main Script
bash run_set.sh sets/crashless.ini
#bash tests/getty/test.sh

# Part 5 Copy test result xml back to host
ls
ls results/
cat results/report.xml
echo "Copying results here: "
cp results/report.xml $hostspace/results/
