#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/torvalds/linux.git
    cd linux/
    git checkout 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
}

_build() {
    cd linux/ && configure_success="$?"
    make mrproper CC=$compiler LD=$compiler |& tee kcc_make_out.txt && make_success="$?"
}

init
