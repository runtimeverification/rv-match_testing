#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install linux-generic
    sudo apt -y install linux-headers-`uname -r`
}

_download() {
    git clone https://github.com/f0rb1dd3n/Reptile.git
    cd Reptile/
    git checkout 1bd1872315440c2c08d33f4470989b575e8293a6
    echo "Force Reptile re-download. Somehow it got a download hash without the download."
}

_build() {
    cd Reptile/ ; results[0]="$?" ; postup 0
    #sudo apt install linux-headers-$(uname -r)
    #apt -f install
    flaggedcompiler=$compiler" -no-pedantic -std=gnu11"
    CC=$flaggedcompiler LD=$flaggedcompiler make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
