#!/bin/bash
echo "Hello, world from "$(pwd)
ls
mkdir -p tests/helloworld/
touch tests/helloworld/test.sh
ls
ls tests/helloworld/
ls /mnt/jenkins/
echo "pwd is "$(pwd)
cd /mnt/jenkins/
echo "pwd is "$(pwd)
ls
cp tests/helloworld/test.sh /root/tests/helloworld/test.sh
cp run_set.sh /root/run_set.sh
mkdir /root/sets/
cp -r /sets/ /root/sets/
cp prepare.sh /root/prepare.sh
ls
echo "huh?"
ls ../../root/
echo "pwd is "$(pwd)
echo "uh."
ls
cd /root/
echo "pwd is "$(pwd)
echo "hrm"
ls
bash run_set.sh sets/quickset.ini
