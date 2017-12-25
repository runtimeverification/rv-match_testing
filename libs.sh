printheader="In libs.sh section: "
sudo apt-get update
sudo apt -y upgrade

echo $printheader"helloworld"
sudo apt -y install bash
sudo apt -y install gcc
sudo apt -y install build-essential
sudo apt -y install perl
sudo apt -y install git-all

echo $printheader"prepare.sh"
sudo apt -y install bc

echo $printheader"bind9"
sudo apt -y install openssl
sudo apt -y install libssl-dev

echo $printheader"bogosort"
which cpan
cpan String::Escape
cpan Getopt::Declare
cpan UUID::Tiny

echo $printheader"cFE"
sudo apt -y install cmake
cmake --version
sudo apt -y install libc6
sudo apt -y install libc6-dev
sudo apt -y install libc6-dev-i386
sudo apt -y install g++-multilib

echo $printheader"cineform"
sudo -E add-apt-repository -y ppa:george-edison55/cmake-3.x
sudo apt-get update
sudo apt -y upgrade
sudo apt -y install cmake

echo $printheader"curl"
#See bind9: sudo apt -y install libssl-dev

echo $printheader"dpkg"
sudo apt -y install autotools-dev
sudo apt -y install dh-autoreconf
sudo apt -y install gettext

echo $printheader"FFmpeg"
sudo apt -y install yasm

echo $printheader"hostapd"
sudo apt -y install pkg-config

echo $printheader"libpcap"
sudo apt -y install bison
sudo apt -y install flex

echo $printheader"lua"
sudo apt -y install libreadline-dev

echo $printheader"makefs"
sudo apt -y install fuse
sudo apt -y install libfuse-dev

echo $printheader"mawk"
sudo apt -y install apt
apt --version
sudo apt -y dist-upgrade

echo $printheader"netdata"
sudo apt -y install zlib1g-dev

echo $printheader"php-src"
# See cFE, may fix this, too "configure: error: C compiler cannot create executables": sudo apt install libc6-dev

echo $printheader"Reptile"
sudo apt -y install linux-generic
sudo apt -y install linux-headers-`uname -r`

echo $printheader"spin"
# See libpcap: sudo apt -y install bison

echo $printheader"tcpdump"
sudo apt -y install libpcap-dev

echo $printheader"tmux"
sudo apt -y install libevent-dev

echo $printheader"vim"
sudo apt -y install ncurses-dev
sudo apt -y install libncurses5-dev
sudo apt -y install libncursesw5-dev
sudo apt -y build-dep vim

echo $printheader"wget"
sudo apt -y install autopoint
sudo apt -y install texinfo
sudo apt -y install gperf

echo $printheader"[For any remaining apt kinks...]"
sudo apt update
sudo apt -y upgrade
