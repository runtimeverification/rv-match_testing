#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    wget https://samate.nist.gov/SRD/testsuites/juliet/Juliet_Test_Suite_v1.3_for_C_Cpp.zip
}

_build() {
    unzip Juliet_Test_Suite_v1.3_for_C_Cpp.zip |& tee kcc_configure_out.txt ; configure_success="$?"
    rm Juliet_Test_Suite_v1.3_for_C_Cpp.zip
    cd C/ && make |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    return
}

init
