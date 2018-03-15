#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libpcap-dev
}

_download() {
    git clone https://github.com/the-tcpdump-group/tcpdump.git
    cd tcpdump/
    git checkout af974494da71f2dae8eeac40e1611db5d6a82668 # version 4.8
    #git checkout b524a7d97c865bd50abc012f70963350219cf492 # version we originally were using
}

_build() {
    cd tcpdump/
    #sudo apt intall libpcap-dev
    aclocal; autoreconf
    ./configure CC="$compiler -std=gnu11" LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    cd tcpdump/tests/
    names[0]="isup.pcap"
    ../tcpdump -S -t -q -n -r ./isup.pcap |& tee kcc_out_0.txt ; results[0]="$?" ; process_config 0
    names[1]="TESTrun.sh"
    bash TESTrun.sh              |& tee kcc_out_1.txt ; results[1]="$?" ; process_config 1
}

init
