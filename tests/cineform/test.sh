#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    # The following 4 lines installed 3.2.x but cineform needs 3.5.x
    #sudo -E add-apt-repository -y ppa:george-edison55/cmake-3.x
    #sudo apt-get update
    #sudo apt -y upgrade
    #sudo apt -y install cmake

    # Build takes forever, commented for now
    #cmake --version
    #strtatdir=$(pwd)
    #version=3.10
    #build=0
    #mkdir ./tempun1qu5ch4ract3r2
    #cd tempun1qu5ch4ract3r2/
    #wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
    #tar -xzvf cmake-$version.$build.tar.gz
    #cd cmake-$version.$build/
    #./bootstrap
    #make -j4
    #sudo make install
    #cmake --version
    #cd $strtatdir
    #rm -r tempun1qu5ch4ract3r2/
}

_download() {
    git clone https://github.com/gopro/cineform-sdk.git
    cd cineform-sdk/
    git checkout 81c9eb118a4f2a03a3194098623f0cbfd85f3561
}

_build() {
    cd cineform-sdk/
    CC=$compiler LD=$compiler cmake . |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

init
