#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/openssl/openssl.git
    cd openssl/
    git checkout 5dd94f1847c744929a3bd24819f1c99644bb18c7
    # d166ed8c11e10e9fdaeac182effb9dd318843924 was from June 2016 and could be one of the last commits before md4test was removed, but it has build issues, so I'm using a commit from the last stable release before it which is from May 2016.
}

_build() {
    cd openssl/
    if [[ "$compiler" == "kcc" ]]; then
        CC="kcc -std=gnu11 -no-pedantic -frecover-all-errors -fissue-report=$json_out" CXX=k++ LD=$compiler ./config no-asm no-threads no-hw no-zlib no-shared |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    else
        CC=$compiler ./config no-asm no-threads no-hw no-zlib no-shared |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    fi
    make |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    cd openssl/
    names[0]="md4test"
    ./test/md4test |& tee "kcc_out_0.txt" ; results[0]="$?"
    names[1]="md5test"
    ./test/md5test |& tee "kcc_out_1.txt" ; results[1]="$?"
}


init
