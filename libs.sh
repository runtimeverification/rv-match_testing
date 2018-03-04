#!/bin/bash
currentscript="libs.sh"
oldcontainer="1"
while getopts ":o" opt; do
  case ${opt} in
    o ) echo $currentscript" old container option selected."
        oldcontainer="0"
      ;;
    \? ) echo $currentscript" usage: cmd [-o]"
         echo " -o old container"
      ;;
  esac
done

echo $currentscript" pre-flushing apt"
sudo apt-get update
sudo apt -y upgrade
sudo apt-key update
sudo apt-get update

sudo dpkg --configure -a

echo $currentscript" merged.sh"
sudo apt -y install html-xml-utils

echo $currentscript" kcc"
sudo apt -y install libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg
sudo apt -y install libffi-dev

echo $currentscript" test.sh common dependencies"
sudo apt -y install bash
sudo apt -y install gcc
sudo apt -y install build-essential
sudo apt -y install perl
sudo apt -y install git-all
sudo apt -y install autotools-dev
sudo apt -y install dh-autoreconf
sudo apt -y install cmake

echo $currentscript" prepare.sh"
sudo apt -y install bc

echo $currentscript" post-flushing apt"
sudo apt update
sudo apt -y upgrade

if [ "$oldcontainer" == "0" ] ; then
    echo $currentscript" cpan"
    which cpan
    cpan YAML
    cpan String::Escape
    cpan Getopt::Declare
    cpan UUID::Tiny
fi
