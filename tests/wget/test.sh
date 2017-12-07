#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/mirror/wget.git
    cd wget/
    git checkout 6aa6b669efbef62f60471c18e7fdef0206f92337
    ./bootstrap
}

_build() {
    cd wget/
    ./configure --disable-threads CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd wget/ && process_kcc_config
    cd wget/ && mv kcc_* $log_dir
}

init
