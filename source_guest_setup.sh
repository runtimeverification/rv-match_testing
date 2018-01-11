#!/bin/bash
hostspace="/mnt/jenkins"

# Part 1: Network test
echo "Entered source container at: "$(pwd)
echo "Network test:"
ping -c 1 www.google.com

# Part 2: Apt installs
cp $hostspace/libs.sh /root/libs.sh
cd /root/
echo "Run 0 of 4 complete. [libs.sh]"
bash libs.sh && echo "Run 1 of 4 complete. [libs.sh]"
bash libs.sh && echo "Run 2 of 4 complete. [libs.sh]"
bash libs.sh && echo "Run 3 of 4 complete. [libs.sh]"
bash libs.sh && echo "Run 4 of 4 complete. [libs.sh]"
