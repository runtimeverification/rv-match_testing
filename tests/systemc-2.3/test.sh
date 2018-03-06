#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/systemc/systemc-2.3.git
    cd systemc-2.3/
    git checkout 686336b03ea17374024df0ae8272d7e22ba2692f
    # '686336b03ea17374024df0ae8272d7e22ba2692f' is a commit by Accellera as a release for public review
}

_build() {
    # Note: C++ project
    cd systemc-2.3/
    names[0]="configure" ; ./configure CC=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="make"      ; make                     |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    :
}

init
