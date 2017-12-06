#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/the-tcpdump-group/tcpdump.git
    cd tcpdump/
    git checkout b524a7d97c865bd50abc012f70963350219cf492
}

_build() {
    cd tcpdump/
    aclocal; autoreconf
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& kcc_make_out.txt ; make_success="$?"
}
