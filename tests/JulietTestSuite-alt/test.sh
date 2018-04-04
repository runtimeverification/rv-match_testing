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
    julcompiler=$compiler
    if [ "$compiler" == "kcc" ] ; then
        julcompiler="kcc -fissue-report=$json_out"
    fi
    cd C/
    names[0]="sed" ; find . -name "Makefile" | sed -i 's/individuals: $(INDIVIDUALS_C) $(INDIVIDUALS_CPP)/individuals: $(INDIVIDUALS_C)/' |& tee rv_build_0.txt ; results[0]="$?"
    names[1]="configure" ; ./configure CC="$julcompiler" LD="$julcompiler" |& tee rv_build_1.txt ; results[1]="$?"
    names[2]="make" ; make -j 8 -i individuals |& tee rv_build_2.txt ; results[2]="$?"
}

_test() {
    :
}

init
