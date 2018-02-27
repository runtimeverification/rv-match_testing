#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install pkg-config
    sudo apt -y install libnl-3-dev
    sudo apt -y install libnl-route-3-dev
    sudo apt -y install libnl-genl-3-dev
}

_download() {
    git clone git://w1.fi/hostap.git
    cd hostap/
    git checkout af872d9d88b1c868279983ef2c1b65ff81d7347b
}

_build() {
    cd hostap/hostapd/
    if [[ "$compiler" == "kcc" ]] ; then
        export CFLAGS="-std=gnu11 -frecover-all-errors"
    else
        export CFLAGS="-std=gnu11"
    fi
    cp defconfig .config
    sed -i '/CONFIG_LIBNL32=y/s/^#//g' .config
    sed -i '157iOBJS_c += ../src/utils/wpabuf.o' Makefile ; results[0]="$?" ; process_kcc_config 0
    CC=$compiler make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

init
