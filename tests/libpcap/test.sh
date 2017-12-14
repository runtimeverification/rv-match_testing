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
    ./configure CC="$compiler -std=gnu11 -Dlinux -D_BSD_SOURCE" LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
    if [[ make_success ]] ; then
        echo "make supposedly succeeded"
        cd tests/
        make CC="$compiler -std=gnu11 -Dlinux" LD=$compiler |& tee kcc_make_tests.txt ; make_success="$?"
    else
        echo "make supposedly failed"
    fi
}

_extract() {
    cd libpcap/ && process_kcc_config
    cd libpcap/ && cp kcc_* $log_dir
}

_test() {
    cd libpcap/tests/
    sudo ./opentest ; test_success="$?"
}

_extract_test() {
    cd libpcap/
    echo "Inside the _extract_test() function now."
}

init
