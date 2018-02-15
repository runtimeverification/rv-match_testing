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
    ./configure --disable-threads CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    bash $base_dir/timeout.sh -t 2000 make |& tee kcc_make_out.txt ; make_success="$?"
}

init
