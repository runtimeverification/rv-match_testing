#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt-get -y install libtool autoconf make pkg-config liburcu-dev libgnutls28-dev libedit-dev
    #sudo apt-get -y install liblmdb-dev
    #sudo apt-get -y install libcap-ng-dev libsystemd-dev libidn11-dev protobuf-c-compiler libfstrm-dev
}

_download() {
    git clone https://github.com/CZ-NIC/knot.git
    cd knot/
    git checkout 5244cab52de6ba99ae174c040b0973665fa590b8
}

_build() {
    cd knot/
    names[0]="autoreconf" ; autoreconf -if                        |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="configure"  ; ./configure CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    names[2]="make"       ; make                                  |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
    #https://gitlab.labs.nic.cz/knot/knot-dns/issues/571
}

_test() {
    :
}

init
