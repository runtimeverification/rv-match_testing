#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y purge gettext
    sudo apt-get -y install gettext
    gettext --version
    apt-cache policy gettext
    sudo apt update
    sudo apt -y upgrade
}

_download() {
    strtdir=$(pwd)
    git clone git://anonscm.debian.org/dpkg/dpkg.git
    cd dpkg/
    git checkout b9798daaa596ad5d539bcdd5ca89de1cb0b81697
    cd $strtdir
    git clone https://anonscm.debian.org/git/dpkg/dpkg-tests.git
    cd dpkg-tests/
    git checkout 10b721dc31872a1f561e2a25ae2331d1add9bfd3
}

_build() {
    cd dpkg/
    autoscan
    aclocal
    autoheader
    autoreconf
    automake --add-missing
    autoreconf -vif
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc LD=kcc LDFLAGS="-lz" |& tee rv_build_0.txt ; results[0]="$?"
    else
        ./configure CC=$compiler |& tee rv_build_0.txt ; results[0]="$?"
    fi
    postup 0

    make -j 8 |& tee rv_build_1.txt ; results[1]="$?" ; postup 1

    if [ "$exportfile" == "regression" ] ; then return ; fi

    names[2]="make check"
    make -j 8 check |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    cd dpkg-tests/ ; ./db-regen
}

init
