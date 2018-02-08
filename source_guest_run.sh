#!/bin/bash
hostspace="/mnt/jenkins-source"
set -e

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
cp -r "$hostspace" .
mv jenkins-source/ rv-match/
mv rv-match/rv-match_testing/ ./rv-match_testing

printf "\nContents of local folder $(pwd):"
ls

printf "\nEntering rv-match/k folder:"
cd rv-match/k/
ls

printf "\nInstalling maven.\n"
sudo apt update
sudo apt -y install build-essential m4 openjdk-8-jdk libgmp-dev libmpfr-dev pkg-config flex z3 maven opam

printf "\nBuilding rv-match/k with maven for using k-bin-to-text.\n"
mvn package -DskipTests

printf "\nMaking sure that k-bin-to-text works.\n"
set +e
which k-bin-to-text
ls k-distribution/target/release/k/bin
echo "exporting PATH variable here"
set -e
export PATH=$(pwd)/k-distribution/target/release/k/bin:$PATH
which k-bin-to-text

printf "\nInstalling basic libraries to be used by rv-match_testing in copied containers."
bash libs.sh

printf "\nIf all went well, source container is now considered ready for copying."
