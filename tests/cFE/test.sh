#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    wget "https://sourceforge.net/projects/coreflightexec/files/cFE-6.5.0a-OSS-release.tar.gz"
    tar -xvzf cFE-6.5.0a-OSS-release.tar.gz
    wget "https://sourceforge.net/projects/osal/files/osal-4.2.1a-release.tar.gz"
    tar zxf osal-4.2.1a-release.tar.gz
    cd osal-4.2.1a-release/src/os/
    ln -sf posix posix-ng
    cd ../../../cFE-6.5.0-OSS-release/
    rm -r osal
    ln -s ../osal-4.2.1a-release ./osal
    rm -r build/
    mkdir build/
    # sudo apt install libc6-dev-i386
    # Refer to the other files for getting rvpc to work
}

_build() {
    cd cFE-6.5.0-OSS-release/build/
    export SIMULATION=native
    #cmake -DCMAKE_C_COMPILER=gcc -DENABLE_UNIT_TESTS=TRUE --build ../cfe
    #make mission-all
    cmake -DCMAKE_C_COMPILER=$compiler -DENABLE_UNIT_TESTS=TRUE --build ../cfe ; configure_success="$?"
    make mission-all ; make_success="$?"
}

_extract() {
    return
}

init
