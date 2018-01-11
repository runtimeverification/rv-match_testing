#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/rsmarples/dhcpcd.git
    cd dhcpcd/
    git checkout ad23fe653d8ad6a87e284fd9c93a6e55f865eb13
}

_build() {
    cd dhcpcd/
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    set -o pipefail
    make |& tee kcc_make_out.txt
    [ -f src/dhcpcd ] ; make_success="$?"
}

init
