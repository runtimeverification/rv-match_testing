#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install gperf
}

_download() {
    wget http://ftp.gnu.org/gnu/coreutils/coreutils-8.28.tar.xz
    tar xf coreutils-8.28.tar.xz
    cd coreutils-8.28/
}

_build() {
    cd coreutils-8.28/
    autoreconf
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc CFLAGS="-std=gnu11 -frecover-all-errors -no-pedantic" LD=kcc --disable-threads FORCE_UNSAFE_CONFIGURE=1 |& tee kcc_configure_out.txt ; configure_success="$?"
    else
        ./configure CC=$compiler --disable-threads FORCE_UNSAFE_CONFIGURE=1 |& tee kcc_configure_out.txt ; configure_success="$?"
    fi
    echo "COREUTILS DEBUG"
    cat config.log
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
