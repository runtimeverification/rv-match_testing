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
	names[0]="compile 1.1" ; make |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	cd ${mctbuilddir}/modern-cpp-tutorial/code/2/
	names[1]="compile 2.1" ; g++ --std=c++14 -o 2.1 2.1.cpp |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
	names[2]="compile 2.2" ; g++ --std=c++14 -o 2.2 2.2.cpp |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
	names[3]="compile 2.3" ; g++ --std=c++14 -o 2.3 2.3.cpp |& tee rv_build_3.txt ; results[3]="$?" ; postup 3
        names[4]="compile 2.4" ; g++ --std=c++14 -o 2.4 2.4.cpp |& tee rv_build_4.txt ; results[4]="$?" ; postup 4
	names[5]="compile 2.5" ; g++ --std=c++14 -o 2.5 2.5.cpp |& tee rv_build_5.txt ; results[5]="$?" ; postup 5
        #skip g++ --std=c++14 -o 2.6 2.6.cpp
        #skip g++ --std=c++14 -o 2.7 2.7.cpp
        names[6]="compile 2.8" ; g++ --std=c++14 -o 2.8 2.8.cpp |& tee rv_build_6.txt ; results[6]="$?" ; postup 6
	cd ${mctbuilddir}/modern-cpp-tutorial/code/3/
	#skip names[#]="compile 3.1" ; g++ --std=c++14 -o 3.1 3.1.cpp |& tee rv_build_#.txt ; results[#]="$?" ; postup #
	names[7]="compile 3.2" ; g++ --std=c++14 -o 3.2 3.2.cpp |& tee rv_build_7.txt ; results[7]="$?" ; postup 7
	names[8]="compile 3.3" ; g++ --std=c++14 -o 3.3 3.3.cpp |& tee rv_build_8.txt ; results[8]="$?" ; postup 8
	names[9]="compile 3.4" ; g++ --std=c++14 -o 3.4 3.4.cpp |& tee rv_build_9.txt ; results[9]="$?" ; postup 9
        names[10]="compile 3.5" ; g++ --std=c++14 -o 3.5 3.5.cpp |& tee rv_build_10.txt ; results[10]="$?" ; postup 10
        names[11]="compile 3.6" ; g++ --std=c++14 -o 3.6 3.6.cpp |& tee rv_build_11.txt ; results[11]="$?" ; postup 11
        cd ${mctbuilddir}/modern-cpp-tutorial/code/4/
	# skip compile 4.1
	names[12]="compile 4.2" ; g++ --std=c++14 -o 4.2 4.2.cpp |& tee rv_build_12.txt ; results[12]="$?" ; postup 12
	names[13]="compile 4.3" ; g++ --std=c++14 -o 4.3 4.3.cpp |& tee rv_build_13.txt ; results[13]="$?" ; postup 13
        cd ${mctbuilddir}/modern-cpp-tutorial/code/5/
	names[14]="compile 5.1" ; g++ --std=c++14 -o 5.1 5.1.cpp |& tee rv_build_14.txt ; results[14]="$?" ; postup 14
	names[15]="compile 5.2" ; g++ --std=c++14 -o 5.2 5.2.cpp |& tee rv_build_15.txt ; results[15]="$?" ; postup 15
	names[16]="compile 5.3" ; g++ --std=c++14 -o 5.3 5.3.cpp |& tee rv_build_16.txt ; results[16]="$?" ; postup 16
        cd ${mctbuilddir}/modern-cpp-tutorial/code/6/
	names[17]="compile 6.1" ; g++ --std=c++14 -o 6.1 6.1.cpp |& tee rv_build_17.txt ; results[17]="$?" ; postup 17
        cd ${mctbuilddir}/modern-cpp-tutorial/code/7/
	# skip 7.1
	# skip 7.2
        cd ${mctbuilddir}/modern-cpp-tutorial/code/8/
	names[18]="compile 8.1" ; g++ --std=c++14 -o 8.1 8.1.cpp |& tee rv_build_18.txt ; results[18]="$?" ; postup 18
	# skip 8.2
        cd ${mctbuilddir}/modern-cpp-tutorial/code/9/
	# skip 9.1
}

_test() {
	mcttestdir=$(pwd)
	cd ${mcttestdir}/modern-cpp-tutorial/code/1/
        names[0]="run 1.1" ; ./1.1 |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
        cd ${mcttestdir}/modern-cpp-tutorial/code/2/
	names[1]="run 2.1" ; ./2.1 |& tee rv_out_1.txt ; results[1]="$?" ; process_config 1
	names[2]="run 2.2" ; ./2.2 |& tee rv_out_2.txt ; results[2]="$?" ; process_config 2
	names[3]="run 2.3" ; ./2.3 |& tee rv_out_3.txt ; results[3]="$?" ; process_config 3
	names[4]="run 2.4" ; ./2.4 |& tee rv_out_4.txt ; results[4]="$?" ; process_config 4
	names[5]="run 2.5" ; ./2.5 |& tee rv_out_5.txt ; results[5]="$?" ; process_config 5
	# skip 2.6
	# skip 2.7
	names[6]="run 2.8" ; ./2.8 |& tee rv_out_6.txt ; results[6]="$?" ; process_config 6
        cd ${mcttestdir}/modern-cpp-tutorial/code/3/
	# skip 3.1
	names[7]="run 3.2" ; ./3.2 |& tee rv_out_7.txt ; results[7]="$?" ; process_config 7
	names[8]="run 3.3" ; ./3.3 |& tee rv_out_8.txt ; results[8]="$?" ; process_config 8
	names[9]="run 3.4" ; ./3.4 |& tee rv_out_9.txt ; results[9]="$?" ; process_config 9
	names[10]="run 3.5" ; ./3.5 |& tee rv_out_10.txt ; results[10]="$?" ; process_config 10
	names[11]="run 3.6" ; ./3.6 |& tee rv_out_11.txt ; results[11]="$?" ; process_config 11
        cd ${mcttestdir}/modern-cpp-tutorial/code/4/
	# skip 4.1
	names[12]="run 4.2" ; ./4.2 |& tee rv_out_12.txt ; results[12]="$?" ; process_config 12
	names[13]="run 4.3" ; ./4.3 |& tee rv_out_13.txt ; results[13]="$?" ; process_config 13
        cd ${mcttestdir}/modern-cpp-tutorial/code/5/
	names[14]="run 5.1" ; ./5.1 |& tee rv_out_14.txt ; results[14]="$?" ; process_config 14
	names[15]="run 5.2" ; ./5.2 |& tee rv_out_15.txt ; results[15]="$?" ; process_config 15
	names[16]="run 5.3" ; ./5.3 |& tee rv_out_16.txt ; results[16]="$?" ; process_config 16
        cd ${mcttestdir}/modern-cpp-tutorial/code/6/
	names[17]="run 6.1" ; ./6.1 |& tee rv_out_17.txt ; results[17]="$?" ; process_config 17
        cd ${mcttestdir}/modern-cpp-tutorial/code/7/
	# skip 7.1
	# skip 7.2
        cd ${mcttestdir}/modern-cpp-tutorial/code/8/
	names[18]="run 8.1" ; ./8.1 |& tee rv_out_18.txt ; results[18]="$?" ; process_config 18
	# skip 8.2
        cd ${mcttestdir}/modern-cpp-tutorial/code/9/
	# skip 9.1
}

init
