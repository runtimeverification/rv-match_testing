#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
	git clone https://github.com/BIRD/bird.git
	cd bird/
	git checkout 4d3d34f5997128824c376a097eee60954c3611cf # Tag v2.0.2
	#git checkout d6cf996151307d083c30e4ecde0f1d7449b19253
}

_build() {
    # BIRD supports either IPv4 or IPv6 protocol, but have to be compiled separately for each one. Therefore, a dualstack router would run two instances of BIRD (one for IPv4 and one for IPv6), with completely separate setups (configuration files, tools ...). http://bird.network.cz/?get_doc&v=16&f=bird-1.html#ss1.1
    cd bird/
    names[0]="autoreconf" ; autoreconf  |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"  ; ./configure CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"       ; make -j`nproc`   |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
