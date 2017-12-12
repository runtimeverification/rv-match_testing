#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/mstegen/Open-Chargeport.git
    cd Open-Chargeport/
    git checkout 4fdffded66910fe04250e5dc19f3d89ede9bd17c
}

_build() {
    return
    |& tee kcc_configure_out.txt ; configure_success="$?"
    |& tee kcc_make_out.txt ; make_success="$?"
}

_extract() {
    cd Open-Chargeport/ && process_kcc_config
    cd Open-Chargeport/ && cp kcc_* $log_dir
}

init

