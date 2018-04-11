#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	:
}

_download() {
	git clone git://anongit.freedesktop.org/libreoffice/cppunit
	cd cppunit/
	git checkout a412733438e4a589069f4db2ae17bd6e32d07864 # not a particular commit
}

_build() {
	cd cppunit/
	names[0]="autoreconf -i" ; autoreconf -i |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	names[1]="configure" ; ./configure CXX=$compilerpp CC=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
	names[2]="make" ; make -j`nproc` |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
	cd cppunit/
	names[0]="make check" ; make -j`nproc` check |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
