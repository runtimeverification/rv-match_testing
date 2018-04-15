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
    echo "force"
    git checkout 5244cab52de6ba99ae174c040b0973665fa590b8
}

_build() {
    # Note: non-trivial linking
    cd knot/
    names[0]="autoreconf"   ; autoreconf -if            |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"    ; ./configure CC=$compiler  |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"         ; make -j`nproc`                 |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
    names[3]="make install" ; sudo make -j`nproc` install    |& tee rv_build_3.txt ; results[3]="$?" ; postup 3
    names[4]="ldconfig"     ; sudo ldconfig             |& tee rv_build_4.txt ; results[4]="$?" ; postup 4
    # https://gitlab.labs.nic.cz/knot/knot-dns/issues/571
    # "@TimJSwan89 Do you have any reason to explicitly set LD? The implicit value on the same system is /usr/bin/ld -m elf_x86_64."
}

_test() {
	cd knot/
	names[0]="knotd server" ; knotd -c ./samples/knot.sample.conf |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
	
}

init
