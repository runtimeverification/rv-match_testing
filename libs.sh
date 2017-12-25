printheader="In libs.sh section: "

echo $printheader"helloworld"
sudo apt-get update
sudo apt -y upgrade
sudo apt -y install gcc
sudo apt -y install build-essential
sudo apt -y install perl
sudo apt -y install git-all

echo $printheader"prepare.sh"
sudo apt -y install bc

echo $printheader"bind9"
sudo apt -y install openssl

echo $printheader"bogosort"
which cpan
cpan String::Escape
cpan Getopt::Declare
cpan UUID::Tiny

echo $printheader"cFE"
sudo apt -y install cmake

echo $printheader"dpkg"
sudo apt -y install autotools-dev
sudo apt -y install dh-autoreconf

echo $printheader"FFmpeg"
sudo apt -y install yasm

echo $printheader"hostapd"
sudo apt -y install pkg-config

echo $printheader"libpcap"
sudo apt -y install flex

echo $printheader"lua"
sudo apt -y install libreadline-dev

echo $printheader"makefs"
sudo apt -y install fuse

echo $printheader"mawk"
sudo apt -y install apt

echo $printheader"Reptile"
sudo apt -y install linux-generic
sudo apt -y install linux-headers-4.10.0-42-generic

echo $printheader"spin"
sudo apt -y install yacc

echo $printheader"tcpdump"
sudo apt -y install libpcap-dev

echo $printheader"vim"
sudo apt -y install ncurses-dev
sudo apt -y install libncurses5-dev
sudo apt -y install libncursesw5-dev
sudo apt -y build-dep vim

echo $printheader"wget"
sudo apt -y install autopoint
sudo apt -y install makeinfo
sudo apt -y install gperf

echo $printheader"[For any remaining apt kinks...]"
sudo apt update
sudo apt -y upgrade
