#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install zip
}

_download() {
    wget https://samate.nist.gov/SRD/testsuites/juliet/Juliet_Test_Suite_v1.3_for_C_Cpp.zip
    unzip -qq Juliet_Test_Suite_v1.3_for_C_Cpp.zip
    rm Juliet_Test_Suite_v1.3_for_C_Cpp.zip
}

_build() {
    #cd C/testcases/
    #bash ../../../../categorize.sh
    #cd ../..
    #../../runner.pl

    cd C/
    names[0]="make" ; make CC="$compiler -fissue-report=$json_out" |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
}

_test() {
    :
}

init
