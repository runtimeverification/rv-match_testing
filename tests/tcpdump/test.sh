#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libpcap-dev
}

_download() {
    git clone https://github.com/the-tcpdump-group/tcpdump.git
    cd tcpdump/
    git checkout b524a7d97c865bd50abc012f70963350219cf492
}

_build() {
    cd tcpdump/
    #sudo apt intall libpcap-dev
    aclocal; autoreconf
    ./configure CC="$compiler -std=gnu11" LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    cd tcpdump/tests/
    bash TESTrun.sh && test_success="$?"
}

init
