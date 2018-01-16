#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/rsmarples/dhcpcd.git
    cd dhcpcd/
    git checkout 7a3669251dca114f259e6c140a315e4e85fbd10f
}

_build() {
    cd dhcpcd/
    ./configure CC=$compiler CFLAGS="-D__packed='__attribute__((packed))' -frecover-all-errors" LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    set -o pipefail
    make |& tee kcc_make_out.txt
    [ -f src/dhcpcd ] ; make_success="$?"
}

init
