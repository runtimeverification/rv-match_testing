#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/antirez/redis.git
    cd redis/
    git checkout 727dd43614ec45e23e2dedbba08b393323feaa4f
}

_build() {
    cd redis/ ; results[0]="$?" ; process_kcc_config 0
    make CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    if [ "$results[1]" == "0" ] ; then
        make test CC=$compiler LD=$compiler |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
    fi
}

_test() {
    :
}

init
