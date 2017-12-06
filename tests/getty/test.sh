#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/StarchLinux/getty.git
    cd getty/
    git checkout a6c24ec43804588a3c35c9ed3325ed3086ddd056
}

_build() {
    cd getty/ ; configure_success="$?"
    make CC=$compiler LD=$compiler |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd getty/ && process_kcc_config
    cd getty/ && mv kcc_* $log_dir
}

init
