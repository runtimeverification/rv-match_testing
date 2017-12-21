#!/bin/bash
echo "Hello, world from "$(pwd)
ls
mkdir -p tests/helloworld/
touch tests/helloworld/test.sh
cd /mnt/jenkins/
cp tests/helloworld/test.sh /root/tests/helloworld/test.sh
cp run_set.sh /root/run_set.sh
mkdir /root/sets/
cp -r /sets/* /root/sets/
echo " === These are what is in the sets directory: "
ls /root/sets/
cp prepare.sh /root/prepare.sh
cd /root/
echo " == Should be the same "
ls /sets/
bash run_set.sh sets/quickset.ini
