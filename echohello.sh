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
cp prepare.sh /root/
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
bash tests/helloworld/test.sh
