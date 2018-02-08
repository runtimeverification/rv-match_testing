#!/bin/bash
hostspace="/mnt/jenkins-source"

# Part 1: Basic container debug
echo "Entered container at: "$(pwd)
echo "Contents of this current folder:"
ls

echo "Host folder seen from: $hostspace"
echo "Host folder contents:"
ls "$hostspace"

echo "Contents of /root folder here:"
ls /root

echo "Basic network test, not that we need it here in the source container, but to debug container networking since it should be working here."
ping -c 1 www.google.com

echo "Copying rv-match from jenkins space to /root/ folder here."
cd /root/
cp "$hostspace/rv-match/" .
cd rv-match/k/

echo "Installing maven."
sudo apt -y install maven

echo "Building rv-match/k with maven for using k-bin-to-text."
mvn package

echo "Installing basic libraries to be used by rv-match_testing in copied containers."
bash libs.sh
