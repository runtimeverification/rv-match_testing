#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/antirez/redis.git
    cd redis/
    git checkout 727dd43614ec45e23e2dedbba08b393323feaa4f
}

_build() {
    cd redis/ ; configure_success="$?"
    make CC=$compiler LD=$compiler |& tee kcc_make_out.txt ; make_success="$?"
    if [ "$make_success" == "0" ] ; then
        make test CC=$compiler LD=$compiler |& tee kcc_make_out.txt ; make_success="$?"
    fi
}

_test() {
    :
}

init
