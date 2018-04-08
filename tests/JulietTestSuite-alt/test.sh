#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install zip
}

_download() {
    wget -q https://samate.nist.gov/SRD/testsuites/juliet/Juliet_Test_Suite_v1.3_for_C_Cpp.zip
    unzip -qq Juliet_Test_Suite_v1.3_for_C_Cpp.zip
    rm Juliet_Test_Suite_v1.3_for_C_Cpp.zip
}

_build() {
    cp ../../match.sh .
    cp -r ../../skiplists/ .
    names[0]="testsuite script" ; bash match.sh build run |& tee rv_build_0.txt ; results[0]="$?"
    #julcompiler=$compiler
    #if [ "$compiler" == "kcc" ] ; then
    #    julcompiler="kcc -fissue-report=$json_out"
    #fi
    #julcompiler="kcc"
    #cd C/
    #names[0]="sed" ; find . -name "Makefile" -exec sed -i 's/individuals: $(INDIVIDUALS_C) $(INDIVIDUALS_CPP)/individuals: $(INDIVIDUALS_C)/' {} \; |& tee rv_build_0.txt ; results[0]="$?"
    #names[1]="make" ; make -i individuals CC="kcc -std=gnu11 -fno-native-compilation" |& tee rv_build_1.txt ; results[1]="$?"
}

_test() {
    :
}

init
