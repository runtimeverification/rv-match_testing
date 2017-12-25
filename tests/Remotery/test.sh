#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/Celtoys/Remotery.git
    cd Remotery/
    git checkout 4070513159ff3a72f12a47a249ce0e51abf19c34
}

_build() {
    cd Remotery/ ; configure_success="$?"
    if [[ $compiler == "kcc" ]] ; then
        $compiler -d lib/Remotery.c sample/sample.c -I lib -pthread -lm |& tee kcc_make_out.txt ; make_success="$?"
    else
        $compiler lib/Remotery.c sample/sample.c -I lib -pthread -lm |& tee kcc_make_out.txt ; make_success="$?"
    fi
}

_export() {
    cd Remotery/ && process_kcc_config
    cd Remotery/ && cp kcc_* $log_dir
}

init
