#!/bin/bash
echo "Hello, world from "$(pwd)
mkdir -p tests/helloworld/
ls /mnt/jenkins/
cd /mnt/jenkins/
ls
cp tests/helloworld/test.sh ../../tests/helloworld/test.sh
ls
cd ../..
bash tests/helloworld/test.sh
