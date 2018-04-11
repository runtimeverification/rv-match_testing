#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	:
}

_download() {
	git clone https://github.com/changkun/modern-cpp-tutorial.git
	cd modern-cpp-tutorial/
	git checkout 34593a802ae61abd07ec2bbc9c423603419fec6a # Tag v1.0.1
}

_build() {
	mctbuilddir=$(pwd)
	cd ${mctbuilddir}/modern-cpp-tutorial/code/1/
	names[0]="compile 1" ; make |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	cd ${mctbuilddir}/modern-cpp-tutorial/code/2/
	cd ${mctbuilddir}/modern-cpp-tutorial/code/3/
        cd ${mctbuilddir}/modern-cpp-tutorial/code/4/
        cd ${mctbuilddir}/modern-cpp-tutorial/code/5/
        cd ${mctbuilddir}/modern-cpp-tutorial/code/6/
        cd ${mctbuilddir}/modern-cpp-tutorial/code/7/
        cd ${mctbuilddir}/modern-cpp-tutorial/code/8/
        cd ${mctbuilddir}/modern-cpp-tutorial/code/9/
}

_test() {
	mcttestdir=$(pwd)
	cd ${mcttestdir}/modern-cpp-tutorial/code/1/
        names[0]="run 1" ; ./1.1 |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
        cd ${mcttestdir}/modern-cpp-tutorial/code/2/
        cd ${mcttestdir}/modern-cpp-tutorial/code/3/
        cd ${mcttestdir}/modern-cpp-tutorial/code/4/
        cd ${mcttestdir}/modern-cpp-tutorial/code/5/
        cd ${mcttestdir}/modern-cpp-tutorial/code/6/
        cd ${mcttestdir}/modern-cpp-tutorial/code/7/
        cd ${mcttestdir}/modern-cpp-tutorial/code/8/
        cd ${mcttestdir}/modern-cpp-tutorial/code/9/
}

init
