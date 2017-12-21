#!/bin/bash
echo "Hello, world from "$(pwd)
mkdir tests/helloworld/
cp /mnt/jenkins/tests/helloworld/test.sh /tests/helloworld/test.sh
ls
bash tests/helloworld/test.sh
