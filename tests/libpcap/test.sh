#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/the-tcpdump-group/libpcap.git
    cd libpcap/
    git checkout 3b67275e19d04d493bb2dfc4050332fb27217b95
}

_build() {
    cd libpcap/
    aclocal; autoreconf
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init