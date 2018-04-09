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
    # categorize.sh  count.sh  dependency  download  fetch.sh  gcc  juliet.pl  kcc  report.xml  runner.pl  summary.sh  test.sh
    mydir=$(pwd)
    cd ../..
    cp runner.pl $mydir
    cp juliet.pl $mydir
    # fetch.sh categorize.sh
    cp count.sh $mydir
    cp summary.sh $mydir
    cd $mydir
    mkdir allc/
    find C -name '*.c' -exec mv {} allc \;
    mv allc/io.c C/testcasesupport/io.c
    mv allc/std_thread.c C/testcasesupport/std_thread.c
    cd C/testcasesupport/
    kcc -c io.c
    cd $mydir
    mkdir juliet
    mv allc juliet
    mv C juliet
    ./runner.pl
    #cd C/
    #names[0]="make" ; make -j 8 CC="$compiler -fissue-report=$json_out" |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
}

_test() {
    :
}

init
