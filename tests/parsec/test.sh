#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    #http://parsec.cs.princeton.edu/download.htm
    wget http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-core.tar.gz
    tar -xzf parsec-3.0-core.tar.gz
    rm parsec-3.0-core.tar.gz
}

_build() {
    cd parsec-3.0/
    names[0]="sed out ssl docs"
    sed -i -e 's/all install_docs install_sw/all install_sw/' pkgs/libs/ssl/src/Makefile.org |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="sed out gsl docs"
    sed -i -e 's/bspline doc/bspline/'                        pkgs/libs/gsl/src/Makefile.in  |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    names[2]="parsecmgmt"
    bin/parsecmgmt -a build |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
}

_test() {
    :
}

init
