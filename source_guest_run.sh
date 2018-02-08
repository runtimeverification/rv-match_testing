#!/bin/bash
hostspace="/mnt/jenkins-source"

# Part 1: Basic container debug
printf "\nEntered container at: "$(pwd)
echo "Contents of this current folder:"
ls

printf "\nHost folder seen from: $hostspace"
echo "Host folder contents:"
ls "$hostspace"

printf "\nContents of /root folder here:"
ls /root

printf "\nBasic network test, not that we need it here in the source container, but to debug container networking since it should be working here."
ping -c 1 www.google.com

printf "\nCopying rv-match from jenkins space to /root/ folder here."
cd /root/
cp -r "$hostspace/" .

printf "\nContents of local folder $(pwd):"
ls

printf "\nEntering rv-match/k folder:"
cd /k/
ls

printf "\nInstalling maven."
sudo apt update
sudo apt -y build-dep maven
sudo apt -y install maven

printf "\nBuilding rv-match/k with maven for using k-bin-to-text."
mvn package

printf "\nInstalling basic libraries to be used by rv-match_testing in copied containers."
bash libs.sh

printf "\nIf all went well, source container is now considered ready for copying."
