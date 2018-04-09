#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	sudo apt -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 software-properties-common libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
	sudo add-apt-repository ppa:bitcoin/bitcoin
	sudo apt-get update
	sudo apt-get install libdb4.8-dev libdb4.8++-dev
}

_download() {
	git clone https://github.com/bitcoin/bitcoin.git
	cd bitcoin/
	git checkout 4b4d7eb255ca8f9a94b92479e6061d129c91a991 # tagged as official commit of version 0.16
}

_build() {
	cd bitcoin/
	names[0]="autogen"   ; ./autogen.sh |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	names[1]="configure" ; ./configure  |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
	names[2]="make"      ; make         |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
	names[0]="make check" ; make check |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
