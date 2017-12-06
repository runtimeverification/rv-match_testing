#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    wget "https://sourceforge.net/projects/coreflightexec/files/cFE-6.5.0a-OSS-release.tar.gz"
    tar -xvzf cFE-6.5.0a-OSS-release.tar.gz
    cd cFE-6.5.0-OSS-release/
    rm -rf osal/
    git clone https://github.com/nasa/osal.git
    cd osal
    git checkout 7139592f04e47f7522b07b1ef9f84a21393df88a
    cd src/os
    ln -s posix posix-ng
    cd $build_dir/cFE-6.5.0-OSS-release/
    cp -r cfe/cmake/sample_defs/ cfe/sample_defs/
}

_build() {
    cd cFE-6.5.0-OSS-release/
    mkdir build-sim/
    cd build-sim/
    export SIMULATION=native
    cmake -DCMAKE_C_COMPILER=$compiler -DENABLE_UNIT_TESTS=TRUE ../cfe ; configure_success="$?"
    make ; make_success="$?"
}

_extract() {
    return
}

init

#you start by placing the osal directory under "osal" under the cfe directory
#for some reason it wants the os-specific code for the posix-ng platform which do
#esn't appear to be included in the repository
#so I just created a symlink from posix-ng to posix
#in osal/src/os
#then you copy cfe/cmake/sample_defs to sample_defs under the cfe root
#then you make a directory build-sim
#cd to it
#export SIMULATION=native
#and run cmake -DENABLE_UNIT_TESTS=TRUE ../cfe
#followed by make mission-all to build all the tests
#and then you cd into the native directory and run ctest
#that will build it for gcc
#so all you need to do to build it for rv-predict is
#add the -DCMAKE_C_COMPILER flag
