#!/bin/bash
echo "Hello, world from "$(pwd)
cd /mnt/jenkins/
ls
bash tests/helloworld/test.sh
