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

echo $printheader"bogosort"
which cpan
cpan String::Escape
cpan Getopt::Declare
cpan UUID::Tiny

echo $printheader"Reptile"
sudo apt -y install linux-generic

echo $printheader"[For any remaining apt kinks...]"
sudo apt update
sudo apt -y upgrade
