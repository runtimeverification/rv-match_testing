#!/bin/bash
echo "Hello, world from "$(pwd)
ls
mkdir -p tests/helloworld/
touch tests/helloworld/test.sh
ls
ls tests/helloworld/
ls /mnt/jenkins/
cd /mnt/jenkins/
ls
cp tests/helloworld/test.sh ../../tests/helloworld/test.sh
ls
echo "huh?"
ls ../..
echo "uh."
ls
cd ../..
echo "hrm"
ls
bash tests/helloworld/test.sh
