#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install autopoint
    sudo apt -y install texinfo
    sudo apt -y install gperf
    sudo apt -y install libgnutls-dev
}

_download() {
    git clone https://github.com/mirror/wget.git
    cd wget/
    git checkout 6aa6b669efbef62f60471c18e7fdef0206f92337
    ./bootstrap
}

_build() {
    cd wget/
    ./configure --disable-threads CC=$compiler LD=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    bash $base_dir/timeout.sh -t 2000 make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
